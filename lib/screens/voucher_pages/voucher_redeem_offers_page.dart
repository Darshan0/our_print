import 'package:flutter/material.dart';
import 'package:ourprint/screens/voucher_pages/voucher_card.dart';

import 'coin.dart';

class VoucherRedeemOffers extends StatefulWidget {
  @override
  VoucherRedeemOffersState createState() {
    return VoucherRedeemOffersState();
  }
}

class VoucherRedeemOffersState extends State<VoucherRedeemOffers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Coin(100, 40)],
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(
            right: 20,
            left: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Top Offers",
                style: TextStyle(
                  fontSize: 30,
                  color: Color(0xFF53905F),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 600,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, position) {
                      return VoucherCard();
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
