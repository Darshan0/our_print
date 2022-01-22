import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:ourprint/resources/images.dart';

class CoinAdditionAnimation extends StatefulWidget {
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
            ColorTween(begin: Color(0xFF53905F), end: Colors.lightGreen)
                .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.7, 1.0),
          ),
        ),
        endBottomColor =
            ColorTween(begin: Color(0xFF53905F), end: Colors.lightGreen)
                .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.7, 1.0),
          ),
        ),
        startTopColor = ColorTween(
          begin: Color(0xFF53905F),
          end: Colors.lightGreen,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.5, curve: Curves.bounceIn),
          ),
        ),
        startBottomColor = ColorTween(
          begin: Color(0xFF53905F),
          end: Colors.lightGreen,
        ).animate(
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

  @override
  _CoinAdditionAnimationState createState() => _CoinAdditionAnimationState();
}

class _CoinAdditionAnimationState extends State<CoinAdditionAnimation> {
  Widget _buildAnimation(BuildContext context, Widget child) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 130,
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.rotationY(widget.flip.value),
                  child: Material(
                    shape: CircleBorder(
                      side: BorderSide(
                        color: Colors.lightGreen,
                        width: 6
                      ),
                    ),
                    elevation: widget.elevation.value,
                    shadowColor: Color(0xFF53905F),
                    color: Color(0xFF53905F),
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return ui.Gradient.linear(
                          Offset(4.0, 24.0),
                          Offset(24.0, 4.0),
                          [
                            (widget.controller.value < 0.5)
                                ? widget.startBottomColor.value
                                : widget.endBottomColor.value,
                            (widget.controller.value < 0.5)
                                ? widget.startTopColor.value
                                : widget.endTopColor.value,
                          ],
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          Images.rupee,
                          color: Colors.lightGreen,
                          height: widget.controller.value < 0.5
                              ? widget.size.value
                              : 100.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${widget.coinValue} \n Print coins',
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF53905F),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Will be added into your wallet.',
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF53905F),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: _buildAnimation,
    );
  }
}

// ignore: must_be_immutable
