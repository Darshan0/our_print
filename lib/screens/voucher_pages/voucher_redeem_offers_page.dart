import 'package:flutter/material.dart';

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
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (context, position) {
                      return _getOfferItem();
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

  Widget _getOfferItem() {
    return Container(
      width: double.infinity,
      height: 150,
      margin: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          FlutterLogo(),
          Positioned(
            top: 70,
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              height: 90,
              decoration: new BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "20% off on clothes",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Center(
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black38, width: 2.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Color(0xFF53905F),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "200",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Redeem Now",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
