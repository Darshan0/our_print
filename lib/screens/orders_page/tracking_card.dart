import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/bloc/subscription_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/order_file_model.dart';
import 'package:ourprint/model/order_model.dart';
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
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class TrackingCard extends StatefulWidget {
  final OrderModel model;

  const TrackingCard({Key key, this.model}) : super(key: key);

  @override
  _TrackingCardState createState() => _TrackingCardState(model);
}

class _TrackingCardState extends State<TrackingCard> {
  Future<List<ConfigurationModel>> future;
  final OrderModel model;

  // List<ConfigurationModel> configDetails = [];

  _TrackingCardState(this.model);

  Future<List<ConfigurationModel>> getDetails() async {
    var response = await ConfigurationsRepo.getConfigs();
    // configDetails = (jsonDecode(model.configList) as List)
    //     .map((e) => ConfigurationModel.fromMap(e))
    //     .toList();
    return response;
  }

  @override
  void initState() {
    super.initState();
    future = getDetails();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pdfBloc = Provider.of<PDFBloc>(context);
    final subsBloc = Provider.of<SubscriptionBloc>(context);
    return FutureBuilder<List<ConfigurationModel>>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError) return CustomErrorWidget(error: snap.error);
          if (!snap.hasData) return LoadingWidget();
          // var myConfigsList = model.configurations
          //     .map((value) {
          //       return snap.data.firstWhere((data) {
          //         return (data.id == value);
          //       }, orElse: () {});
          //     })
          //     .where((value) => value != null)
          //     .toList();

          return Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ExpansionTile(
                title: Text(
                  'Order No. ${widget.model.orderId ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  'Date Ordered : ${DateFormat('dd MMM, yyyy').format(model.createdAt.toLocal())}',
                  style: textTheme.caption,
                ),
                children: <Widget>[
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: Text('Order details', style: textTheme.caption),
                  // ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, i) =>
                          Divider(color: Colors.black45),
                      itemCount: model.orderFiles.length,
                      itemBuilder: (context, i) {
                        int id = model.orderFiles[i];
                        double fileTotal = 0;
                        return FutureBuilder<OrderFileModel>(
                          future: OrderRepo.getOrderFile(id),
                          builder: (context, snapshot) {
                            if (snapshot.hasError)
                              return CustomErrorWidget(error: snapshot.error);
                            if (!snapshot.hasData) return LoadingWidget();
                            var res =
                                jsonDecode(snapshot.data.configList) as List;
                            var configDetails = res
                                .map((e) => ConfigurationModel.fromMap(e))
                                .toList();
                            final file = snapshot.data;

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
                                  (config) {
                                    final i = configDetails.indexOf(config);
//                      snap.data.firstWhere(
//                          (data) => data.id == model.configurations[i]);
//                      print(model.configurations);
//                      print(model.priceList);
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

                                              // configDetails
                                              //     .firstWhere((e) =>
                                              //         e.title.endsWith('Sided'))
                                              //     .price,
                                              sideConfig:
                                                  configDetails.firstWhere(
                                                      (e) => e.title
                                                          .endsWith('Sided'),
                                                      orElse: () => null),
                                              printingCharges: printingCharges,
                                              model: model,
                                              pdfPageCount:
                                                  snapshot.data.pdfPageCount,
                                              multiColorNotes:
                                                  snapshot.data.multiColorNotes,
                                              printingConfig: configDetails[i],
                                              onCalculated: (charges) {
                                                print('print charges $charges');
                                                fileTotal += charges;
                                                return printingCharges =
                                                    charges;
                                              },
                                              unColoredPrintCharge: sideConfig ==
                                                      null
                                                  ? snap.data
                                                      .firstWhere(
                                                        (data) =>
                                                            data.title ==
                                                            'Black and White',
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
                                              pdfPageCount:
                                                  snapshot.data.pdfPageCount,
                                              configDetails: configDetails[i],
                                              onCalculated: (val) {
                                                print('per charges $val');
                                                fileTotal += val;
                                              },
                                            );
                                        }
                                        break;
                                      case 'fixed':
                                        return FixedCharges(
                                          configDetails: configDetails[i],
                                          onCalculated: (val) {
                                            print('fixed charges $val');
                                            fileTotal += val;
                                          },
                                        );
                                        break;
                                      case 'dynamic':
                                        return DynamicCharges(
                                          pdfPageCount:
                                              snapshot.data.pdfPageCount,
                                          numOfCopies: file.numOfCopies,
                                          configDetails: configDetails[i],
                                          onCalculated: (val) {
                                            print('dynamic charges $val');
                                            fileTotal += val;
                                          },
                                        );
                                      default:
                                        return Container();
                                    }
                                  },
                                ),
                                Builder(
                                  builder: (_) {
                                    configDetails.forEach((element) {
                                      print(element.toMap());
                                    });
                                    return NumOfCopies(
                                      file: {
                                        'num_of_copies': file.numOfCopies,
                                        'page_count': file.pdfPageCount
                                      },
                                      total: fileTotal,
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
                                    );
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }),
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
                                      : null,
                            ),
                          ),
                        ),
                        Text(
                          '₹ ${model.deliveryCharge}',
                          style: TextStyle(
                              color: Colors.green,
                              decoration:
                                  pdfBloc.orderType == OrderType.SUBSCRIPTION
                                      ? TextDecoration.lineThrough
                                      : null),
                        ),
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
                ],
              ),
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
