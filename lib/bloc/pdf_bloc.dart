import 'package:flutter/cupertino.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/dependent_config_price.dart';
import 'package:ourprint/screens/file_config_page/file_config.dart';
import 'package:ourprint/utils/strings.dart';
import 'package:pdf_render/pdf_render.dart';

class PDFBloc with ChangeNotifier {
  var _configurationList = <ConfigurationModel>[];
  DependentConfigPrice _dependentConfigPrice;
  var files = List<Map<String, dynamic>>();
  OrderType _orderType;
  var _paperConfigss = <int>[];
  var _printConfigss = <int>[];
  var _pageConfigss = <int>[];
  var _bindingConfigss = <int>[];
  var _formKeyss = <GlobalKey<FormState>>[];
  var _officialBindingConfigss = <int>[];
  var titleCtrlss = <TextEditingController>[];
  var instructionsCtrlss = <TextEditingController>[];
  var numOfCopiesCtrlss = <TextEditingController>[];
  var multiColorNotesCtrlss = <TextEditingController>[];
  var frontCoverNotesCtrlss = <TextEditingController>[];
  int selectedFileIndex = 0;

  List<ConfigurationModel> get configurationList => _configurationList;

  DependentConfigPrice get dependentConfigPrice => _dependentConfigPrice;

  Map<String, dynamic> get currentFile => files[selectedFileIndex];

  GlobalKey<FormState> get formKey => _formKeyss[selectedFileIndex];

  TextEditingController get titleCtrl => titleCtrlss[selectedFileIndex];

  TextEditingController get instructionCtrl =>
      instructionsCtrlss[selectedFileIndex];

  TextEditingController get numOfCopiesCtrl =>
      numOfCopiesCtrlss[selectedFileIndex];

  TextEditingController get multiColorNotesCtrl =>
      multiColorNotesCtrlss[selectedFileIndex];

  TextEditingController get frontCoverNotesCtrl =>
      frontCoverNotesCtrlss[selectedFileIndex];

  int get paperConfig => _paperConfigss[selectedFileIndex];

  int get pageConfig => _pageConfigss[selectedFileIndex];

  int get printConfig => _printConfigss[selectedFileIndex];

  int get bindingConfig => _bindingConfigss[selectedFileIndex];

  int get officialBindingConfig => _officialBindingConfigss[selectedFileIndex];

  OrderType get orderType => _orderType;

  String get orderTypeField {
    var orderType = {
      OrderType.STANDARD: 'standard_print',
      OrderType.OFFICIAL_DOCUMENTS: 'official_documents',
      OrderType.SUBSCRIPTION: 'subscription',
    };
    return orderType[_orderType];
  }

  set setOrderTypeField(String val) {
    var orderType = {
      'standard_print': OrderType.STANDARD,
      'official_documents': OrderType.OFFICIAL_DOCUMENTS,
      'subscription': OrderType.SUBSCRIPTION,
    };
    _orderType = orderType[val];
  }

  set configurationList(val) {
    _configurationList = val;
  }

  set dependentConfigPrice(val) {
    _dependentConfigPrice = val;
  }

  set setOrderType(val) {
    _orderType = val;
  }

  set setPaperConfig(int val) {
    _paperConfigss[selectedFileIndex] = val;
  }

  set setPrintConfig(int val) {
    _printConfigss[selectedFileIndex] = val;
  }

  set setPageConfig(int val) {
    _pageConfigss[selectedFileIndex] = val;
  }

  set setBindingConfig(int val) {
    _bindingConfigss[selectedFileIndex] = val;
  }

  set setOfficialBindingConfig(int val) {
    _officialBindingConfigss[selectedFileIndex] = val;
  }

  double getPrintingPerPageCharge(index) {
    final selectedPrintConfig = configurationList
        .firstWhere((e) => e.id == _printConfigss.elementAt(index));
    final selectedPageConfig = configurationList
        .firstWhere((e) => e.id == _pageConfigss.elementAt(index));
    if (selectedPrintConfig.title == Strings.bw) {
      if (selectedPageConfig.title == Strings.oneSided)
        return dependentConfigPrice.blackWhiteSingleSide;
      return dependentConfigPrice.blackWhiteDoubleSide;
    } else {
      if (selectedPageConfig.title == Strings.oneSided)
        return dependentConfigPrice.colorSingleSide;
      return dependentConfigPrice.colorDoubleSide;
    }
  }

  double getBWCharges(index) {
    final selectedPageConfig = configurationList
        .firstWhere((e) => e.id == _pageConfigss.elementAt(index));
    if (selectedPageConfig.title == Strings.oneSided)
      return dependentConfigPrice.blackWhiteSingleSide;
    return dependentConfigPrice.blackWhiteDoubleSide;
  }

  init() async {
    files = [];
    _formKeyss = [];
    _paperConfigss = [];
    _printConfigss = [];
    _pageConfigss = [];
    _bindingConfigss = [];
    _officialBindingConfigss = [];
    titleCtrlss = [];
    instructionsCtrlss = [];
    numOfCopiesCtrlss = [];
    multiColorNotesCtrlss = [];
    frontCoverNotesCtrlss = [];
    await Future.delayed(Duration.zero);
    addFile();
  }

