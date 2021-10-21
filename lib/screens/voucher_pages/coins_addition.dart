import 'package:flutter/material.dart';

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
    return CoinAdditionAnimation(
        controller: controller, coinValue: widget.coinValue);
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
