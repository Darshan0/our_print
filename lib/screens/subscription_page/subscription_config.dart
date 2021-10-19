import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/bloc/subscription_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/user_subscription_model.dart';
import 'package:ourprint/repository/configuration_repo.dart';
import 'package:ourprint/repository/order_repo.dart';
import 'package:ourprint/screens/address_pages/address.dart';
import 'package:ourprint/screens/order_config/binding_config.dart';
import 'package:ourprint/screens/order_config/page_config.dart';
import 'package:ourprint/screens/order_config/paper_config.dart';
import 'package:ourprint/screens/order_config/print_config.dart';
import 'package:ourprint/widgets/dialog_boxes.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:ourprint/widgets/pdf_box.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class SubscriptionConfig extends StatefulWidget {
  final UserSubscriptionModel userSubscription;

  const SubscriptionConfig({Key key, this.userSubscription}) : super(key: key);

  static open(context, UserSubscriptionModel val) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SubscriptionConfig(userSubscription: val)));

  @override
  _SubscriptionConfigState createState() =>
      _SubscriptionConfigState(userSubscription);
}

class _SubscriptionConfigState extends State<SubscriptionConfig> {
  final UserSubscriptionModel userSubscription;
  Future<List<ConfigurationModel>> future;
  final scrollCtrl = ScrollController();

  _SubscriptionConfigState(this.userSubscription);

  Future<List<ConfigurationModel>> getDetails() async {
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    final subsBloc = Provider.of<SubscriptionBloc>(context, listen: false);

    final res = await ConfigurationsRepo.getConfigs();
    final res2 = await ConfigurationsRepo.getDependentConfigPrice();

    subsBloc.setUserSubscription = userSubscription;
    subsBloc.setConfigurations = res;
    pdfBloc.configurationList = res;
    pdfBloc.dependentConfigPrice = res2;
    return res;
  }

