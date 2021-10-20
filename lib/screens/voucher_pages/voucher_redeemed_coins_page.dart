import 'package:flutter/material.dart';

class VoucherRedeemedCoinsPage extends StatefulWidget {
  @override
  VoucherRedeemedCoinsPageState createState() {
    return VoucherRedeemedCoinsPageState();
  }
}

class VoucherRedeemedCoinsPageState extends State<VoucherRedeemedCoinsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.only(
              top: 150,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black38, width: 2.0),
                    ),
                    child: Center(
                      child: Text(
                        "100",
                        style: TextStyle(
                          fontSize: 40,
                          color: Color(0xFF53905F),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 40,
                  ),
                  child: Text(
                    _redeemCoinMessage,
                    style: TextStyle(
                      fontSize: 40,
                      color: Color(0xFF53905F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Constants

final String _redeemCoinMessage = "Will soon be added \ninto your wallet";
