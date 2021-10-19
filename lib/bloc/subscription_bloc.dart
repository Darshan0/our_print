import 'package:flutter/cupertino.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/user_subscription_model.dart';
import 'package:ourprint/utils/strings.dart';

class SubscriptionBloc with ChangeNotifier {
  UserSubscriptionModel _userSubscription;
  List<ConfigurationModel> _configurations;

  UserSubscriptionModel get userSubscription => _userSubscription;

  get configurations => _configurations;

  set setUserSubscription(UserSubscriptionModel val) {
    _userSubscription = val;
    notifyListeners();
  }

  set setConfigurations(List<ConfigurationModel> val) {
    _configurations = val;
  }

  int getPageUsed(PDFBloc pdfBloc, fileId) {
    var file = pdfBloc.files.firstWhere((e) => e['file_id'] == fileId);
    int index = pdfBloc.files.indexOf(file);
    var calcPage = _userSubscription.pageLeft.toDouble();
    var pageLeft = getPageLeftFromFile(index, calcPage, pdfBloc);
    return (calcPage - pageLeft).round();
  }

  int getPageLeft(PDFBloc pdfBloc, {bool isWholeNumber = true}) {
    var calcPage = _userSubscription.pageLeft.toDouble();
    pdfBloc.files.forEach((element) {
      int index = pdfBloc.files.indexOf(element);
      calcPage = getPageLeftFromFile(index, calcPage, pdfBloc) ?? calcPage;
    });
    if (isWholeNumber) if (calcPage < 0) return 0;
    return calcPage.toInt();
  }

  dynamic getPageLeftFromFile(index, availablePageCounter, PDFBloc pdfBloc,
      {bool getExceededPages}) {
    var subsPlan = userSubscription.subscription;

    var numOfCopies = int.tryParse(pdfBloc.numOfCopiesCtrlss[index].text) ?? 1;

    var overExceeded = <Map<String, dynamic>>[];

    int pageCount = pdfBloc.files[index]['pdf_page_count'];

    if (pageCount == null) return null;

    int totalPages = numOfCopies * pageCount;
    var configNames = pdfBloc.getConfigNames(index, _configurations);

    if (configNames.any((element) => element.contains(Strings.bondPaper))) {
      var pageCounter = totalPages * subsPlan.bondColorSingleSide;
      if (getExceededPages == true) {
        if (pageCounter > availablePageCounter) {
          final exceededPageCounter = (pageCounter -
              (availablePageCounter < 0 ? 0 : availablePageCounter));
          overExceeded.add({
            'config_name': [Strings.bondPaper],
            'overused_pages':
                exceededPageCounter ~/ subsPlan.bondColorSingleSide,
          });
        }
      }
      availablePageCounter -= pageCounter;
    } else {
      if (configNames.contains(Strings.bw) &&
          configNames.contains(Strings.oneSided)) {
        var pageCounter = totalPages * subsPlan.blackWhiteSingleSide;
        if (getExceededPages == true) {
          if (pageCounter > availablePageCounter) {
            final exceededPageCounter = (pageCounter -
                (availablePageCounter < 0 ? 0 : availablePageCounter));
            overExceeded.add({
              'config_name': [Strings.bw, Strings.oneSided],
              'overused_pages':
                  exceededPageCounter ~/ subsPlan.blackWhiteSingleSide,
            });
          }
        }
        availablePageCounter -= pageCounter;
      } else if (configNames.contains(Strings.bw) &&
          configNames.contains(Strings.twoSided)) {
        var pageCounter = totalPages * subsPlan.blackWhiteDoubleSide;

        if (getExceededPages == true) {
          if (pageCounter > availablePageCounter) {
            final exceededPageCounter = (pageCounter -
                (availablePageCounter < 0 ? 0 : availablePageCounter));
            overExceeded.add({
              'config_name': [Strings.bw, Strings.twoSided],
              'overused_pages':
                  exceededPageCounter ~/ subsPlan.blackWhiteDoubleSide,
            });
          }
        }
        availablePageCounter -= pageCounter;
      } else if ((configNames.contains(Strings.color) ||
              configNames.contains(Strings.multiColor)) &&
          configNames.contains(Strings.oneSided)) {
        var pageCounter = totalPages * subsPlan.colorSingleSide;

        if (getExceededPages == true) {
          if (pageCounter > availablePageCounter) {
            final exceededPageCounter = (pageCounter -
                (availablePageCounter < 0 ? 0 : availablePageCounter));
            var isColored = configNames.contains(Strings.color);
            overExceeded.add({
              'config_name': [
                isColored ? Strings.color : Strings.multiColor,
                Strings.oneSided
              ],
              'overused_pages': exceededPageCounter ~/ subsPlan.colorSingleSide,
            });
          }
        }
        availablePageCounter -= pageCounter;
      } else if ((configNames.contains(Strings.color) ||
              configNames.contains(Strings.multiColor)) &&
          configNames.contains(Strings.twoSided)) {
        var pageCounter = totalPages * subsPlan.colorDoubleSide;

        if (getExceededPages == true) {
          if (pageCounter > availablePageCounter) {
            final exceededPageCounter = (pageCounter -
                (availablePageCounter < 0 ? 0 : availablePageCounter));
            var isColored = configNames.contains(Strings.color);
            overExceeded.add({
              'config_name': [
                isColored ? Strings.color : Strings.multiColor,
                Strings.twoSided
              ],
              'overused_pages': exceededPageCounter ~/ subsPlan.colorDoubleSide,
            });
          }
        }
        availablePageCounter -= pageCounter;
      }
    }
    if (getExceededPages == true) {
      overExceeded.add({
        'available_page_counter': availablePageCounter,
      });
      return overExceeded;
    }
    return availablePageCounter;
  }

  int getExceededPage(pdfBloc) {
    int pageLeft = getPageLeft(pdfBloc, isWholeNumber: false);
    return pageLeft * -1;
  }

  Map<String, dynamic> get getPageCounter {
    return {
      'B/W, Single side': userSubscription.subscription.blackWhiteSingleSide,
      'B/W, Double side': userSubscription.subscription.blackWhiteDoubleSide,
      'Colour, Single side': userSubscription.subscription.colorSingleSide,
      'Colour, double side': userSubscription.subscription.colorDoubleSide,
      'Bond Paper': userSubscription.subscription.bondColorSingleSide,
    };
  }
}
