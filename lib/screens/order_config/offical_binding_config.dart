import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/widgets/pdf_box.dart';
import 'package:provider/provider.dart';

class OfficialBindingConfig extends StatefulWidget {
  final Function(int value) onChanged;
  final List<ConfigurationModel> configs;
  final int orderFileId;

  const OfficialBindingConfig(
      {Key key, this.configs, this.orderFileId, this.onChanged})
      : super(key: key);

  @override
  _OfficialBindingConfigState createState() =>
      _OfficialBindingConfigState(configs);
}

class _OfficialBindingConfigState extends State<OfficialBindingConfig> {
  final List<ConfigurationModel> configs;

  _OfficialBindingConfigState(this.configs);

  final instructionsCtrl = TextEditingController();

  File pdfFile;

  bool fileUploaded = false;

  @override
  void initState() {
    super.initState();
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    pdfBloc.setOfficialBindingConfig = configs[0].id;
    widget.onChanged(pdfBloc.officialBindingConfig);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pdfBloc = Provider.of<PDFBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Binding Configuration',
          style: textTheme.caption
              .copyWith(color: Color(0xFF173A50), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(right: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: configs.map((config) {
              return Row(
                children: [
                  Radio(
                    value: config.id,
                    groupValue: pdfBloc.officialBindingConfig,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) {
                      widget.onChanged(value);
                      pdfBloc.setOfficialBindingConfig = config.id;
                      setState(() {});
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(config.title),
                      Row(
                        children: <Widget>[
                          Text(
                            "${config.price > 0 ? "₹ "
                                "${config.price}"
                                "${this ^ config.perPageCount}"
                                "" : 'Free'} ",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          ),
                          config.strikePrice == 0
                              ? Container()
                              : Text(
                                  '₹ ${config.strikePrice}'
                                  '${this ^ config.perPageCount}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
        pdfBloc.officialBindingConfig ==
                configs.firstWhere((data) => data.title == 'Hard Binding').id
            ? Column(
                children: <Widget>[
                  // Text(
                  //   'Front Cover',
                  //   style: textTheme.title.copyWith(color: Color(0xFF173A50)),
                  // ),
                  // SizedBox(height: 20),
                  PDFBox(
                    orderId: widget.orderFileId,
                    pdfKey: 'front_cover_pdf',
                    index: 0,
                    onUploaded: (bool isUploaded, int orderId, filePath) {
                      fileUploaded = isUploaded;
                      setState(() {});
                    },
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
                  controller: pdfBloc.frontCoverNotesCtrl,
                  decoration: InputDecoration(hintText: 'Tap to edit'),
                ),
              )
      ],
    );
  }

  operator ^(int pageCount) {
    if (pageCount == 1) return ' ';
    return '/ $pageCount\page';
  }
}
