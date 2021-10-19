import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/bloc/subscription_bloc.dart';
import 'package:ourprint/repository/order_repo.dart';
import 'package:ourprint/repository/subscription_repo.dart';
import 'package:ourprint/screens/subscription_page/pages_exceed_payment.dart';
import 'package:ourprint/screens/subscription_page/subscription_plans.dart';
import 'package:ourprint/utils/error_handling.dart';
import 'package:ourprint/widgets/dialog_boxes.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class SubsPageExceeded extends StatelessWidget {
  final orderId;

  const SubsPageExceeded({Key key, this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final pdfBloc = Provider.of<PDFBloc>(context);
    final subsBloc = Provider.of<SubscriptionBloc>(context);

    return Center(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.print, color: theme.accentColor, size: 48),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'You have exceeded the number of page counter for subscription',
                  style: textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No. of page counter exceeded: ',
                    style: textTheme.subtitle1
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${subsBloc.getExceededPage(pdfBloc)}',
                    style: textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.accentColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: RaisedButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (_) {
                          return SubscriptionPlans(isExtending: true);
                        });
                    LoadingWidget.showLoadingDialog(context);
                    var response = await SubscriptionRepo.checkIfSubscribed();
                    Navigator.pop(context);
                    final subsBloc =
                        Provider.of<SubscriptionBloc>(context, listen: false);
                    subsBloc.setUserSubscription = response;
                    Navigator.pop(context);
                  },
                  child: Text('EXTEND SUBSCRIPTION'),
                ),
              ),
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: OutlineButton(
                  onPressed: () {
                    _uploadExceedPage(context);
                  },
                  highlightedBorderColor: theme.accentColor,
                  textColor: theme.accentColor,
                  borderSide: BorderSide(
                    color: theme.accentColor,
                    width: 0.6,
                  ),
                  child: Text('PAY FOR EXTRA PAGES'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _uploadExceedPage(context) async {
    final pdfBloc = Provider.of<PDFBloc>(context, listen: false);
    final subsBloc = Provider.of<SubscriptionBloc>(context, listen: false);
    bool hasError = false;
    var pageLeft = subsBloc.userSubscription.pageLeft.toDouble();

    LoadingWidget.showLoadingDialog(context);
    for (var val in pdfBloc.files) {
      final index = pdfBloc.files.indexOf(val);
      List<Map<String, dynamic>> response = subsBloc.getPageLeftFromFile(
          index, pageLeft, pdfBloc,
          getExceededPages: true);
      if (response == null) return;
      print(response);
      pageLeft = response.last['available_page_counter'];
      try {
        await OrderRepo.updatePDFDetails(
          val['file_id'],
          {'exceeded_page_config': jsonEncode(response)},
        );
      } catch (e) {
        hasError = true;
        DialogBox.parseAndShowErrorDialog(context, e);
      }
    }
    Navigator.pop(context);
    if (hasError) return Toast.show('Some Error Occurred', context);
    PageExceedPayment.open(context, orderId);
  }
}
