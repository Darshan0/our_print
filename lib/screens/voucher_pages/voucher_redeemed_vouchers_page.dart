import 'package:flutter/material.dart';
import 'package:ourprint/model/voucher_model/purchased_voucher_model.dart';
import 'package:ourprint/repository/voucher_repo.dart';
import 'package:ourprint/screens/voucher_pages/redeemed_voucher_card.dart';
import 'package:ourprint/screens/voucher_pages/user_coin_details_provider.dart';

import 'coin.dart';

class RedeemedVouchersPage extends StatefulWidget {
  @override
  RedeemedVouchersPageState createState() {
    return RedeemedVouchersPageState();
  }
}

class RedeemedVouchersPageState extends State<RedeemedVouchersPage> {
  int _balanceCoin;

  @override
  void initState() {
    super.initState();
    _getUserCoinBalance();
  }

  void _getUserCoinBalance() async {
    final coinBalance =
        await UserCoinDetailsProvider.instance.getUserCoinDetails();
    setState(
      () {
        _balanceCoin = coinBalance;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Color(0xFF53905F),
                          size: 40,
                        ),
                      ),
                      Coin(_balanceCoin, 36),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Redeemed Vouchers",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Avenir',
                      color: Color(0xFF53905F),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: FutureBuilder(
              future: VoucherRepo.getPurchasedVouchers(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<PurchasedVoucherModel>> snapshot,
              ) {
                if (snapshot.hasData) {
                  return _getVoucherListView(snapshot.data);
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _getVoucherListView(List<PurchasedVoucherModel> vouchers) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ListView.builder(
        itemCount: vouchers.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, position) {
          return RedeemedVoucherCard(
            voucherImageUrl:"https://ourprint.s3.amazonaws.com/multimedia/voucher_sample_lQg414h.jpg",
            voucherCoin: vouchers.elementAt(position).cost.toString(),
            voucherTitle: vouchers.elementAt(position).voucherCode.toString(),
          );
        },
      ),
    );
  }
}
