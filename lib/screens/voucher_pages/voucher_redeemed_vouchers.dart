import 'package:flutter/material.dart';
import 'package:ourprint/screens/voucher_pages/redeemed_voucher_card.dart';

class RedeemedVouchers extends StatefulWidget {
  @override
  RedeemedVouchersState createState() {
    return RedeemedVouchersState();
  }
}

class RedeemedVouchersState extends State<RedeemedVouchers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(
            top: 80,
            right: 20,
            left: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Redeemed Vouchers",
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF53905F),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (context, position) {
                      return RedeemedVoucherCard();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
