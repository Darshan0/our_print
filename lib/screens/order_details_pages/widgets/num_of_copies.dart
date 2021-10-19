import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/screens/file_config_page/file_config.dart';
import 'package:provider/provider.dart';

class NumOfCopies extends StatefulWidget {
  final Map<String, dynamic> file;
  final double total;
  final Function onCalculated;
  final ConfigurationModel spiralConfig;

  const NumOfCopies(
      {Key key, this.file, this.onCalculated, this.total, this.spiralConfig})
      : super(key: key);

  @override
  _NumOfCopiesState createState() => _NumOfCopiesState(file, total);
}

class _NumOfCopiesState extends State<NumOfCopies> {
  final Map<String, dynamic> file;
  double total;
  double showTotal;

  _NumOfCopiesState(this.file, this.total);

  @override
  void initState() {
    super.initState();
    int nOfCopies = file['num_of_copies'];
    print('total is $total');
    // if (nOfCopies == 0) return;

    // total += total * (nOfCopies - 1);
    var spiralBindingCharge = 0.0;
    if (widget.spiralConfig != null) {
      final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
      spiralBindingCharge = pdfBloc.getSpiralBindingCharges(
        file['page_count'],
        nOfCopies,
        widget.spiralConfig,
      );
      print('spiral bindging charge $spiralBindingCharge');
      total -= spiralBindingCharge;
    }
    print('total-spiral charges is $total');
    total = total * nOfCopies;
    print('new total is $total');
    showTotal = total;
    total += spiralBindingCharge;
    print('total+spiral charges $total');
    widget.onCalculated(total);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pdfBloc = Provider.of<PDFBloc>(context);
    return Row(
      children: <Widget>[
        Text('Number of Copies', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'x ${file['num_of_copies']}',
            style: textTheme.caption.copyWith(fontSize: 14),
          ),
        ),
        if (pdfBloc.orderType != OrderType.SUBSCRIPTION)
          Text('₹ ${showTotal.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.green))
      ],
    );
  }
}
