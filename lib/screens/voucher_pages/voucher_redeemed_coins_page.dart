import 'package:flutter/material.dart';
import 'package:ourprint/screens/voucher_pages/coins_addition.dart';

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
              top: 120,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 350,
                    height: 350,
                    child: CoinsAddition(
                      coinValue: 100,
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
