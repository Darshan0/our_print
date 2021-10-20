import 'package:flutter/material.dart';
import 'package:ourprint/model/order_model.dart';

class FreemiumDiscount extends StatelessWidget {
  final myConfigsList;
  final OrderModel model;
  final Function(double discount) onCalculated;
  final double printingCharges;

  const FreemiumDiscount(
      {Key key,
      this.myConfigsList,
      this.model,
      this.onCalculated,
      this.printingCharges})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text('Freemium Discount',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      trailing: Builder(
        builder: (context) {
          var bwPrice = myConfigsList
              .firstWhere((data) => data.id == model.configurations[0])
              .price;
          var discount =
              model.pdfPageCount <= 100 ? printingCharges : (100 * bwPrice);
          if (onCalculated != null) onCalculated(discount);
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('- ', style: TextStyle(fontSize: 28, color: Colors.green)),
              Text(
                '₹ $discount',
                style: TextStyle(color: Colors.green),
              ),
            ],
          );
        },
      ),
    );
  }
}
