import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/resources/images.dart';
import 'package:provider/provider.dart';

class PrintingConfig extends StatefulWidget {
  final Function(int id) onChanged;
  final TextEditingController controller;
  final List<ConfigurationModel> configs;
  final pdfPageCount;

  PrintingConfig({
    Key key,
    this.onChanged,
    this.controller,
    this.configs,
    this.pdfPageCount,
  }) : super(key: key);

  @override
  _PrintingConfigState createState() => _PrintingConfigState(configs);
}

class _PrintingConfigState extends State<PrintingConfig> {
  final List<ConfigurationModel> configs;

  _PrintingConfigState(this.configs);

  @override
  void initState() {
    super.initState();
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    pdfBloc.setPrintConfig = configs[0].id;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pdfBloc = Provider.of<PDFBloc>(context);
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.copyWith(
              caption: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.green),
              subhead: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.black),
            ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Print Configuration',
            style: textTheme.caption.copyWith(color: Color(0xFF173A50)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              runSpacing: 0,
              spacing: 20,
              alignment: WrapAlignment.spaceBetween,
              children: configs.map(
                (config) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: config.id,
                            groupValue: pdfBloc.printConfig,
                            onChanged: (value) {
                              widget.onChanged(value);
                              pdfBloc.setPrintConfig = config.id;
                              setState(() {});
                            },
                          ),
                          Text(
                            config.title,
                            style: textTheme.bodyText1,
                          )
                        ],
                      ),
                      if (config.title == 'Multicolor')
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Enter page numbers that needs to be '
                                'printed in colour as shown below ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            if (pdfBloc.printConfig ==
                                configs
                                    .firstWhere(
                                        (data) => data.title == 'Multicolor')
                                    .id)
                              Form(
                                key: pdfBloc.formKey,
                                child: TextFormField(
                                  validator: validateNotesField,
                                  controller: widget.controller,
                                  decoration: InputDecoration(
                                    hintText: 'Eg : 1-4, 12-20, 34-50',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                          ],
                        )
                    ],
                  );
                },
              ).toList(),
            ),
          ),
          SizedBox(height: 28),
        ],
      ),
    );
  }

  operator ^(int pageCount) {
    if (pageCount == 1) return '';
    return pageCount;
  }

  String validateNotesField(String value) {
    if (value.trim().isEmpty) return 'This field is required';
    var list = value.split(',');
    print(list);
    var noOfPages = 0;
    try {
      list.forEach((value) {
        if (value.contains('-')) {
          var first = int.parse(value.substring(0, value.indexOf('-')));
          var second = int.parse(value.substring(value.indexOf('-') + 1));
          noOfPages += second - first;
          noOfPages++;
        } else {
          if (int.parse(value) != null) {
            if (int.parse(value) <= widget.pdfPageCount)
              noOfPages++;
            else
              throw '';
          }
        }
      });
    } catch (e) {
      print(e);
      return 'Invalid input';
    }
    print('total $noOfPages');
    if (widget.pdfPageCount < noOfPages) return 'Invalid input';
    return null;
  }

  Widget getImage(String title) {
    switch (title) {
      case 'Black and White':
        return Image.asset(Images.blackWhiteContainer);
        break;
      case 'Color':
        return Image.asset(Images.coloredContainer);
        break;
      case 'Multicolor':
        return Image.asset(Images.multiColoredContainer);
        break;
      default:
        return Text('Unknown Config');
    }
  }
}
