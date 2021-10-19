import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/repository/order_repo.dart';
import 'package:ourprint/screens/order_details_pages/order_confirmed.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class UploadPdf extends StatefulWidget {
  final OrderModel pdfModel;
  final Map body;

  const UploadPdf({Key key, this.pdfModel, this.body}) : super(key: key);

  @override
  _UploadPdfState createState() => _UploadPdfState();
}

class _UploadPdfState extends State<UploadPdf> {
  uploadFiles() async {
//    var result = await OrderRepo.createOrder(widget.body);
//    await OrderRepo.uploadPDF(
//        result['id'],
//        FormData.fromMap({
//          'pdf': widget.pdfModel.pdf,
//          'front_cover_pdf': widget.pdfModel.frontCoverPdf
//        }),
//        onProgress);
  }

  @override
  void initState() {
    super.initState();
    uploadFiles();
  }

  var percent = 0.0;

  onProgress(sent, total) {
    double dividend = sent / total;
    dividend = double.tryParse(dividend.toStringAsFixed(1));

    print('$dividend');
    if (percent != dividend)
      setState(() {
        print('setstata $dividend');
        percent = dividend;
      });
    if (percent >= 1.0) BookingConfirmed.open(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularPercentIndicator(
          radius: 60,
          percent: percent,
          animation: true,
          progressColor: Theme.of(context).accentColor,
          center: Text(
            '${(percent * 100).toInt()}%',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: Text(
            '\nLoading...',
            style:
                textTheme.caption.copyWith(fontSize: 16, color: Colors.white),
          ),
        )
      ],
    );
  }
}
