import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:ourprint/screens/voucher_pages/voucher_scan_qr_page.dart';

class VoucherMenuPage extends StatefulWidget {
  @override
  VoucherMenuPageState createState() {
    return VoucherMenuPageState();
  }
}

class VoucherMenuPageState extends State<VoucherMenuPage> {
  int _balanceCoin;

  @override
  void initState() {
    _balanceCoin = 100;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 80, left: 40, right: 40),
          child: Column(
            children: [
              Container(
                child: _getCoinBalance(),
              ),
              Container(
                margin: EdgeInsets.only(top: 80),
                child: ElevatedButton(
                  onPressed: () {},
                  style: _buttonStyle,
                  child: Text(
                    "Earn More Coins",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {},
                  style: _buttonStyle,
                  child: Text(
                    "Redeem Vouchers",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {},
                  style: _buttonStyle,
                  child: Text(
                    "Redeemed Vouchers",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.black,
          backgroundColor: Colors.green.withOpacity(0.6),
          child: Icon(Icons.qr_code_2_outlined),
          onPressed: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext buildContext) => VoucherScanQrPage(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getCoinBalance() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: new BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        border: Border.all(color: Colors.black38, width: 1.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(top: 20, bottom: 15),
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
                  size: 100.0,
                  color: Colors.yellowAccent[400],
                ),
              ),
            ),
          ),
          Text(
            "$_balanceCoin",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF53905F),
            ),
          ),
          Text(
            "Print Coins Balance",
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF53905F),
            ),
          ),
        ],
      ),
    );
  }
}

// Constants

ButtonStyle _buttonStyle = new ButtonStyle(
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade900),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      side: BorderSide(color: Colors.green.shade900),
    ),
  ),
);
