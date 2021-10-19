import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:dashed_container/dashed_container.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/repository/order_repo.dart';
import 'package:ourprint/widgets/error_snackbar.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'dialog_boxes.dart';

class PDFBox extends StatefulWidget {
  final Function(File) onPicked;
  final String title;
  final Function(bool, int, String filePath) onUploaded;
  final String pdfKey;
  final int orderId;
  final bool isFreemium;
  final int index;

  PDFBox(
      {Key key,
      @required this.onPicked,
      this.title,
      @required this.onUploaded,
      @required this.pdfKey,
      this.orderId,
      this.isFreemium,
      this.index})
      : super(key: key);

  @override
  _PDFBoxState createState() => _PDFBoxState();
}

class _PDFBoxState extends State<PDFBox> {
  // File pdfFile;
  bool fileUploaded = false;

  onProgress(sent, total) {
    double dividend = sent / total;
    dividend = double.tryParse(dividend.toStringAsFixed(1));

    print('$dividend');
    if (percent != dividend)
      setState(() {
        print('setstata $dividend');
        percent = dividend;
      });
  }

  var percent = 0.0;

  Future checkConstraints() async {
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    int pdfCount =
        (await PdfDocument.openFile(pdfBloc.currentFile['file_path']))
            .pageCount;
    print(pdfCount);
    if (widget.isFreemium == true) {
      if (pdfCount < 40)
        return ErrorSnackBar.show(context, 'Minimum 40 pages are required');

      if (pdfCount > 150)
        return ErrorSnackBar.show(context, 'Maximum limit is 150 pages');
      return true;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final pdfBloc = Provider.of<PDFBloc>(context);
    // print('11111 ${pdfBloc.selectedFileIndex}');
    // print('22222 ${widget.index}');
    final filePath = widget.pdfKey == 'pdf'
        ? pdfBloc.files[widget.index]['file_path']
        : pdfBloc.files[widget.index]['front_cover_file_path'];
    if (widget.pdfKey == 'pdf' && pdfBloc.selectedFileIndex != widget.index) {
      print('index is ${widget.index}');
      return Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: theme.accentColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${filePath.substring(filePath.lastIndexOf('/') + 1)},',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyText1.copyWith(color: Colors.white),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {
                pdfBloc..changeSelectedIndex(widget.index);
                if (pdfBloc.files.last['file_id'] == null) {
                  pdfBloc.removeLastFile();
                }
                setState(() {});
              },
            ),
            InkWell(
              child: Icon(Icons.delete, color: Colors.white),
              onTap: () {
                // pdfBloc..changeSelectedIndex(widget.index);
                // if (pdfBloc.files.last['file_id'] == null) {
                //   pdfBloc.removeLastFile();
                // }
                // pdfFile = null;
                pdfBloc.removeAt(widget.index);
                setState(() {});
              },
            ),
          ],
        ),
      );
    }
    return InkWell(
      onTap: () async {
        _uploadFile();
      },
      child: DashedContainer(
        dashColor: Colors.grey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              children: filePath == null
                  ? <Widget>[
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: FloatingActionButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onPressed: null,
                          child: Icon(Icons.add, size: 20, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.title ?? 'Add a PDF file',
                        style: textTheme.caption,
                        textAlign: TextAlign.center,
                      )
                    ]
                  : [
                      // Text(
                      //   fileUploaded == true
                      //       ? 'File Uploaded'
                      //       : 'File Uploading',
                      //   style: TextStyle(
                      //       color: Color(0xFF173A50),
                      //       fontWeight: FontWeight.bold),
                      // ),
                      // SizedBox(height: 12),
                      Flexible(
                        child: Row(
                          children: [
                            CircularPercentIndicator(
                              radius: 24,
                              lineWidth: 3,
                              percent: percent == 1 && fileUploaded == false
                                  ? percent - 0.1
                                  : percent,
                              backgroundColor: Colors.black12,
                              animation: true,
                              progressColor: Theme.of(context).accentColor,
                              center: Icon(
                                fileUploaded == true ? Icons.check : Icons.stop,
                                color: Colors.green,
                                size: 16,
                              ),
                            ),
                            SizedBox(width: 16),
                            Flexible(
                              child: Text(
                                '${filePath.substring(filePath.lastIndexOf('/') + 1)},',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
        ),
      ),
    );
  }

  _uploadFile() async {
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    LoadingWidget.showLoadingDialog(context, message: 'Reading PDF');
    var pdf =
        await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: 'pdf');
    Navigator.pop(context);
    if (pdf == null) return;
    final fileKey =
        widget.pdfKey == 'pdf' ? 'file_path' : 'front_cover_file_path';
    pdfBloc.files[pdfBloc.selectedFileIndex][fileKey] = pdf.path;
    if (await checkConstraints() != true) {
      return pdfBloc.files[pdfBloc.selectedFileIndex][fileKey] = null;
    }
    fileUploaded = false;
    widget.onUploaded(fileUploaded, 0, '');
    widget.onPicked(pdf);
    setState(() {});
    try {
      OrderModel response;
      if (widget.pdfKey == 'pdf') {
        response = await OrderRepo.uploadPDF(
            FormData.fromMap({
              widget.pdfKey: await MultipartFile.fromFile(
                pdf.path,
                contentType: MediaType('image', 'pdf'),
              ),
              'user': await Prefs.getUserId(),
              'status': 'incomplete'
            }),
            onProgress);
      } else {
        response = await OrderRepo.addPDF(
            widget.orderId,
            FormData.fromMap(
              {
                widget.pdfKey: await MultipartFile.fromFile(
                  pdf.path,
                  contentType: MediaType('image', 'pdf'),
                ),
                'user': await Prefs.getUserId(),
                'status': 'incomplete'
              },
            ),
            onProgress);
      }
      print('file jas been uploaded');
      fileUploaded = true;
      widget.onUploaded(fileUploaded, response.id, pdf.path);

      setState(() {});
    } catch (e) {
      pdfBloc.files[pdfBloc.selectedFileIndex][fileKey] = null;
      setState(() {});
      DialogBox.parseAndShowErrorDialog(context, e);
    }
  }
}
