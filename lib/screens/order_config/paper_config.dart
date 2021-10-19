import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/screens/file_config_page/file_config.dart';
import 'package:provider/provider.dart';

class PaperConfig extends StatefulWidget {
  final Function(int value) onChanged;
  final List<ConfigurationModel> configs;

  const PaperConfig({
    Key key,
    this.onChanged,
    this.configs,
  }) : super(key: key);

  @override
  _PaperConfigState createState() => _PaperConfigState(configs);
}

class _PaperConfigState extends State<PaperConfig> {
  final List<ConfigurationModel> configs;

  _PaperConfigState(this.configs);

  @override
  void initState() {
    super.initState();
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    pdfBloc.setPaperConfig = configs[0].id;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final pdfBloc = Provider.of<PDFBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Paper Type',
          style: textTheme.caption
              .copyWith(color: Color(0xFF173A50), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          runSpacing: pdfBloc.orderType == OrderType.SUBSCRIPTION ? 8 : 20,
          spacing: 20,
          alignment: WrapAlignment.spaceBetween,
          children: configs.map(
            (config) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Radio(
                    value: config.id,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    groupValue: pdfBloc.paperConfig,
                    onChanged: (value) {
                      widget.onChanged(value);
                      pdfBloc.setPaperConfig = config.id;
                      setState(() {});
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.title,
                        style: textTheme.bodyText1,
                      ),
                      if (pdfBloc.orderType != OrderType.SUBSCRIPTION) ...[
                        SizedBox(height: 4),
                        Text(
                          config.price > 0
                              ? '₹ ${config.price}/${this ^ config.perPageCount}page  '
                              : 'Free',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: theme.accentColor,
                          ),
                        ),
                      ]
                    ],
                  )
                ],
              );
            },
          ).toList(),
        ),
        SizedBox(height: 24)
      ],
    );
  }

  operator ^(int pageCount) {
    if (pageCount == 1) return '';
    return pageCount;
  }
}
