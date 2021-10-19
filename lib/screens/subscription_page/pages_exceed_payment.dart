import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/bloc/subscription_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/order_file_model.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/repository/order_repo.dart';
import 'package:ourprint/repository/subscription_repo.dart';
import 'package:ourprint/screens/home_page/home_page.dart';
import 'package:ourprint/screens/order_charges/printing_charges.dart';
import 'package:ourprint/screens/payment/order_payment.dart';
import 'package:ourprint/utils/strings.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class PageExceedPayment extends StatefulWidget {
  final orderId;

  const PageExceedPayment({Key key, this.orderId}) : super(key: key);

  static open(context, orderId) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PageExceedPayment(orderId: orderId)));

  @override
  _PageExceedPaymentState createState() => _PageExceedPaymentState();
}

class _PageExceedPaymentState extends State<PageExceedPayment> {
  Future future;
  double totalAmount = 0;
  OrderPayment orderPayment;

  @override
  void initState() {
    super.initState();
    future = OrderRepo.getOrder(widget.orderId);
    Future.delayed(Duration.zero).then((value) {
      orderPayment = OrderPayment(context);
      orderPayment.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final pdfBloc = Provider.of<PDFBloc>(context);
    return FutureBuilder<OrderModel>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError) return CustomErrorWidget(error: snap.error);
          if (!snap.hasData) return LoadingWidget();
          return Scaffold(
            appBar: AppBar(),
            floatingActionButton: FractionallySizedBox(
              widthFactor: 0.9,
              child: RaisedButton(
                onPressed: () async {
                  final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
                  final subsBloc =
                      Provider.of<SubscriptionBloc>(context, listen: false);

                  int pageCounter = subsBloc.getPageLeft(pdfBloc);

                  await SubscriptionRepo.changePageCounter(
                    pageCounter,
                    subsBloc.userSubscription.userSubscriptionId,
                  );
                  orderPayment.startRazorPay({
                    'id': widget.orderId,
                    'amount': totalAmount,
                    'delivery_charge': 0,
                  });
                },
                child: Text('CONFIRM AND PAY'),
              ),
            ),
            body: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Order Review',
                        style:
                            textTheme.title.copyWith(color: Color(0xFF173A50)),
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
                                            color:
                                                Theme.of(context).accentColor),
                                        onPressed: () =>
                                            HomePage.openAndRemoveUntil(
                                                context),
                                        child: Text(
                                          'YES',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
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
                        style: textTheme.caption.copyWith(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Text('Order Details', style: textTheme.caption),
                ...snap.data.orderFiles.map((orderFileId) {
                  final index = snap.data.orderFiles.indexOf(orderFileId);
                  return FutureBuilder<OrderFileModel>(
                      future: OrderRepo.getOrderFile(orderFileId),
                      builder: (context, snap) {
                        if (snap.hasError)
                          return CustomErrorWidget(error: snap.error);
                        if (!snap.hasData) return LoadingWidget();
                        print('--------------------');
                        print(snap.data.exceededPageConfig);
                        final configs = List<ConfigurationModel>.from(
                          jsonDecode(snap.data.configList)
                              .map((e) => ConfigurationModel.fromMap(e)),
                        );
                        // print(configs);
                        return Column(
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
                                  '${snap.data.fileName}'
                                  ' (${snap.data.pdfPageCount} Pages)',
                                  style: textTheme.body2,
                                ),
                              ),
                            ),
                            Column(
                              children: snap.data.exceededPageConfig.map((e) {
                                final i =
                                    snap.data.exceededPageConfig.indexOf(e);
                                if (i ==
                                    snap.data.exceededPageConfig.length - 1)
                                  return Container();

                                final file = snap.data.exceededPageConfig[i];

                                final perPageCost = getPriceOfConfig(
                                    file['config_name'], configs);

                                if (List<String>.from(file['config_name'])
                                    .any((e) => e.contains('Sided'))) {
                                  return PrintingCharges(
                                    overExceed: true,
                                    sideConfig: pdfBloc.configurationList
                                        .firstWhere((e) {
                                      return e.type == 'page' &&
                                          file['config_name'].contains(e.title);
                                    }),
                                    cost:
                                        pdfBloc.getPrintingPerPageCharge(index),
                                    pdfPageCount: file['overused_pages'],
                                    multiColorNotes:
                                        pdfBloc.multiColorNotesCtrl.text,
                                    printingConfig: ConfigurationModel(
                                      title:
                                          file['config_name'].firstWhere((e) {
                                        return e
                                                .toLowerCase()
                                                .contains('color') ||
                                            e.contains(Strings.bw);
                                      }),
                                    ),
                                    onCalculated: (charges) {
                                      totalAmount += charges;

                                      Future.delayed(Duration.zero)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    },
                                    unColoredPrintCharge:
                                        pdfBloc.getBWCharges(index),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                                '${file['config_name'].join('\n')}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          PayableAmount(
                                            noOfPages: file['overused_pages'],
                                            cost: perPageCost,
                                            onCalculated: (val) {
                                              totalAmount += val;
                                              Future.delayed(Duration.zero)
                                                  .then((value) {
                                                setState(() {});
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '${file['overused_pages']} pgs x ',
                                            style: textTheme.caption,
                                          ),
                                          Text('Rs $perPageCost /pg',
                                              style: textTheme.caption),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      });
                }).toList(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text('Payable Amount',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  trailing: Text('₹ ${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.green)),
                )
              ],
            ),
          );
        });
  }

  double getPrice(noOfPages, cost) {}

  setPrice() {}

  double getPriceOfConfig(List configNames, List<ConfigurationModel> configs) {
    if (configNames.contains(Strings.oneSided)) {
      return configs.firstWhere((e) => e.title == Strings.oneSided).price;
    } else if (configNames.contains(Strings.bw) &&
        configNames.contains(Strings.twoSided)) {
      return configs.firstWhere((e) => e.title == Strings.twoSided).price;
    } else if (configNames.contains(Strings.bondPaper) &&
        configNames.contains(Strings.twoSided)) {
      return configs
          .firstWhere((e) => e.title.startsWith(Strings.bondPaper))
          .price;
    }
    return 1;
  }
}

class PayableAmount extends StatefulWidget {
  final int noOfPages;
  final double cost;
  final Function(double) onCalculated;

  const PayableAmount({Key key, this.noOfPages, this.cost, this.onCalculated})
      : super(key: key);

  @override
  _PayableAmountState createState() => _PayableAmountState();
}

class _PayableAmountState extends State<PayableAmount> {
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    totalAmount = widget.noOfPages * widget.cost;
    widget.onCalculated(totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(totalAmount).toStringAsFixed(2)}',
      style: TextStyle(color: Colors.green),
    );
  }
}
