import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/repository/configuration_repo.dart';
import 'package:ourprint/screens/address_pages/address.dart';
import 'package:ourprint/widgets/pdf_box.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:toast/toast.dart';

class FrontCover extends StatefulWidget {
  final OrderModel model;

  const FrontCover({Key key, this.model}) : super(key: key);

  static open(context, OrderModel model) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FrontCover(
                  model: model,
                )),
      );

  @override
  _FrontCoverState createState() => _FrontCoverState(model);
}

class _FrontCoverState extends State<FrontCover> {
  File pdfFile;
  Future<List<ConfigurationModel>> future;
  int bindingConfig;
  final OrderModel model;

  _FrontCoverState(this.model);

  List<ConfigurationModel> configList;

  Future<List<ConfigurationModel>> getDetails() async {
    final response = await ConfigurationsRepo.getConfigs();
    configList = response
        .where((data) =>
            data.type == 'binding' &&
            (data.title == 'Loose Paper' || data.title == 'Hard Binding'))
        .toList();
    bindingConfig = configList[0].id;
    return response;
  }

  @override
  void initState() {
    super.initState();
    future = getDetails();
  }

  final instructionsCtrl = TextEditingController();
  int printConfig;
  bool fileUploaded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<List<ConfigurationModel>>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError)
            return Material(
              child: Material(child: CustomErrorWidget(error: snap.error)),
            );
          if (!snap.hasData) return Material(child: LoadingWidget());
          return Scaffold(
            appBar: AppBar(),
            floatingActionButton: RaisedButton(
              onPressed: () async {
                final hardBindingConfig = configList.firstWhere(
                  (data) {
                    return data.title == 'Hard Binding';
                  },
                ).id;

                if (bindingConfig == hardBindingConfig) {
                  if (fileUploaded == false)
                    return Toast.show('Please upload a PDF', context);
                }
                var list = model.configurations;
                var newConfigList = [bindingConfig] + list;

                final result = OrderModel().add(
                  model: widget.model,
                  frontCoverPdfInfo: instructionsCtrl.text,
                  configurations: newConfigList,
                );
                print(result.toMap());
                Address.open(context);
              },
              child: Text('NEXT'),
            ),
            body: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Binding Configuration',
                        style: textTheme.title.copyWith(
                            color: Color(0xFF173A50),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: configList.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Radio(
                              value: configList[i].id,
                              groupValue: bindingConfig,
                              onChanged: (value) {
                                bindingConfig = value;
                                setState(() {});
                              },
                            ),
                            title: Text(configList[i].title),
                            subtitle: Row(
                              children: <Widget>[
                                Text(
                                  "${configList[i].price > 0 ? "₹ "
                                      "${configList[i].price}"
                                      "${this ^ configList[i].perPageCount}"
                                      "" : 'Free'} ",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green),
                                ),
                                configList[i].strikePrice == 0
                                    ? Container()
                                    : Text(
                                        '₹ ${configList[i].strikePrice}'
                                        '${this ^ configList[i].perPageCount}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
                SizedBox(height: 20),
                bindingConfig ==
                        configList
                            .firstWhere((data) => data.title == 'Hard Binding')
                            .id
                    ? Column(
                        children: <Widget>[
                          Text(
                            'Front Cover',
                            style: textTheme.title
                                .copyWith(color: Color(0xFF173A50)),
                          ),
                          SizedBox(height: 20),
                          PDFBox(
                            orderId: model.id,
                            pdfKey: 'front_cover_pdf',
                            // onUploaded: (bool isUploaded, int orderId) {
                            //   fileUploaded = isUploaded;
                            //   setState(() {});
                            // },
                            onPicked: (value) {
                              pdfFile = value;
                              setState(() {});
                            },
                            title: 'Upload a PDF file of\n the front cover',
                          ),
                        ],
                      )
                    : Container(),
                pdfFile == null
                    ? Container()
                    : ListTile(
                        contentPadding: EdgeInsets.only(top: 20),
                        title: Text(
                          'Any information about the document',
                          style: textTheme.caption,
                        ),
                        subtitle: TextFormField(
                          controller: instructionsCtrl,
                          decoration: InputDecoration(hintText: 'Tap to edit'),
                        ),
                      )
              ],
            ),
          );
        });
  }

  operator ^(int pageCount) {
    if (pageCount == 1) return ' ';
    return '/ $pageCount\page';
  }
}