  removeLastFile() {
    files.removeLast();
    notifyListeners();
  }

  removeAt(index) {
    if (files.length == 1) {
      files[0] = {};
    } else {
      files.removeAt(index);
    }
    changeSelectedIndex(files.length - 1);
    notifyListeners();
  }

  void addFile() {
    files.add({});
    _formKeyss.add(GlobalKey<FormState>());
    _paperConfigss.add(_paperConfigss.isEmpty ? 0 : _paperConfigss.first);
    _printConfigss.add(_printConfigss.isEmpty ? 0 : _printConfigss.first);
    _pageConfigss.add(_pageConfigss.isEmpty ? 0 : _pageConfigss.first);
    _bindingConfigss.add(_bindingConfigss.isEmpty ? 0 : _bindingConfigss.first);
    _officialBindingConfigss.add(
        _officialBindingConfigss.isEmpty ? 0 : _officialBindingConfigss.first);

    titleCtrlss.add(TextEditingController());
    instructionsCtrlss.add(TextEditingController());
    numOfCopiesCtrlss.add(TextEditingController(text: '01'));
    multiColorNotesCtrlss.add(TextEditingController());
    frontCoverNotesCtrlss.add(TextEditingController());
    changeSelectedIndex(files.length - 1);
  }

  changeSelectedIndex(index) {
    selectedFileIndex = index;
    notifyListeners();
  }

  List<int> getConfigs(index) {
    var configs = [
      _paperConfigss.elementAt(index),
      _printConfigss.elementAt(index),
      _pageConfigss.elementAt(index),
      _bindingConfigss.elementAt(index),
      _officialBindingConfigss.elementAt(index),
    ];
    return configs.where((element) => element != 0).toList();
  }

  List<String> getConfigNames(index, List<ConfigurationModel> configs) {
    var list = [
      _paperConfigss.elementAt(index),
      _printConfigss.elementAt(index),
      _pageConfigss.elementAt(index),
      _bindingConfigss.elementAt(index),
      _officialBindingConfigss.elementAt(index),
    ];
    return configs
        .where((element) => list.contains(element.id))
        .map((e) => e.title)
        .toList();
  }

  List<int> getAllConfigs() {
    var list = _paperConfigss +
        _printConfigss +
        _pageConfigss +
        _bindingConfigss +
        _officialBindingConfigss;
    return list.where((element) => element != 0).toList();
  }

  List<String> getAllConfigsName(List<ConfigurationModel> configs) {
    var list = _paperConfigss +
        _printConfigss +
        _pageConfigss +
        _bindingConfigss +
        _officialBindingConfigss;
    list = list.where((element) => element != 0).toList();
    return configs
        .where((element) => list.contains(element.id))
        .map((e) => e.title)
        .toList();
  }

  bool isPDFUploaded() {
    if (files.where((e) => e['file_id'] != null).isEmpty) return false;
    return true;
  }

  bool isDataValidated() {
    for (var element in files) {
      int index = files.indexOf(element);
      if (element['file_id'] != null) {
        // if (orderType != OrderType.OFFICIAL_DOCUMENTS) {
        // if (titleCtrlss[index].text.trim().isEmpty) return false;
        // }
        final val = numOfCopiesCtrlss[index].text;
        if (val.trim().isEmpty) return false;
        final num = int.tryParse(val);
        if (num == 0 || num == null) return false;
        print('num is $num');
      }
    }
    return true;
  }

  bool isFieldsValidated() {
    for (var element in files) {
      int index = files.indexOf(element);
      if (element['file_id'] != null) {
        if (!(_formKeyss[index].currentState?.validate() ?? true)) return false;
      }
    }
    return true;
  }

  Future<List<Map<String, dynamic>>> getOrderDetails() async {
    var order = <Map<String, dynamic>>[];
    for (var element in files) {
      int index = files.indexOf(element);
      final doc = await PdfDocument.openFile(element['file_path']);
      order.add({
        'file_name': element['file_path'].toString().split('/').last,
        'file_id': element['file_id'],
        'page_count': doc.pageCount,
        'configs': getConfigs(index),
        'multi_color_notes': multiColorNotesCtrlss[index].text,
        'num_of_copies': int.tryParse(numOfCopiesCtrlss[index].text),
      });
    }
    return order;
  }

  Future<int> getTotalPages() async {
    int total = 0;
    for (var element in files) {
      int index = files.indexOf(element);
      final doc = await PdfDocument.openFile(element['file_path']);
      int pageCount = doc.pageCount;
      int numOfCopies = int.tryParse(numOfCopiesCtrlss[index].text);
      total += pageCount * numOfCopies;
    }
    return total;
  }

  double getSpiralBindingCharges(
      int pageCount, int nOfCopies, ConfigurationModel configDetails) {
    double charges = pageCount / configDetails.perPageCount;
    print(charges);
    var finalCharge;
    if (pageCount % 150 == 0)
      finalCharge = charges * configDetails.price;
    else
      finalCharge = (charges + 1).toInt() * configDetails.price;

    return finalCharge * (nOfCopies == 0 ? 1 : nOfCopies);
    // int pdfCount = pageCount * nOfCopies;
    // var finalCharge =
    //     pdfCount / configDetails.perPageCount * configDetails.price;
    // return finalCharge;
  }
}
