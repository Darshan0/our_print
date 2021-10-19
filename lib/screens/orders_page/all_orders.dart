import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/model/order_status_model.dart';
import 'package:ourprint/repository/order_repo.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/orders_page/order_details.dart';
import 'package:ourprint/screens/orders_page/order_tracking.dart';
import 'package:ourprint/widgets/empty_widget.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class AllOrders extends StatefulWidget {
  static open(context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => AllOrders()));

  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  Future<List<OrderModel>> future;

  Future<List<OrderModel>> getDetails() async {
    return OrderRepo.getOrders();
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
    return FutureBuilder<List<OrderModel>>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError)
            return Material(child: CustomErrorWidget(error: snap.error));
          if (!snap.hasData) return Material(child: LoadingWidget());

          var progressOrders =
              snap.data.where((data) => data.status != 'delivered').toList();
          var allOrders =
              snap.data.where((data) => data.status == 'delivered').toList();

          if (progressOrders.isEmpty && allOrders.isEmpty)
            return EmptyWidget(
                title: 'No Orders yet',
                subtitle: 'There are no orders'
                    ' to display. '
                    'Get one print \nfor a month absolutely free.');
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: <Widget>[
                  Text(
                    'Orders',
                    style: textTheme.title.copyWith(color: Color(0xFF173A50)),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: List.generate(progressOrders.length, (int index) {
                      final order = progressOrders[index];
                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Order No. ${progressOrders[index].orderId ?? ''}',
                                    style: textTheme.subhead
                                        .copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    'In Progress',
                                    style: TextStyle(color: Colors.orange),
                                  )
                                ],
                              ),
                              SizedBox(height: 12),
                              order.orderType == 'subscription'
                                  ? Text(
                                      '${order.orderFiles.length} files'
                                      ' ${order.pageCounterUsed}'
                                      ' PC',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Text(
                                      '${order.orderFiles.length} files'
                                      ' ${order.totalPages}'
                                      ' Pages',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              SizedBox(height: 4),
                              // Text(
                              //   '${}'
                              //   ' Document(s)',
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              if (progressOrders[index].orderType ==
                                  'subscription')
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    'Subscription',
                                    style: textTheme.bodyText1
                                        .copyWith(color: Colors.green),
                                  ),
                                ),
                              SizedBox(height: 4),
                              Text(
                                'Date Ordered : ${DateFormat('dd MMM, yyyy').format(
                                  progressOrders[index].createdAt.toLocal(),
                                )}',
                                style: textTheme.caption,
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: RaisedButton(
                                        onPressed: () {
                                          pdfBloc.setOrderTypeField =
                                              progressOrders[index].orderType;
                                          return OrderTracking.open(
                                              context, progressOrders[index]);
                                        },
                                        child: Text('TRACK'),
                                      ),
                                    ),
                                  ),
                                  progressOrders[index].isFreemium == true
                                      ? Image.asset(
                                          Images.freemiumIcon,
                                          height: 18,
                                        )
                                      : Container()
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 24),
                  Text('Past Orders', style: textTheme.caption),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                        children: List.generate(
                      allOrders.length,
                      (int index) {
                        return ListTile(
                          onTap: () {
                            pdfBloc.setOrderTypeField =
                                allOrders[index].orderType;
                            return OrderDetails.open(context, allOrders[index]);
                          },
                          contentPadding: EdgeInsets.all(0),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Delivered',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                              allOrders[index].isFreemium == true
                                  ? Image.asset(
                                      Images.freemiumIcon,
                                      height: 15,
                                    )
                                  : Container(height: 1, width: 1)
                            ],
                          ),
                          title: Text(
                            'Order No. ${allOrders[index].orderId ?? ''}',
                            style: textTheme.subhead.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: allOrders[index].orderType == 'subscription'
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Subscription',
                                    style: textTheme.body2.copyWith(
                                      color: Colors.green,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '₹ ${allOrders[index].amount}',
                                    style: textTheme.body2.copyWith(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                        );
                      },
                    )),
                  )
                ],
              ),
            ),
          );
        });
  }
}
