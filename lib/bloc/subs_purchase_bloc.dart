import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/model/subscription_model.dart';
import 'package:ourprint/repository/payment_repo.dart';
import 'package:ourprint/repository/subscription_repo.dart';
import 'package:ourprint/screens/home_page/home_page.dart';
import 'package:ourprint/screens/order_details_pages/order_confirmed.dart';
import 'package:ourprint/utils/error_handling.dart';
import 'package:ourprint/widgets/dialog_boxes.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';

class SubsPurchaseBloc with ChangeNotifier {
  Razorpay _razorpay;
  BuildContext _context;
  bool _isExtending;

  init(context, {isExtending = false}) {
    _razorpay?.clear();
    _razorpay = Razorpay();
    this._context = context;
    this._isExtending = isExtending;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  var orderId;

  void _startRazorPay(Map result) async {
    orderId = result['id'];
    final email = await Prefs.getUserEmail();
    final number = await Prefs.getUserMobileNumber();
    var options = {
      'key': 'rzp_live_2hHxvmoZPbKYDz',
      // 'key': 'rzp_test_ze2NdJ9nokr6qc',
      'notes': {'order_id': orderId},
      'amount': result['amount'] * 100,
      'name': 'Our Print',
      'theme': {'color': '#53905F'},
      'description': 'Order no. ${orderId}',
      'prefill': {'contact': number, 'email': email}
    };
    print(options);
    _razorpay.open(options);
  }

  createSubscriptionPlan(SubscriptionModel plan) async {
    try {
      LoadingWidget.showLoadingDialog(_context);
      final date = DateTime.now();
      var response = await SubscriptionRepo.createSubscriptionPlan({
        'user': await Prefs.getUserId(),
        'subscription_plan': plan.id,
        'subscription_plan_snapshot': jsonEncode(plan.toMap()),
        'page_left': plan.pageCounter,
        'expire_on':
            DateTime(date.year, date.month + plan.validForInMonths, date.day)
                .toString(),
      });
      Navigator.pop(_context);
      _startRazorPay({'amount': plan.price, 'id': response['id']});
    } catch (e) {
      Navigator.pop(_context);
      return DialogBox.parseAndShowErrorDialog(_context, e);
    }
  }

  _handlePaymentSuccess(PaymentSuccessResponse data) async {
    print('_handlePaymentSuccess');
    print(data.orderId);
    print(data.paymentId);
    print(data.signature);
    LoadingWidget.showLoadingDialog(_context);
    try {
      var response = await PaymentRepo.verifySubscriptionPayment(
          {'order_id': orderId.toString(), 'payment_id': data.paymentId});
      if (response['code'] == 0) {
        Toast.show('Payment Successful :)', _context, duration: 3);
        if (_isExtending) {
          Navigator.pop(_context);
          return Navigator.pop(_context);
        } else
          return HomePage.openAndRemoveUntil(_context);
      }
    } catch (e) {
      print(e);
      Navigator.pop(_context);
      DialogBox.parseAndShowErrorDialog(_context, e);
    }
    Navigator.pop(_context);
  }

  _handlePaymentError(PaymentFailureResponse data) {
    print('_handlePaymentError');
    Toast.show('Payment Failed', _context, duration: 3);
    print(data.message);
    print(data.code);
  }

  _handleExternalWallet(data) {
    print('_handleExternalWallet');
    print(data);
  }
}
