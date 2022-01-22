import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourprint/resources/images.dart';

class Coin extends StatelessWidget {
  final int coinValue;
  final double iconSize;

  Coin(this.coinValue, this.iconSize);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: Container(
            width: iconSize,
            height: iconSize,
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Material(
              shape: CircleBorder(
                side: BorderSide(
                  color: Colors.lightGreen,
                  width: 4,
                ),
              ),
              elevation: 10,
              shadowColor: Color(0xFF53905F),
              color: Colors.green[700],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  Images.rupee,
                  color: Colors.lightGreen,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Center(
          child: Text(
            "$coinValue",
            style: TextStyle(
              color: Color(0xFF53905F),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        )
      ],
    );
  }
}
