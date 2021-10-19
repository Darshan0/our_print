import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/order_file_model.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/model/order_status_model.dart';
import 'package:ourprint/repository/configuration_repo.dart';
import 'package:ourprint/repository/order_repo.dart';
import 'package:ourprint/screens/file_config_page/file_config.dart';
import 'package:ourprint/screens/order_charges/dynamic_charges.dart';
import 'package:ourprint/screens/order_charges/fixed_charges.dart';
import 'package:ourprint/screens/order_charges/freemium_discount.dart';
import 'package:ourprint/screens/order_charges/per_page_charges.dart';
import 'package:ourprint/screens/order_charges/printing_charges.dart';
import 'package:ourprint/screens/order_details_pages/page_counter_card.dart';
import 'package:ourprint/screens/order_details_pages/widgets/num_of_copies.dart';
import 'package:ourprint/utils/strings.dart';
import 'package:ourprint/widgets/dialog_boxes.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel model;

  const OrderDetails({Key key, this.model}) : super(key: key);

  static open(context, OrderModel model) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderDetails(model: model)),
      );

  @override
  _OrderDetailsState createState() => _OrderDetailsState(model);
}

class _OrderDetailsState extends State<OrderDetails> {
  Future<List<ConfigurationModel>> future;
  List<OrderStatusModel> orderStatusModel;
  final OrderModel model;

  // List<ConfigurationModel> configDetails = [];

  _OrderDetailsState(this.model);

  Future<List<ConfigurationModel>> getDetails() async {
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    orderStatusModel = await OrderRepo.getOrdersStatus(widget.model.id);
    pdfBloc.dependentConfigPrice = widget.model.dependentConfigPrice;
    // configDetails = (jsonDecode(model.configList) as List)
    //     .map((e) => ConfigurationModel.fromMap(e))
    //     .toList();
    return ConfigurationsRepo.getConfigs();
  }

  @override
  void initState() {
    super.initState();
    future = getDetails();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);

