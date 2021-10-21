import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Coin extends StatelessWidget {
  final int coinValue;
  final double iconSize;

  Coin(this.coinValue, this.iconSize);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              shape: CircleBorder(),
              elevation: 10,
              shadowColor: Colors.yellowAccent[400],
              color: Colors.amber[800],
              child: Icon(
                Icons.monetization_on,
                size: iconSize,
                color: Colors.yellowAccent[400],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
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
