import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/model/order_status_model.dart';
import 'package:ourprint/repository/order_repo.dart';
import 'package:ourprint/screens/orders_page/tracking_card.dart';
import 'package:ourprint/widgets/dialog_boxes.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:ourprint/widgets/progress_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderTracking extends StatefulWidget {
  final OrderModel model;

  OrderTracking({Key key, this.model}) : super(key: key);

  static open(context, OrderModel model) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderTracking(model: model)),
      );

  @override
  _OrderTrackingState createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  Future<List<OrderStatusModel>> future;
  final Map<String, String> orderStatus = {
    'confirmed': 'Order Confirmed',
    'assigned': 'Order Assigned',
    'processing': 'Order Processing',
    'out-for-delivery': 'Out for Delivery',
    'delivered': 'Package Delivered'
  };

  @override
  void initState() {
    super.initState();
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    future = OrderRepo.getOrdersStatus(widget.model.id);
    future.then((value) {
      pdfBloc.dependentConfigPrice = widget.model.dependentConfigPrice;
      // pdfBloc.configurationList =
      //     List<ConfigurationModel>.from(jsonDecode(widget.model.pageConfig));
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<List<OrderStatusModel>>(
        future: future,
        builder: (context, snap) {
          if (!snap.hasData) return Material(child: LoadingWidget());
          if (snap.hasError)
            return Material(child: CustomErrorWidget(error: snap.error));
          return Scaffold(
            appBar: AppBar(),
            body: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Order Tracking',
                        style:
                            textTheme.title.copyWith(color: Color(0xFF173A50)),
                      ),
                    ),
                    Text(
                      'In Progress',
                      style: TextStyle(color: Colors.orange),
                    )
                  ],
                ),
                SizedBox(height: 20),
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
                TrackingCard(
                  model: widget.model,
                ),
                SizedBox(height: 20),
                Column(
                  children: List.generate(
                    orderStatus.length,
                    (int index) {
                      final key = orderStatus.keys.toList()[index];
                      final status = snap.data.isEmpty
                          ? widget.model.status
                          : snap.data.last.status;

                      final createdAt = key == 'confirmed'
                          ? widget.model.createdAt
                          : snap.data
                              .firstWhere((data) => data.status == key,
                                  orElse: () => null)
                              ?.createdAt;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ProgressView(
                            index: index,
                            position: orderStatus.keys.toList().indexOf(status),
                            length: orderStatus.length,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(orderStatus[key]),
                                  Text(
                                    createdAt == null
                                        ? ''
                                        : '${DateFormat('hh:mm a, dd MMM, yyyy').format(createdAt.toLocal())}',
                                    style: textTheme.caption.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w100),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                widget.model.status == 'out-for-delivery' ||
                        widget.model.status == 'delivered'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Text(
                            'Delivery Date : ${DateFormat('dd MMM, yyyy').format(widget.model.deliveryDate.toLocal())}',
                            style: textTheme.caption,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Delivery ID : ${widget.model.deliveryId}',
                            style: textTheme.caption,
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          );
        });
  }
}
