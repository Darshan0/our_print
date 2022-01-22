import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RedeemedVoucherCard extends StatelessWidget {
  const RedeemedVoucherCard(
      {this.voucherImageUrl, this.voucherTitle, this.voucherCoin});

  final String voucherImageUrl;
  final String voucherCoin;
  final String voucherTitle;

  @override
  Widget build(BuildContext context) {
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
          voucherImageUrl != null ? 
          Container(
            width: 380,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  voucherImageUrl,
                ),
                fit: BoxFit.fill,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
          ) : Container(
            width: 380,
            height: 200,
          ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          voucherTitle,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Redeemed",
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
