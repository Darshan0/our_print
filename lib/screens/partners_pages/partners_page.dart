import 'package:flutter/material.dart';

class PartnersPage extends StatefulWidget {
  static open(context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => PartnersPage()));

  @override
  _PartnersPageState createState() {
    return _PartnersPageState();
  }
}

class _PartnersPageState extends State<PartnersPage> {
  final List<String> _logisticsPartnerList = [
    'assets/images/logistics_partners/logistics_partners_1.png',
    'assets/images/logistics_partners/logistics_partners_2.png',
    'assets/images/logistics_partners/logistics_partners_3.png',
    'assets/images/logistics_partners/logistics_partners_4.png',
    'assets/images/logistics_partners/logistics_partners_5.png',
    'assets/images/logistics_partners/logistics_partners_6.png',
    'assets/images/logistics_partners/logistics_partners_7.png',
  ];

  final List<String> _officailPartnerList = [
    'assets/images/official_partners/official_partners_1.png',
    'assets/images/official_partners/official_partners_2.png',
    'assets/images/official_partners/official_partners_3.png',
    'assets/images/official_partners/official_partners_4.png',
    'assets/images/official_partners/official_partners_5.png',
    'assets/images/official_partners/official_partners_6.png',
    'assets/images/official_partners/official_partners_7.png',
    'assets/images/official_partners/official_partners_8.png',
    'assets/images/official_partners/official_partners_9.png',
    'assets/images/official_partners/official_partners_10.png',
  ];

  final List<String> _paymentPartnerList = [
    'assets/images/official_partners/payment_partners_1.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Container(
            height: double.maxFinite,
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Official Partners",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Avenir',
                      color: Color(0xFF53905F),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _getOfficialPartnerListView(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Logistics Partners",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Avenir',
                      color: Color(0xFF53905F),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _getLogisticsPartnerListView(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Payment Partner",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Avenir',
                      color: Color(0xFF53905F),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _getPaymentPartnerListView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getOfficialPartnerListView() {
    return GridView.builder(
      itemCount: _officailPartnerList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.asset(
            _officailPartnerList.elementAt(index),
            fit: BoxFit.fill,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        );
      },
    );
  }

  Widget _getLogisticsPartnerListView() {
    return GridView.builder(
      itemCount: _logisticsPartnerList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.asset(
            _logisticsPartnerList.elementAt(index),
            fit: BoxFit.fill,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        );
      },
    );
  }

  Widget _getPaymentPartnerListView() {
    return GridView.builder(
      itemCount: _paymentPartnerList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.asset(
            _paymentPartnerList.elementAt(index),
            fit: BoxFit.fill,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        );
      },
    );
  }
}
