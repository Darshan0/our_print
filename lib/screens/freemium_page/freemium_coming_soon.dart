import 'package:flutter/material.dart';
import 'package:ourprint/resources/images.dart';

class FreemiumComingSoon extends StatelessWidget {
  static open(context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FreemiumComingSoon()),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              Images.freemiumComingSoon,
              width: 155,
            ),
            SizedBox(height: 24),
            Text(
              'Freemium feature is coming soon!',
              style: textTheme.title.copyWith(color: Color(0xFF173A50)),
            ),
            SizedBox(height: 12),
            Text(
              'Stay tuned for more updates and offers',
              style: textTheme.caption.copyWith(
                fontWeight: FontWeight.w100,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
