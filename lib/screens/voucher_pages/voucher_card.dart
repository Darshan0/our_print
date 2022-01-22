import 'package:flutter/material.dart';
import 'package:ourprint/model/voucher_model/voucher_model.dart';
import 'package:ourprint/repository/voucher_repo.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/voucher_pages/user_coin_details_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class VoucherCard extends StatelessWidget {
  const VoucherCard({
    this.voucherId,
    this.voucherImageUrl,
    this.voucherTitle,
    this.voucherCoin,
    this.vouchers,
  });

  final int voucherId;
  final String voucherImageUrl;
  final String voucherCoin;
  final String voucherTitle;
  final Vouchers vouchers;

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
          voucherImageUrl != null
              ? Container(
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
                )
              : Container(
                  width: 380,
                  height: 200,
                ),
          Positioned(
            top: 60,
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              height: 80,
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
                          voucherTitle,
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
                                ),
                                child: Material(
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      color: Colors.lightGreen,
                                      width: 2,
                                    ),
                                  ),
                                  elevation: 10,
                                  shadowColor: Color(0xFF53905F),
                                  color: Colors.green[700],
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
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
                                voucherCoin,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Alert(
                              context: context,
                              type: AlertType.warning,
                              title: "Confirmation",
                              desc:
                                  "Are You sure you want to Redeem this voucher?",
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  color: Colors.green[700],
                                ),
                                DialogButton(
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () async {
                                    final coinBalance =
                                        await UserCoinDetailsProvider.instance
                                            .getUserCoinDetails();
                                    if ((coinBalance -
                                            int.parse(voucherCoin)) <=
                                        0) {
                                      Alert(
                                        context: context,
                                        title: 'Low coin balance',
                                        desc:
                                            'Sorry you dont have enough coins to redeem this voucher.',
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              "Ok",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            color: Color.fromRGBO(
                                              83,
                                              144,
                                              95,
                                              1.0,
                                            ),
                                          ),
                                        ],
                                      ).show();
                                      ;
                                    } else {
                                      final Map response =
                                          await VoucherRepo.purchaseVoucher(
                                        voucherId,
                                      );
                                      if (response != null) {
                                        Navigator.pop(context);
                                        if (response.containsKey("success")) {
                                          Alert(
                                            context: context,
                                            title: 'Succesfully Redeemed',
                                            desc:
                                                'You will see this in your Redeemed Vouchers',
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                color: Color.fromRGBO(
                                                  83,
                                                  144,
                                                  95,
                                                  1.0,
                                                ),
                                              ),
                                            ],
                                          ).show();
                                        } else {
                                          Alert(
                                            context: context,
                                            title: 'Failed to Redeemed',
                                            desc: 'Voucher already redeemed.',
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                color: Color.fromRGBO(
                                                  83,
                                                  144,
                                                  95,
                                                  1.0,
                                                ),
                                              ),
                                            ],
                                          ).show();
                                        }
                                      }
                                    }
                                  },
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(
                                        83,
                                        144,
                                        95,
                                        1.0,
                                      ),
                                      Colors.lightGreen
                                    ],
                                  ),
                                )
                              ],
                            ).show();
                          },
                          child: Text(
                            "Redeem Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
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
