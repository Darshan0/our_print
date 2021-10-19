import 'package:flutter/material.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/home_page/home_page.dart';

class BookingConfirmed extends StatelessWidget {
  static open(context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => BookingConfirmed()));

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        HomePage.openAndRemoveUntil(context);
        return false;
      },
      child: Material(
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 28,
                onPressed: () =>HomePage.openAndRemoveUntil(context),
              ),
            ),
            Center(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                      height: 280, child: Image.asset(Images.bookingConfirmed)),
                  SizedBox(height: 32),
                  Center(
                    child: Text('Booking Confirmed',
                        style: textTheme.title.copyWith(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Text(
                      'You can review your booking details in'
                      '\n My Bookings page from menu',
                      style: textTheme.caption
                          .copyWith(fontSize: 13, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