    return FutureBuilder<List<ConfigurationModel>>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError)
            return Material(
              child: CustomErrorWidget(error: snap.error),
            );
          if (!snap.hasData) return Material(child: LoadingWidget());
          if (snap.hasError) return CustomErrorWidget(error: snap.error);
          if (!snap.hasData) return LoadingWidget();

          // var myConfigsList = widget.model.configurations
          //     .map((value) {
          //       return snap.data.firstWhere((data) {
          //         return (data.id == value);
          //       }, orElse: () {});
          //     })
          //     .where((value) => value != null)
          //     .toList();

          var deliveredAt = orderStatusModel
              .firstWhere((data) => data.status == 'delivered',
                  orElse: () => null)
              ?.createdAt;

          final deliveryDate = deliveredAt == null
              ? 'NA'
              : DateFormat('dd MMM, yyyy').format(deliveredAt.toLocal());
          return Scaffold(
            appBar: AppBar(),
            body: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Order Details',
                        style:
                            textTheme.title.copyWith(color: Color(0xFF173A50)),
                      ),
                    ),
                    Text(
                      'Delivered',
                      style: TextStyle(color: Colors.green),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Order No. ${widget.model.orderId ?? ''}',
                          style: textTheme.subhead
                              .copyWith(fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Date Ordered : ${DateFormat('dd MMM, yyyy hh:mm').format(
                            widget.model.createdAt.toLocal(),
                          )}',
                          style: textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // ListTile(
                //   contentPadding: EdgeInsets.zero,
                //   title: Text('File Name'),
                //   subtitle: Padding(
                //     padding: const EdgeInsets.only(top: 8.0),
                //     child: Text('${model.orderFiles.length} documents'),
                //   ),
                // ),
                // SizedBox(height: 20),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Text('Order details', style: textTheme.caption),
                // ),
                if (widget.model.trackUrl != null &&
                    widget.model.trackUrl.trim().isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TRACK:  '),
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            canLaunch(widget.model.trackUrl).then((value) {
                              if (value == false)
                                return DialogBox.showErrorDialog(
                                  context,
                                  'Invalid URL',
                                );
                              launch(widget.model.trackUrl);
                            });
                          },
                          child: Text(
                            '${widget.model.trackUrl}',
                            style:
                                textTheme.caption.copyWith(color: Colors.blue),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                ],
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, i) => Divider(color: Colors.black45),
                  itemCount: model.orderFiles.length,
                  itemBuilder: (context, i) {
                    int id = model.orderFiles[i];
                    return FutureBuilder<OrderFileModel>(
                        future: OrderRepo.getOrderFile(id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            return CustomErrorWidget(
                                error: snapshot.error.toString());
                          if (!snapshot.hasData) return LoadingWidget();
                          print('------------');
                          print(snapshot.data.configList);
                          var res =
                              jsonDecode(snapshot.data.configList) as List;
                          print('nsdnjjdsjahdkjashjdhjsad');
                          var configDetails = res
                              .map((e) => ConfigurationModel.fromMap(e))
                              .toList();
                          final file = snapshot.data;
                          double fileTotal = 0;

                          final sideConfig = configDetails.firstWhere(
                              (e) =>
                                  e.type == 'page' &&
                                  snapshot.data.configurations.contains(e.id),
                              orElse: () => null);
                          final printConfig = configDetails.firstWhere(
                              (e) =>
                                  e.type == 'print' &&
                                  snapshot.data.configurations.contains(e.id),
                              orElse: () => null);
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                        '${file.pageCounterUsed}',
                                        style: textTheme.caption
                                            .copyWith(color: Colors.green),
                                      )
                                    ]
                                  ],
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.only(top: 0),
                                  title: Text(
                                    'File name',
                                    style: textTheme.caption,
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      '${file.fileName} '
                                      '(${file.pdfPageCount} Pages)',
                                      style: textTheme.body2,
                                    ),
                                  ),
                                ),
                                ...configDetails.map(
                                  (e) {
                                    final i = configDetails.indexOf(e);
                                    switch (configDetails[i].priceType) {
                                      case 'per_page':
                                        switch (configDetails[i].type) {
                                          case 'print':
                                            return PrintingCharges(
                                              cost: sideConfig == null
                                                  ? configDetails[i].price
                                                  : sideConfig.title ==
                                                          'One-Sided'
                                                      ? printConfig.title ==
                                                              'Black and White'
                                                          ? pdfBloc
                                                              .dependentConfigPrice
                                                              .blackWhiteSingleSide
                                                          : pdfBloc
                                                              .dependentConfigPrice
                                                              .colorSingleSide
                                                      : printConfig.title ==
                                                              'Black and White'
                                                          ? pdfBloc
                                                              .dependentConfigPrice
                                                              .blackWhiteDoubleSide
                                                          : pdfBloc
                                                              .dependentConfigPrice
                                                              .colorDoubleSide,
                                              sideConfig:
                                                  configDetails.firstWhere(
                                                      (e) => e.title
                                                          .endsWith('Sided'),
                                                      orElse: () => null),
                                              printingCharges: printingCharges,
                                              model: model,
                                              pdfPageCount: file.pdfPageCount,
                                              multiColorNotes:
                                                  file.multiColorNotes,
                                              printingConfig: configDetails[i],
                                              onCalculated: (charges) {
                                                fileTotal += charges;
                                                return printingCharges =
                                                    charges;
                                              },
                                              unColoredPrintCharge: sideConfig ==
                                                      null
                                                  ? configDetails
                                                      .firstWhere(
                                                        (data) =>
                                                            data.title ==
                                                            'Black and White',
                                                        orElse: () => snap.data
                                                            .firstWhere((data) =>
                                                                data.title ==
                                                                'Black and White'),
                                                      )
                                                      .price
                                                  : sideConfig.title ==
                                                          'One-Sided'
                                                      ? pdfBloc
                                                          .dependentConfigPrice
                                                          .blackWhiteSingleSide
                                                      : pdfBloc
                                                          .dependentConfigPrice
                                                          .blackWhiteDoubleSide,
                                            );
                                            break;
                                          default:
                                            if (configDetails[i].type == 'page')
                                              return Container();
                                            return PerPageCharges(
                                              model: model,
                                              pdfPageCount: file.pdfPageCount,
                                              configDetails: configDetails[i],
                                              onCalculated: (val) {
                                                fileTotal += val;
                                              },
                                            );
                                        }
                                        break;
                                      case 'fixed':
                                        return FixedCharges(
                                          configDetails: configDetails[i],
                                          onCalculated: (val) {
                                            fileTotal += val;
                                          },
                                        );
                                        break;
                                      case 'dynamic':
                                        return DynamicCharges(
                                          pdfPageCount: file.pdfPageCount,
                                          numOfCopies: file.numOfCopies,
                                          configDetails: configDetails[i],
                                          onCalculated: (val) {
                                            fileTotal += val;
                                          },
                                        );
                                      default:
                                        return Container();
                                    }
                                  },
                                ),
                                Builder(
                                  builder: (_) => NumOfCopies(
                                    file: {
                                      'num_of_copies': file.numOfCopies,
                                      'page_count': file.pdfPageCount
                                    },
                                    onCalculated: (count) {
                                      //   print('count is $count');
                                      //   if (count == 0) return;
                                      //   print('prevous total $total');
                                      //   total += total * (count - 1);
                                      //   print('next total $total');
                                    },
                                    spiralConfig: configDetails.firstWhere(
                                      (e) => e.title == Strings.spiralBinding,
                                      orElse: () => null,
                                    ),
                                    total: fileTotal,
                                  ),
                                )
                              ]);
                        });
                  },
                ),
                Divider(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Delivery Charge',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration:
                                  pdfBloc.orderType == OrderType.SUBSCRIPTION
                                      ? TextDecoration.lineThrough
                                      : null),
                        ),
                      ),
                      Text('₹ ${model.deliveryCharge}',
                          style: TextStyle(
                              color: Colors.green,
                              decoration:
                                  pdfBloc.orderType == OrderType.SUBSCRIPTION
                                      ? TextDecoration.lineThrough
                                      : null)),
                    ],
                  ),
                ),
                // model.isFreemium == true
                //     ? Builder(
                //         builder: (context) => FreemiumDiscount(
                //           model: model,
                //           printingCharges: printingCharges,
                //           myConfigsList: myConfigsList,
                //         ),
                //       )
                //     : Container(),
                Divider(height: 32),
                if (pdfBloc.orderType != OrderType.SUBSCRIPTION)
                  Builder(
                    builder: (context) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text('Amount Paid',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text(
                          '₹ ${(model.amount + model.deliveryCharge)?.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.green)),
                    ),
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Date Delivered'),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(deliveryDate),
                  ),
                ),
//                  ListTile(
//                    contentPadding: EdgeInsets.zero,
//                    title: Text('Payment Mode'),
//                    subtitle: Padding(
//                      padding: const EdgeInsets.only(top: 8.0),
//                      child: Text('Net Banking'),
//                    ),
//                  ),
              ],
            ),
          );
        });
  }

  _showInfo() {
    showDialog(
        context: context,
        builder: (_) {
          return PageCounterCard();
        });
  }

  var printingCharges = 0.0;
}
