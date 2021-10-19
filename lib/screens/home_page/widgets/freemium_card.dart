import 'package:flutter/material.dart';
import 'package:ourprint/screens/freemium_page/freemium_coming_soon.dart';

class FreemiumCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.green.withOpacity(0.4)),
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        onTap: () {
          FreemiumComingSoon.open(context);
        },
        title: Text(
          'Freemium',
          style: textTheme.bodyText1.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
