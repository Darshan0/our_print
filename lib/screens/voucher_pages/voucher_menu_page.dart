import 'package:flutter/material.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/voucher_pages/user_coin_details_provider.dart';
import 'package:ourprint/screens/voucher_pages/voucher_redeem_vouchers_page.dart';
import 'package:ourprint/screens/voucher_pages/voucher_redeemed_vouchers_page.dart';
import 'dart:ui' as ui;
import 'package:ourprint/screens/voucher_pages/voucher_scan_qr_page.dart';

class VoucherMenuPage extends StatefulWidget {
  static open(context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => VoucherMenuPage()));
  @override
  VoucherMenuPageState createState() {
    return VoucherMenuPageState();
  }
}

class VoucherMenuPageState extends State<VoucherMenuPage> {
  int _balanceCoin;

  @override
  void initState() {
    super.initState();
    _getUserCoinBalance();
  }

  void _getUserCoinBalance() async {
    final coinBalance =
        await UserCoinDetailsProvider.instance.getUserCoinDetails();
    setState(() {
      _balanceCoin = coinBalance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 40, right: 40),
          child: Column(
            children: [
              Container(
                child: _getCoinBalance(),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 80),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (BuildContext buildContext) =>
                            VoucherScanQrPage(),
                      ),
                    );
                  },
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
                width: double.infinity,
                padding: EdgeInsets.only(top: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (BuildContext buildContext) =>
                            RedeemVouchersPage(),
                      ),
                    );
                  },
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
                width: double.infinity,
                padding: EdgeInsets.only(top: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (BuildContext buildContext) =>
                            RedeemedVouchersPage(),
                      ),
                    );
                  },
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
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Color(0xFF53905F),
        child: Icon(
          Icons.qr_code_2_outlined,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (BuildContext buildContext) => VoucherScanQrPage(),
            ),
          );
        },
      ),
    );
  }

  Widget _getCoinBalance() {
    return Card(
      elevation: 10,
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: new BoxDecoration(
          color: Colors.green.withOpacity(0.2),
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
                    border: Border.all(
                      color: Colors.lightGreen,
                    )),
                child: Material(
                  shape: CircleBorder(
                    side: BorderSide(
                      color: Colors.lightGreen,
                      width: 6,
                    ),
                  ),
                  elevation: 10,
                  shadowColor: Color(0xFF53905F),
                  color: Colors.green[700],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      Images.rupee,
                      color: Colors.lightGreen,
                    ),
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
      ),
    );
  }
}

// Constants

ButtonStyle _buttonStyle = new ButtonStyle(
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF53905F)),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      side: BorderSide(color: Color(0xFF53905F)),
    ),
  ),
);
