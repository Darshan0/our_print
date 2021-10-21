import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class CoinAdditionAnimation extends StatelessWidget {
  var coinValue;

  // Constructor along with animation Tweens initialization
  CoinAdditionAnimation({Key key, this.controller, this.coinValue})
      :
        // Reconstruction Tweens
        flip = Tween(begin: 0.0, end: 2 * pi).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.4, curve: Curves.bounceIn),
          ),
        ),
        size = Tween(begin: 80.0, end: 120.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.4, curve: Curves.bounceIn),
          ),
        ),
        elevation = Tween(begin: 15.0, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 0.7, curve: Curves.ease),
          ),
        ),
        mouth = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.8, 1.0),
          ),
        ),

        // Color Tweens
        endTopColor =
            ColorTween(begin: Colors.yellow[600], end: Colors.yellow).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.7, 1.0),
          ),
        ),
        endBottomColor =
            ColorTween(begin: Colors.yellow[700], end: Colors.yellow).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.7, 1.0),
          ),
        ),
        startTopColor =
            ColorTween(begin: Colors.yellow[600], end: Colors.yellow[900])
                .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.5, curve: Curves.bounceIn),
          ),
        ),
        startBottomColor =
            ColorTween(begin: Colors.yellow[700], end: Colors.yellow).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.5),
          ),
        ),
        super(key: key);

  // Initialize variables
  // Reconstruction
  final Animation<double> flip;
  final Animation<double> size;
  final Animation<double> mouth;
  final Animation<double> elevation;

  // Color
  final Animation<Color> startTopColor;
  final Animation<Color> startBottomColor;
  final Animation<Color> endTopColor;
  final Animation<Color> endBottomColor;

  final AnimationController controller;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 170,
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.rotationY(flip.value),
                  child: Material(
                    shape: CircleBorder(),
                    elevation: elevation.value,
                    shadowColor: Colors.yellowAccent[400],
                    color: Colors.amber[800],
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return ui.Gradient.linear(
                          Offset(4.0, 24.0),
                          Offset(24.0, 4.0),
                          [
                            (controller.value < 0.5)
                                ? startBottomColor.value
                                : endBottomColor.value,
                            (controller.value < 0.5)
                                ? startTopColor.value
                                : endTopColor.value,
                          ],
                        );
                      },
                      child: Icon(
                        Icons.monetization_on,
                        size: controller.value < 0.5 ? size.value : 80.0,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                '$coinValue \n Print coins',
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black38),
              )
            ],
          ),
        )
      ],
    );
  }

  // Just holds Animation Builder and calls _buildAnimation
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }
}

// ignore: must_be_immutable
