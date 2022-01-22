import 'package:flutter/material.dart';
import 'package:ourprint/model/voucher_model/voucher_model.dart';
import 'package:ourprint/repository/voucher_repo.dart';
import 'package:ourprint/screens/voucher_pages/user_coin_details_provider.dart';
import 'package:ourprint/screens/voucher_pages/voucher_card.dart';

import 'coin.dart';

class RedeemVouchersPage extends StatefulWidget {
  @override
  RedeemVouchersPageState createState() {
    return RedeemVouchersPageState();
  }
}

class RedeemVouchersPageState extends State<RedeemVouchersPage> {
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
                    "Top Offers",
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
            padding: EdgeInsets.only(left:20,right: 20,bottom: 10),
            child: FutureBuilder(
              future: VoucherRepo.getAllVouchers(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<VoucherModel>> snapshot,
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

  Widget _getVoucherListView(List<VoucherModel> vouchers) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ListView.builder(
        itemCount: vouchers.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, position) {
          return VoucherCard(
            voucherId: vouchers.elementAt(position).id,
            voucherImageUrl: vouchers.elementAt(position).image,
            voucherCoin: vouchers.elementAt(position).cost.toString(),
            voucherTitle: vouchers.elementAt(position).voucherDetail.toString(),
            vouchers: vouchers.elementAt(position).vouchers.first,
          );
        },
      ),
    );
  }
}
