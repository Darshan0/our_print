import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/repository/configuration_repo.dart';
import 'package:ourprint/screens/address_pages/address.dart';
import 'package:ourprint/widgets/pdf_box.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:pdf_render/pdf_render.dart';

class FreemiumPage extends StatefulWidget {
  static open(context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FreemiumPage()),
      );

  static openReplacement(context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FreemiumPage()),
      );

  @override
  _FreemiumPageState createState() => _FreemiumPageState();
}

class _FreemiumPageState extends State<FreemiumPage> {
  File pdfFile;
  Future<List<ConfigurationModel>> future;

  @override
  void initState() {
    super.initState();
    future = ConfigurationsRepo.getConfigs();
  }

  final titleCtrl = TextEditingController();
  final instructionsCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool fileUploaded = false;
  int orderId = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<List<ConfigurationModel>>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError)
            return Material(
              child: CustomErrorWidget(error: snap.error),
            );
          if (!snap.hasData) return Material(child: LoadingWidget());

          ConfigurationModel blackAWhite = snap.data.firstWhere(
            (data) => data.title == 'Black and White',
          );

          return Form(
            key: formKey,
            child: Scaffold(
              appBar: AppBar(),
              floatingActionButton: fileUploaded == false
                  ? Container()
                  : Builder(
                      builder: (context) => RaisedButton(
                        onPressed: () async {
                          if (!formKey.currentState.validate()) return;
                          int pdfCount =
                              (await PdfDocument.openFile(pdfFile.path))
                                  .pageCount;
//                          if (pdfCount < 40)
//                            return ErrorSnackBar.show(
//                                context, 'Minimum 40 pages are required');
//
//                          if (pdfCount > 150)
//                            return ErrorSnackBar.show(
//                                context, 'Maximum limit is 150 pages');

                          var price = 0.0;

                          if (pdfCount > 100) {
                            price = double.tryParse(
                                (blackAWhite.price * (pdfCount - 100))
                                    .toStringAsFixed(2));
                          }
                          //
                          // var model = OrderModel(
                          //     orderType: 'freemium',
                          //     id: orderId,
                          //     fileName: pdfFile.path
                          //         .substring(pdfFile.path.lastIndexOf('/') + 1),
                          //     pdfPageCount: pdfCount,
                          //     amount: price,
                          //     priceList: [blackAWhite.price].toString(),
                          //     configurations: [blackAWhite.id],
                          //     status: 'confirmed',
                          //     user: await Prefs.getUserId(),
                          //     title: titleCtrl.text,
                          //     notes: instructionsCtrl.text,
                          //     isFreemium: true);
                          Address.open(context);
                        },
                        child: Text('CONTINUE'),
                      ),
                    ),
              body: ListView(
                padding: EdgeInsets.all(20),
                children: <Widget>[
                  Text(
                    'Freemium Print',
                    style: textTheme.title.copyWith(color: Color(0xFF173A50)),
                  ),
                  SizedBox(height: 24),
                  PDFBox(
                    isFreemium: true,
                    index: 0,
                    pdfKey: 'pdf',
                    onUploaded:
                        (bool isUploaded, int orderId, String filePath) {
                      fileUploaded = isUploaded;
                      if (fileUploaded) this.orderId = orderId;

                      setState(() {});
                    },
                    onPicked: (File pdf) {
                      pdfFile = pdf;
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 28),
                  pdfFile == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'What is Freemium Print?',
                              style: textTheme.title
                                  .copyWith(color: Color(0xFF173A50)),
                            ),
                            SizedBox(height: 16),
                            Text('* One Free Print every month',
                                style: textTheme.caption),
                            SizedBox(height: 12),
                            Text('* Free upto 100 Pages',
                                style: textTheme.caption),
                            SizedBox(height: 12),
                            Text('* Maximum 150 pages',
                                style: textTheme.caption),
                            SizedBox(height: 12),
                            Text('* Delivery charge applicable',
                                style: textTheme.caption),
                            SizedBox(height: 12),
                            Text('* Contains Ads', style: textTheme.caption),
                            SizedBox(height: 12),
                          ],
                        )
                      : ListTile(
                          contentPadding: EdgeInsets.only(top: 20),
                          title: Text(
                            'Enter a Title for your document',
                            style: textTheme.caption,
                          ),
                          subtitle: TextFormField(
                            controller: titleCtrl,
                            validator: (value) => value.trim().isEmpty
                                ? 'Please enter a Title'
                                : null,
                            decoration:
                                InputDecoration(hintText: 'Tap to edit'),
                          ),
                        ),
                  pdfFile == null
                      ? Container()
                      : ListTile(
                          contentPadding: EdgeInsets.only(top: 20),
                          title: Text(
                            'Enter any instructions that should be '
                            'carried out while printing your file ',
                            style: textTheme.caption,
                          ),
                          subtitle: TextFormField(
                            controller: instructionsCtrl,
                            decoration:
                                InputDecoration(hintText: 'Tap to edit'),
                          ),
                        ),
                ],
              ),
            ),
          );
        });
  }
}