  @override
  void initState() {
    super.initState();
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    pdfBloc.init();
    future = getDetails();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final pdfBloc = Provider.of<PDFBloc>(context);
    return FutureBuilder<List<ConfigurationModel>>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError) return CustomErrorWidget(error: snap.error);
          if (!snap.hasData) return Material(child: LoadingWidget());
          final configs = snap.data;
          return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        if (pdfBloc.files.last['file_id'] == null)
                          return Toast.show(
                              'Please upload a PDF File', context);
                        if (!isDataValidated())
                          return Toast.show(
                              'Missing or Invalid Fields', context,
                              duration: 3);
                        pdfBloc.addFile();
                        scrollCtrl.animateTo(
                          0.0,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );
                        setState(() {});
                      },
                      child: Text('ADD NEW'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (!pdfBloc.isPDFUploaded())
                          return Toast.show(
                              'Please select atleast one PDF', context);

                        if (!isDataValidated())
                          return Toast.show(
                              'Missing or Invalid  Fields', context,
                              duration: 3);
                        _saveDetails(configs);
                      },
                      child: Text('NEXT'),
                    ),
                  ],
                ),
              ),
              appBar: AppBar(),
              body: SingleChildScrollView(
                controller: scrollCtrl,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              'Upload your files',
                              style: textTheme.title
                                  .copyWith(color: Color(0xFF173A50)),
                            ),
                          ),
                          Text('Page counters left: ',
                              style: textTheme.caption),
                          FutureBuilder(
                              future: Future.delayed(Duration.zero),
                              builder: (context, snapshot) {
                                return Text(
                                  '${getPageLeft(snap.data)}',
                                  style: textTheme.caption.copyWith(
                                    color: theme.accentColor,
                                  ),
                                );
                              }),
                        ],
                      ),
                      SizedBox(height: 20),
                      ...List.generate(
                        pdfBloc.files.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: PDFBox(
                              index: index,
                              onPicked: (val) {},
                              onUploaded:
                                  (isCompleted, fileId, filePath) async {
                                if (!isCompleted) return;
                                pdfBloc.files[index]['file_id'] = fileId;
                                pdfBloc.files[index]['file_path'] = filePath;
                                final doc =
                                    await PdfDocument.openFile(filePath);
                                pdfBloc.files[index]['pdf_page_count'] =
                                    doc.pageCount;
                                setState(() {});
                              },
                              pdfKey: 'pdf',
                            ),
                          );
                        },
                      ),
                      Text(
                        'Details',
                        style: textTheme.caption.copyWith(
                          color: Color(0xFF173A50),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(top: 20),
                        title: Text(
                          'Enter a Title for your document',
                          style: textTheme.caption,
                        ),
                        subtitle: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: pdfBloc.titleCtrl,
                          // validator: (value) => value.trim().isEmpty
                          //     ? 'Please enter a Title'
                          //     : null,
                          decoration: InputDecoration(hintText: 'Tap to edit'),
                        ),
                      ),
                      SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.only(top: 20),
                        title: Text(
                          'Enter any instructions that should be carried out \n'
                          'while printing your file ',
                          style: textTheme.caption,
                        ),
                        subtitle: TextFormField(
                          controller: pdfBloc.instructionCtrl,
                          decoration: InputDecoration(hintText: 'Tap to edit'),
                        ),
                      ),
                      SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.only(top: 20),
                        title: Text(
                          'Enter number of copies',
                          style: textTheme.caption,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            children: [
                              Flexible(
                                child: TextFormField(
                                  onChanged: (val) {
                                    setState(() {});
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  validator: (val) {
                                    if (val.trim().isEmpty)
                                      return 'Invalid value';
                                    return null;
                                  },
                                  controller: pdfBloc.numOfCopiesCtrl,
                                  decoration: InputDecoration(
                                    hintText: '01',
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  var copies = int.tryParse(
                                      pdfBloc.numOfCopiesCtrl.text);
                                  if (copies == null) return;
                                  if (copies == 1) return;
                                  copies--;
                                  pdfBloc.numOfCopiesCtrl.text = '$copies';
                                  setState(() {});
                                },
                                child: Container(
                                  height: 44,
                                  width: 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: int.tryParse(
                                                pdfBloc.numOfCopiesCtrl.text) ==
                                            1
                                        ? Colors.black38
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  var copies = int.tryParse(
                                      pdfBloc.numOfCopiesCtrl.text);
                                  if (copies == null) return;
                                  copies++;
                                  pdfBloc.numOfCopiesCtrl.text = '$copies';
                                  setState(() {});
                                },
                                child: Container(
                                  height: 44,
                                  width: 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    Icons.arrow_drop_up,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      PaperConfig(
                        configs: configs
                            .where((val) => val.type == 'paper')
                            .toList(),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                      PrintingConfig(
                        controller: pdfBloc.multiColorNotesCtrl,
                        onChanged: (val) {
                          setState(() {});
                        },
                        pdfPageCount: pdfBloc.currentFile['pdf_page_count'],
                        configs: configs
                            .where((val) => val.type == 'print')
                            .toList(),
                      ),
                      PageConfig(
                        configs: configs
                            .where((val) => val.type == 'page')
                            .toList()
                            .reversed
                            .toList(),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                      BindingConfig(
                        onChanged: (val) {
                          setState(() {});
                        },
                        configs: configs.where((val) {
                          return val.type == 'binding' &&
                              val.title != 'Hard Binding';
                        }).toList(),
                      ),
                      // if (pdfBloc.orderType == OrderType.OFFICIAL_DOCUMENTS)
                      //   if (pdfBloc.currentFile['file_id'] != null)
                      //     OfficialBindingConfig(
                      //       orderFileId: pdfBloc.currentFile['file_id'],
                      //       configs: configs.where((val) {
                      //         return val.type == 'binding' &&
                      //             (val.title == 'Loose Paper' ||
                      //                 val.title == 'Hard Binding');
                      //       }).toList(),
                      //       onChanged: (val) {
                      //         pdfBloc.addConfig(val);
                      //       },
                      //     ),
                    ],
                  ),
                ),
              ));
        });
  }

  int getPageLeft(List<ConfigurationModel> configs) {
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    final subsBloc = Provider.of<SubscriptionBloc>(context, listen: false);
    return subsBloc.getPageLeft(pdfBloc);
  }

  _saveDetails(List<ConfigurationModel> configs) async {
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    final subsBloc = Provider.of<SubscriptionBloc>(context, listen: false);
    bool hasError = false;
    LoadingWidget.showLoadingDialog(context);
    for (var val in pdfBloc.files) {
      if (val['file_id'] != null) {
        final index = pdfBloc.files.indexOf(val);
        final doc = await PdfDocument.openFile(val['file_path']);
        final configIds = pdfBloc.getConfigs(index);
        var selectedConfigs = <Map<String, dynamic>>[];
        configs.forEach((element) {
          if (!configIds.contains(element.id)) return;
          selectedConfigs.add(element.toMap());
        });
        try {
          await OrderRepo.updatePDFDetails(val['file_id'], {
            'title': pdfBloc.titleCtrlss.elementAt(index).text,
            'num_of_copies': pdfBloc.numOfCopiesCtrlss.elementAt(index).text,
            'notes': pdfBloc.instructionsCtrlss.elementAt(index).text,
            'multi_color_notes':
                pdfBloc.multiColorNotesCtrlss.elementAt(index).text,
            'front_cover_pdf_info':
                pdfBloc.frontCoverNotesCtrlss.elementAt(index).text,
            'configurations': configIds,
            'config_list': jsonEncode(selectedConfigs),
            'pdf_page_count': doc.pageCount,
            'page_counter_used': subsBloc.getPageUsed(pdfBloc, val['file_id']),
            'file_name': val['file_path'].toString().split('/').last,
          });
        } catch (e) {
          hasError = true;
          DialogBox.parseAndShowErrorDialog(context, e);
        }
      }
    }
    Navigator.pop(context);
    if (!hasError)
      Address.open(context);
    else
      DialogBox.showErrorDialog(context, 'Some Error Occurred');
  }

  bool isDataValidated() {
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    if (!pdfBloc.isDataValidated()) return false;
    if (!pdfBloc.isFieldsValidated()) return false;
    return true;
  }
}
