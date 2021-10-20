import 'package:flutter/material.dart';
import 'package:ourprint/resources/images.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String subtitle;

  const EmptyWidget({
    Key key,
    this.title = 'Soo much emptiness',
    this.description,
    this.image,
    this.subtitle = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Image.asset(Images.emptyList),
            ),
            SizedBox(height: 30),
            Text(
              title,
              style: textTheme.headline,
            ),
            SizedBox(height: 24),
            Text(
              subtitle,
              style: textTheme.caption,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
