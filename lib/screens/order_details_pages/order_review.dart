import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/bloc/subscription_bloc.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/firebase/firebase_notification_listener.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/repository/configuration_repo.dart';
import 'package:ourprint/repository/order_repo.dart';
import 'package:ourprint/repository/subscription_repo.dart';
import 'package:ourprint/screens/file_config_page/file_config.dart';
import 'package:ourprint/screens/home_page/home_page.dart';
import 'package:ourprint/screens/order_charges/dynamic_charges.dart';
import 'package:ourprint/screens/order_charges/fixed_charges.dart';
import 'package:ourprint/screens/order_charges/per_page_charges.dart';
import 'package:ourprint/screens/order_charges/printing_charges.dart';
import 'package:ourprint/screens/order_details_pages/order_confirmed.dart';
import 'package:ourprint/screens/order_details_pages/page_counter_card.dart';
import 'package:ourprint/screens/order_details_pages/widgets/num_of_copies.dart';
import 'package:ourprint/screens/order_details_pages/widgets/subscription_page_exceeded.dart';
import 'package:ourprint/screens/payment/order_payment.dart';
import 'package:ourprint/utils/error_handling.dart';
import 'package:ourprint/utils/strings.dart';
import 'package:ourprint/widgets/dialog_boxes.dart';
import 'package:ourprint/widgets/error_snackbar.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class OrderReview extends StatefulWidget {
  final int address;

  const OrderReview({Key key, this.address}) : super(key: key);

  static open(context, OrderModel model, {address}) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderReview(address: address)),
      );

  @override
  _OrderReviewState createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  OrderPayment orderPayment;

  var deliveryCharges = {};

  Future<List<ConfigurationModel>> getDetails() async {
    int totalPages = await getPageCount();
    deliveryCharges = await OrderRepo.getOrderDeliveryCharges({
      'order_details': {
        'pdf_page_count': totalPages,
        'address': widget.address,
      }
    });
    return ConfigurationsRepo.getConfigs();
  }

  Future<int> getPageCount() async {
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    int pageCount = 0;
    for (var file in pdfBloc.files) {
      int index = pdfBloc.files.indexOf(file);
      final doc = await PdfDocument.openFile(file['file_path']);
      final numOfCopies = int.parse(pdfBloc.numOfCopiesCtrlss[index].text);
      pageCount += doc.pageCount * numOfCopies;
    }
    return pageCount;
  }

  @override
  void initState() {
    super.initState();
    future = getDetails();
    Future.delayed(Duration.zero).then((value) {
      orderPayment = OrderPayment(context);
      orderPayment.init();
    });
  }

  Future<List<ConfigurationModel>> future;
  num total = 0.0;
  double amountSaved = 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final pdfBloc = Provider.of<PDFBloc>(context);
    final subsBloc = Provider.of<SubscriptionBloc>(context);
    return FutureBuilder<List<ConfigurationModel>>(
      future: future,
      builder: (context, snap) {
        if (snap.hasError)
          return Material(child: CustomErrorWidget(error: snap.error));

        if (!snap.hasData) return Material(child: LoadingWidget());

        return Scaffold(
          appBar: AppBar(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FractionallySizedBox(
            widthFactor: 0.9,
            child: pdfBloc.orderType == OrderType.SUBSCRIPTION
                ? RaisedButton(
                    onPressed: () async {
                      var totalPages = await pdfBloc.getTotalPages();
                      print(totalPages);
                      if (totalPages < 20) {
                        _showPagesLimitDialog();
                        return;
                      }
                      var body = {
                        'user': await Prefs.getUserId(),
                        'order_files':
                            pdfBloc.files.map((e) => e['file_id']).toList(),
                        'amount': 0,
                        'address': widget.address,
                        'delivery_charge': deliveryCharges['charges'],
                        'status': 'confirmed',
                        'order_type': pdfBloc.orderTypeField,
                        'dependent_page_config':
                            jsonEncode(pdfBloc.dependentConfigPrice.toMap()),
                      };
                      final exceededPage = subsBloc.getExceededPage(pdfBloc);

                      if (exceededPage > 0) {
                        try {
                          LoadingWidget.showLoadingDialog(context);

                          var res = await OrderRepo.createSubscriptionOrder(
                            body,
                            isPaid: false,
                          );
                          await _saveOrderId(res['id']);
                          Navigator.pop(context);
                          return _showPageExceededDialog(res['id']);
                        } catch (e) {
                          Navigator.pop(context);
                          DialogBox.parseAndShowErrorDialog(context, e);
                        }
                        return;
                      }

                      try {
                        LoadingWidget.showLoadingDialog(context);
                        int pageCounter = subsBloc.getPageLeft(pdfBloc);

                        await SubscriptionRepo.changePageCounter(
                          pageCounter,
                          subsBloc.userSubscription.userSubscriptionId,
                        );

                        var result = await OrderRepo.createSubscriptionOrder(
                          body,
                          isPaid: true,
                        );
                        await _saveOrderId(result['id']);

                        await FirebaseNotificationListener.sendNotification();
                        BookingConfirmed.open(context);
                      } catch (e) {
                        print(e);
                        Navigator.pop(context);
                        DialogBox.parseAndShowErrorDialog(context, e);
                      }
                    },
                    child: Text('REVIEW AND CONFIRM'),
                  )
                : RaisedButton(
                    onPressed: () async {
                      var body = {
                        'user': await Prefs.getUserId(),
                        'order_files':
                            pdfBloc.files.map((e) => e['file_id']).toList(),
                        'amount': double.tryParse((total).toStringAsFixed(2)),
                        'address': widget.address,
                        'delivery_charge': deliveryCharges['charges'],
                        'status': 'confirmed',
                        'order_type': pdfBloc.orderTypeField,
                        'dependent_page_config':
                            jsonEncode(pdfBloc.dependentConfigPrice.toMap()),
                      };
                      try {
                        LoadingWidget.showLoadingDialog(context);
                        var result = await OrderRepo.createOrder(body);
                        await _saveOrderId(result['id']);
                        orderPayment.startRazorPay(result);
                      } catch (e) {
                        print(e);
                        Navigator.pop(context);
                        DialogBox.parseAndShowErrorDialog(context, e);
                      }
                    },
                    child: Text('CONFIRM AND PAY'),
                  ),
          ),
          body: ListView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 100),
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Order Review',
                      style: textTheme.title.copyWith(color: Color(0xFF173A50)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                title: Text(
                                  'Are you sure you want to cancel your order?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    OutlineButton(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                      onPressed: () =>
                                          HomePage.openAndRemoveUntil(context),
                                      child: Text(
                                        'YES',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    RaisedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('NO'),
                                    ),
                                    SizedBox(height: 4)
                                  ],
                                ),
                              ));
                    },
                    child: Text(
                      'CANCEL',
                      style: textTheme.caption
                          .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              if (pdfBloc.orderType == OrderType.SUBSCRIPTION) ...[
                FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 300)),
                    builder: (context, snap) {
                      if (snap.connectionState != ConnectionState.done)
                        return Container();
                      final exceededPage = subsBloc.getExceededPage(pdfBloc);
                      if (exceededPage < 0)
                        return Container(
                          color: theme.primaryColor,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: 12),
                              Text(
                                'Amount saved through subscription',
                                style: textTheme.caption.copyWith(fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '₹ ${amountSaved + deliveryCharges['charges']}',
                                // '₹ ${(total + deliveryCharges['charges']).toStringAsFixed(2)}',
                                style: textTheme.subtitle1.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: theme.accentColor,
                                ),
                              ),
                              // SizedBox(height: 12),
                            ],
                          ),
                        );
                      return Container();
                    }),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'Page Counters left: ${subsBloc.getPageLeft(pdfBloc)}',
                    style: textTheme.caption,
                  ),
                ),
              ],
              FutureBuilder<List<Map<String, dynamic>>>(
                  future: pdfBloc.getOrderDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return CustomErrorWidget(error: snapshot.error);
                    if (!snapshot.hasData) return LoadingWidget();
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshot.data.map((file) {
                          final fileName = file['file_name'];
                          final pageCount = file['page_count'];
                          final fileId = file['file_id'];
                          final nOfCopies = file['num_of_copies'];
                          double fileTotal = 0;
                          final index = snapshot.data.indexOf(file);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.only(top: 0),
                                title: Text(
                                  'File name',
                                  style: textTheme.caption,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '$fileName',
                                    style: textTheme.body2,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Order Details',
                                      style: textTheme.caption,
                                    ),
                                  ),
                                  if (pdfBloc.orderType ==
                                      OrderType.SUBSCRIPTION) ...[
                                    InkWell(
                                      onTap: () {
                                        _showInfo();
                                      },
                                      child: Icon(
                                        Icons.info_outline,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Page counter used: ',
                                      style: textTheme.caption
                                          .copyWith(color: Colors.black),
                                    ),
                                    Text(
                                      '${subsBloc.getPageUsed(pdfBloc, fileId)}',
                                      style: textTheme.caption
                                          .copyWith(color: Colors.green),
                                    )
                                  ]
                                ],
                              ),
                              SizedBox(height: 12),
                              ...file['configs'].map(
                                (config) {
                                  final configDetails = snap.data.firstWhere(
                                    (data) => data.id == config,
                                  );
                                  switch (configDetails.priceType) {
                                    case 'per_page':
                                      switch (configDetails.type) {
                                        case 'print':
                                          return PrintingCharges(
                                            sideConfig:
                                                snap.data.firstWhere((e) {
                                              return e.type == 'page' &&
                                                  file['configs']
                                                      .contains(e.id);
                                            }),
                                            cost: pdfBloc
                                                .getPrintingPerPageCharge(
                                                    index),
                                            pdfPageCount: pageCount,
                                            multiColorNotes:
                                                file['multi_color_notes'],
                                            printingConfig: configDetails,
                                            onCalculated: (charges) {
                                              fileTotal += charges;
                                              // total += charges;
                                            },
                                            unColoredPrintCharge:
                                                pdfBloc.getBWCharges(index),
                                          );
                                          break;
                                        default:
                                          if (configDetails.type == 'page')
                                            return Container();
                                          return PerPageCharges(
                                            // model: model,
                                            pdfPageCount: pageCount,
                                            configDetails: configDetails,
                                            onCalculated: (val) {
                                              fileTotal += val;
                                              // total += val;
                                            },
                                          );
                                      }
                                      break;
                                    case 'fixed':
                                      return FixedCharges(
                                        configDetails: configDetails,
                                        onCalculated: (val) {
                                          fileTotal += val;
                                          // total += val;
                                        },
                                      );
                                      break;
                                    case 'dynamic':
                                      return DynamicCharges(
                                        // model: model,
                                        numOfCopies: nOfCopies,
                                        pdfPageCount: pageCount,
                                        configDetails: configDetails,
                                        onCalculated: (val) {
                                          fileTotal += val;
                                          // total += val;
                                          amountSaved += val;
                                        },
                                      );
                                    default:
                                      return Container();
                                  }
                                },
                              ),
                              // model.isFreemium == true
                              //     ? Builder(
                              //         builder: (context) => FreemiumDiscount(
                              //           model: model,
                              //           printingCharges: printingCharges,
                              //           myConfigsList: myConfigsList,
                              //           onCalculated: (discount) => payableAmount -= discount,
                              //         ),
                              //       )
                              //     : Container(),
                              Builder(
                                builder: (_) => NumOfCopies(
                                  file: file,
                                  spiralConfig: snap.data.firstWhere(
                                    (e) =>
                                        file['configs'].contains(e.id) &&
                                        e.title == Strings.spiralBinding,
                                    orElse: () => null,
                                  ),
                                  total: fileTotal,
                                  onCalculated: (val) {
                                    fileTotal = val;
                                    total += fileTotal;
                                  },
                                ),
                              ),
                              SizedBox(height: 12),
                              Divider(height: 0, thickness: 1.4),
                            ],
                          );
                        }).toList());
                  }),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Delivery Charge',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: pdfBloc.orderType == OrderType.SUBSCRIPTION
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  Text(
                    '₹ ${deliveryCharges['charges']}',
                    style: TextStyle(
                      color: Colors.green,
                      decoration: pdfBloc.orderType == OrderType.SUBSCRIPTION
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  SizedBox(width: 4),
                  if (pdfBloc.orderType != OrderType.SUBSCRIPTION)
                    Text(
                      '₹ ${deliveryCharges['strike_amount']}',
                      style: TextStyle(
                          color: Colors.green,
                          decoration: TextDecoration.lineThrough),
                    ),
                ],
              ),
              Divider(height: 32),
              if (pdfBloc.orderType != OrderType.SUBSCRIPTION)
                FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 300)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done)
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Text('Payable Amount',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          trailing: Text(
                              '₹ ${(total + deliveryCharges['charges']).toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.green)),
                        );
                      return Container();
                    }),
            ],
          ),
        );
      },
    );
  }

  _saveOrderId(orderId) async {
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    bool hasError = false;
    LoadingWidget.showLoadingDialog(context);
    for (var val in pdfBloc.files) {
      if (val['file_id'] != null) {
        try {
          var response = await OrderRepo.updatePDFDetails(
              val['file_id'], {'order': orderId});
        } on Exception catch (e) {
          hasError = true;
          DialogBox.parseAndShowErrorDialog(context, e);
        }
      }
    }
    Navigator.pop(context);
    if (hasError) return Toast.show('Something Went Wrong!', context);
  }

  _showInfo() {
    showDialog(
        context: context,
        builder: (_) {
          return PageCounterCard();
        });
  }

  _showPageExceededDialog(orderId) {
    showDialog(
        context: context,
        builder: (_) {
          return SubsPageExceeded(orderId: orderId);
        });
  }

  _showPagesLimitDialog() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text('Sorry, total pages should be more than 20 pages'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Ok',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              )
            ],
          );
        });
  }
}
