import 'package:flutter/material.dart';
import 'package:ourprint/screens/home_page/home_page.dart';
import 'package:ourprint/screens/voucher_pages/user_coin_details_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'coins_addition_animations.dart';

// ignore: must_be_immutable
class CoinsAddition extends StatefulWidget {
  var coinValue;

  CoinsAddition({Key key, @required this.coinValue}) : super(key: key);

  @override
  _CoinsAdditionState createState() => _CoinsAdditionState();
}

class _CoinsAdditionState extends State<CoinsAddition>
    with SingleTickerProviderStateMixin<CoinsAddition> {
  AnimationController controller;

  // Build skeleton of the animation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CoinAdditionAnimation(
              controller: controller,
              coinValue: widget.coinValue,
            ),
            SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () async {
                await UserCoinDetailsProvider.instance.addUserCoinDetails(
                  widget.coinValue,
                );
                _claimCoins();
              },
              child: Text(
                'OK',
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF53905F),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _claimCoins() {
    Alert(
      context: context,
      title: 'Successfully Redeemed',
      desc: 'You will see this in your Redeemed Vouchers',
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
          },
          color: Color.fromRGBO(83, 144, 95, 1.0),
        ),
      ],
    ).show();
  }

  // Reverse animation back to start and jump to elevation
  Future<void> reverseAndElevateDown() async {
    await controller.animateBack(0.0);
    await controller.forward(from: 0.5);
  }

  // Initialize controller and addListener to it
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 6), vsync: this)
          ..addListener(() {
            if (controller.value >= 0.4 && controller.value < 0.5) {
              reverseAndElevateDown();
            }
          });
    controller.repeat(reverse: true);
  }

  // Dispose controller to prevent resources overuse
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
