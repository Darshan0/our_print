import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/screens/file_config_page/file_config.dart';
import 'package:provider/provider.dart';

class PerPageCharges extends StatefulWidget {
//  final  perPageConfigs;
  final ConfigurationModel configDetails;

  final OrderModel model;
  final int pdfPageCount;

  final Function onCalculated;

  const PerPageCharges(
      {Key key,
      this.configDetails,
      this.model,
      this.onCalculated,
      this.pdfPageCount})
      : super(key: key);

  @override
  _PerPageChargesState createState() => _PerPageChargesState();
}

class _PerPageChargesState extends State<PerPageCharges> {
  double price;

  @override
  void initState() {
    super.initState();
    price = widget.configDetails.price * widget.pdfPageCount;
    if (widget.onCalculated != null) widget.onCalculated(price);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pdfBloc = Provider.of<PDFBloc>(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.configDetails.title,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
              '${widget.pdfPageCount} pgs x Rs ${widget.configDetails.price} /page ',
              style: textTheme.caption),
        ],
      ),
      trailing: pdfBloc.orderType != OrderType.SUBSCRIPTION
          ? Text('₹ ${price?.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.green))
          : Container(height: 1, width: 1),
    );
  }
}
