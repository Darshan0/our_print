import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/file_config_page/file_config.dart';
import 'package:provider/provider.dart';

class PrintingCharges extends StatefulWidget {
  final ConfigurationModel sideConfig;
  final double cost;
  final ConfigurationModel printingConfig;
  final double unColoredPrintCharge;
  final OrderModel model;
  final int pdfPageCount;
  final String multiColorNotes;
  final double printingCharges;
  final Function(double charges) onCalculated;
  final bool overExceed;

  PrintingCharges(
      {Key key,
      this.model,
      this.printingCharges,
      this.onCalculated,
      this.printingConfig,
      this.unColoredPrintCharge,
      this.cost,
      this.pdfPageCount,
      this.multiColorNotes,
      this.sideConfig,
      this.overExceed = false})
      : super(key: key);

  @override
  _PrintingChargesState createState() => _PrintingChargesState();
}

class _PrintingChargesState extends State<PrintingCharges> {
  int coloredPages = 0;
  int nonColoredPages = 0;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    switch (widget.printingConfig.title) {
      case 'Multicolor':
        var list = widget.multiColorNotes.split(',');

        try {
          list.forEach((value) {
            if (value.contains('-')) {
              var first = int.parse(value.substring(0, value.indexOf('-')));
              var second = int.parse(value.substring(value.indexOf('-') + 1));
              coloredPages += second - first;
              coloredPages++;
            } else {
              if (int.parse(value) != null) {
                if (int.parse(value) <= widget.pdfPageCount)
                  coloredPages++;
                else
                  throw '';
              }
            }
          });
          nonColoredPages = widget.pdfPageCount - coloredPages;
        } catch (e) {
          print(e);
        }
        totalPrice += (widget.cost * coloredPages);
        totalPrice += (widget.unColoredPrintCharge * nonColoredPages);
        break;

      case 'Color':
        totalPrice += (widget.pdfPageCount * widget.cost);
        break;
      case 'Black and White':
        totalPrice += (widget.pdfPageCount * widget.unColoredPrintCharge);
    }
    if (widget.onCalculated != null) widget.onCalculated(totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pdfBloc = Provider.of<PDFBloc>(context);
    List<Widget> column = [];
    switch (widget.printingConfig.title) {
      case 'Multicolor':
        column.add(Row(
          children: <Widget>[
            Text(
              '$coloredPages pgs x Rs ${widget.cost} /page ',
              style: textTheme.caption.copyWith(fontSize: 12),
            ),
            Image.asset(
              Images.coloredContainer,
              height: 20,
              width: 20,
            )
          ],
        ));
        column.add(Row(
          children: <Widget>[
            Text(
                '$nonColoredPages pgs x Rs ${widget.unColoredPrintCharge} /page ',
                style: textTheme.caption.copyWith(fontSize: 12)),
            Image.asset(
              Images.blackWhiteContainer,
              height: 20,
              width: 20,
            )
          ],
        ));
        break;
      case 'Color':
        column.add(Row(
          children: <Widget>[
            Text('${widget.pdfPageCount} pgs x Rs ${widget.cost} /page ',
                style: textTheme.caption.copyWith(fontSize: 12)),
            Image.asset(
              Images.coloredContainer,
              height: 20,
              width: 20,
            )
          ],
        ));
        break;
      case 'Black and White':
        column.add(Row(
          children: <Widget>[
            Text(
                '${widget.pdfPageCount} pgs x Rs ${widget.unColoredPrintCharge}'
                ' /page ',
                style: textTheme.caption.copyWith(fontSize: 12)),
            Image.asset(
              Images.blackWhiteContainer,
              height: 20,
              width: 20,
            )
          ],
        ));
        break;
    }
    // if(PageConfig.configs[model.pageConfig]!=null)
    //   column.add(Align(
    //     alignment: Alignment.topLeft,
    //     child: Text('${PageConfig.configs[model.pageConfig]}',
    //         style: textTheme.caption.copyWith(fontSize: 12))));
    print(widget.overExceed);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text('Print Charges',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            if (widget.overExceed == true ||
                pdfBloc.orderType != OrderType.SUBSCRIPTION)
              Text('₹ ${totalPrice?.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.green)),
          ],
        ),
        if (widget.sideConfig != null)
          Text(
            '${widget.sideConfig.title}',
            style: textTheme.caption,
          ),
        SizedBox(height: 4),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: column,
        ),
      ],
    );
  }
}
