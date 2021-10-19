import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/repository/order_repo.dart';
import 'package:ourprint/screens/file_config_page/file_config.dart';
import 'package:provider/provider.dart';

class DynamicCharges extends StatefulWidget {
  final ConfigurationModel configDetails;
  final int numOfCopies;
  final int pdfPageCount;
  final Function(double val) onCalculated;

  DynamicCharges(
      {Key key,
      this.configDetails,
      this.onCalculated,
      this.pdfPageCount,
      this.numOfCopies})
      : super(key: key);

  @override
  _DynamicChargesState createState() => _DynamicChargesState();
}

class _DynamicChargesState extends State<DynamicCharges> {
  final GlobalKey _toolTipKey = GlobalKey();
  var spiralBindingCharges;

  @override
  void initState() {
    super.initState();
    calculatePrice();
  }

  var finalCharge = 0.0;

  calculatePrice() {
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    print(
        '${widget.pdfPageCount}, ${widget.numOfCopies}, ${widget.configDetails}');
    finalCharge = pdfBloc.getSpiralBindingCharges(
        widget.pdfPageCount, widget.numOfCopies, widget.configDetails);
    if (widget.onCalculated != null) widget.onCalculated(finalCharge);
  }

  @override
  Widget build(BuildContext context) {
    final pdfBloc = Provider.of<PDFBloc>(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.configDetails.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              decoration: pdfBloc.orderType == OrderType.SUBSCRIPTION
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          widget.configDetails.title == 'Spiral Binding'
              ? Tooltip(
                  key: _toolTipKey,
                  message: 'Binding Charges will be multiplied\n'
                      ' for every ${widget.configDetails.perPageCount}th page',
                  padding: EdgeInsets.all(12),
                  child: IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.info_outline),
                    onPressed: () {
                      final dynamic tooltip = _toolTipKey.currentState;
                      tooltip.ensureTooltipVisible();
                    },
                  ),
                )
              : Container(
                  height: 1,
                  width: 1,
                ),
        ],
      ),
      trailing: Text(
        '₹ ${finalCharge?.toStringAsFixed(2)}',
        style: TextStyle(
            color: Colors.green,
            decoration: pdfBloc.orderType == OrderType.SUBSCRIPTION
                ? TextDecoration.lineThrough
                : null),
      ),
    );
  }
}
