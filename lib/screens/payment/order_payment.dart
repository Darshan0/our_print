import 'package:flutter/cupertino.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/repository/payment_repo.dart';
import 'package:ourprint/screens/order_details_pages/order_confirmed.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';

class OrderPayment {
  final BuildContext context;

  OrderPayment(this.context);

  final _razorpay = Razorpay();
  int _orderId = 0;

  init() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void startRazorPay(Map result) async {
    _orderId = result['id'];
    final email = await Prefs.getUserEmail();
    final number = await Prefs.getUserMobileNumber();
    var options = {
      'key': 'rzp_live_2hHxvmoZPbKYDz',
      // 'key': 'rzp_test_ze2NdJ9nokr6qc',
      'notes': {'order_id': _orderId},
      'amount': (result['amount'] + result['delivery_charge']).round() * 100,
      'name': 'Our Print',
      'theme': {'color': '#53905F'},
      'description': 'Order no. ${_orderId}',
      'prefill': {'contact': number, 'email': email}
    };
    print(options);
    _razorpay.open(options);
  }

  _handlePaymentSuccess(PaymentSuccessResponse data) async {
    print('_handlePaymentSuccess');
    print(data.orderId);
    print(data.paymentId);
    print(data.signature);
    LoadingWidget.showLoadingDialog(context);
    try {
      var response = await PaymentRepo.verifyPayment(
          {'order_id': _orderId.toString(), 'payment_id': data.paymentId});
      if (response['code'] == 0) return BookingConfirmed.open(context);
    } catch (e) {
      print(e);
      Toast.show('Payment Failed', context, duration: 3);
      Navigator.pop(context);
    }
    Navigator.pop(context);
  }

  _handlePaymentError(PaymentFailureResponse data) {
    print('_handlePaymentError');
    Toast.show('Payment Failed', context, duration: 3);
    Navigator.pop(context);
    print(data.message);
    print(data.code);
  }

  _handleExternalWallet(var data) {
    print('_handleExternalWallet');
    print(data);
  }
}
