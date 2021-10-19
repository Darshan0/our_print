import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/screens/file_config_page/file_config.dart';
import 'package:provider/provider.dart';

class FixedCharges extends StatefulWidget {
  final ConfigurationModel configDetails;
  final OrderModel model;
  final Function(double val) onCalculated;

  FixedCharges({Key key, this.configDetails, this.model, this.onCalculated})
      : super(key: key);

  @override
  _FixedChargesState createState() => _FixedChargesState();
}

class _FixedChargesState extends State<FixedCharges> {
  String price;

  @override
  void initState() {
    super.initState();

    if (widget.onCalculated != null)
      widget.onCalculated(widget.configDetails.price);
    price = widget.configDetails.price == 0
        ? 'Free'
        : '₹ ${widget.configDetails.price?.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final pdfBloc = Provider.of<PDFBloc>(context);
    return widget.configDetails.title == 'A4'
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(widget.configDetails.title,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                if (pdfBloc.orderType != OrderType.SUBSCRIPTION)
                  Text('$price', style: TextStyle(color: Colors.green)),
              ],
            ),
          );
  }
}
