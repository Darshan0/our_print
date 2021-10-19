import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/screens/file_config_page/file_config.dart';
import 'package:ourprint/utils/strings.dart';
import 'package:provider/provider.dart';

class PageConfig extends StatefulWidget {
  final Function(int val) onChanged;
  final List<ConfigurationModel> configs;

  PageConfig({Key key, this.onChanged, this.configs}) : super(key: key);

  @override
  _PageConfigState createState() => _PageConfigState(configs);
}

class _PageConfigState extends State<PageConfig> {
  final List<ConfigurationModel> configs;

  _PageConfigState(this.configs);

  @override
  void initState() {
    super.initState();
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    pdfBloc.setPageConfig = configs[0].id;
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
          'Page Configuration',
          style: textTheme.caption
              .copyWith(color: Color(0xFF173A50), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(right: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: configs.map(
              (config) {
                final selectedPrintConfig = pdfBloc.configurationList
                    .firstWhere((e) => e.id == pdfBloc.printConfig);
                return Flexible(
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                        value: config.id,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        groupValue: pdfBloc.pageConfig,
                        onChanged: (value) {
                          widget.onChanged(value);
                          pdfBloc.setPageConfig = config.id;
                          setState(() {});
                        },
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              config.title,
                              style: textTheme.bodyText1,
                            ),
                            if (pdfBloc.orderType != OrderType.SUBSCRIPTION) ...[
                              SizedBox(height: 4),
                              if (selectedPrintConfig.title == Strings.bw)
                                if (config.title == Strings.oneSided)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '₹ ${pdfBloc.dependentConfigPrice.blackWhiteSingleSide}'
                                        '/${this ^ config.perPageCount}page  ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: theme.accentColor,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          '₹ ${pdfBloc.dependentConfigPrice.blackWhiteSingleSideStrike}'
                                          '/${this ^ config.perPageCount}page',
                                          style: TextStyle(
                                            fontSize: 12,
                                            decoration: TextDecoration.lineThrough,
                                            fontWeight: FontWeight.w500,
                                            color: theme.accentColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '₹ ${pdfBloc.dependentConfigPrice.blackWhiteDoubleSide}'
                                        '/${this ^ config.perPageCount}page  ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: theme.accentColor,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          '₹ ${pdfBloc.dependentConfigPrice.blackWhiteDoubleSideStrike}'
                                          '/${this ^ config.perPageCount}page  ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            decoration: TextDecoration.lineThrough,
                                            fontWeight: FontWeight.w500,
                                            color: theme.accentColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              else if (selectedPrintConfig.title == Strings.color ||
                                  selectedPrintConfig.title == Strings.multiColor)
                                if (config.title == Strings.oneSided)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '₹ ${pdfBloc.dependentConfigPrice.colorSingleSide}'
                                        '/${this ^ config.perPageCount}page  ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: theme.accentColor,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          '₹ ${pdfBloc.dependentConfigPrice.colorSingleSideStrike}'
                                          '/${this ^ config.perPageCount}page  ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            decoration: TextDecoration.lineThrough,
                                            fontWeight: FontWeight.w500,
                                            color: theme.accentColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '₹ ${pdfBloc.dependentConfigPrice.colorDoubleSide}'
                                        '/${this ^ config.perPageCount}page  ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: theme.accentColor,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          '₹ ${pdfBloc.dependentConfigPrice.colorDoubleSideStrike}'
                                          '/${this ^ config.perPageCount}page  ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            decoration: TextDecoration.lineThrough,
                                            fontWeight: FontWeight.w500,
                                            color: theme.accentColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ),
        if (pdfBloc.orderType == OrderType.SUBSCRIPTION)
          SizedBox(height: 16)
        else
          SizedBox(height: 32),
      ],
    );
  }

  operator ^(int pageCount) {
    if (pageCount == 1) return '';
    return pageCount;
  }
}
