import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/screens/file_config_page/file_config.dart';
import 'package:provider/provider.dart';

class BindingConfig extends StatefulWidget {
  final Function(int value) onChanged;
  final List<ConfigurationModel> configs;

  const BindingConfig({
    Key key,
    this.onChanged,
    this.configs,
  }) : super(key: key);

  @override
  _BindingConfigState createState() => _BindingConfigState(
        configs,
      );
}

class _BindingConfigState extends State<BindingConfig> {
  final List<ConfigurationModel> configs;

  _BindingConfigState(this.configs);

  @override
  void initState() {
    super.initState();
    configs.sort((a, b) => b.id.compareTo(a.id)); //Just the sorting for design
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    pdfBloc.setBindingConfig = configs[0].id;
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
          'Binding Configuration',
          style: textTheme.caption
              .copyWith(color: Color(0xFF173A50), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(right: 32),
          child: Wrap(
            runSpacing: pdfBloc.orderType == OrderType.SUBSCRIPTION ? 8 : 20,
            spacing: pdfBloc.orderType != OrderType.SUBSCRIPTION ? 8 : 20,
            alignment: WrapAlignment.spaceBetween,
            children: configs.map(
              (config) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      value: config.id,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      groupValue: pdfBloc.bindingConfig,
                      onChanged: (value) {
                        widget.onChanged(value);
                        pdfBloc.setBindingConfig = config.id;
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₹ ${config.price}/${this ^ config.perPageCount}page  ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: theme.accentColor,
                                ),
                              ),
                              if(config.strikePrice>0)
                              Text(
                                '₹ ${config.strikePrice}/${this ^ config.perPageCount}page  ',
                                style: TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w500,
                                  color: theme.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],
                    )
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }

  operator ^(int pageCount) {
    if (pageCount == 1) return '';
    return pageCount;
  }
}
