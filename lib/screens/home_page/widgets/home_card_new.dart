import 'package:flutter/material.dart';
import 'package:ourprint/configuration_items.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  final Widget button;
  final List<String> expansionTexts;
  final List<String> images;

  HomeCard({
    Key key,
    @required this.title,
    @required this.subTitle,
    this.image,
    this.button,
    this.expansionTexts,
    this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var accentColor = Theme.of(context).accentColor;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.green.withOpacity(0.4)),
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(
          title,
          style: textTheme.bodyText1.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: expansionTexts != null || images != null
            ? Icon(Icons.info_outline_rounded, color: accentColor)
            : null,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          if (expansionTexts != null) ...[
            for (var item in expansionTexts)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('•', style: textTheme.caption),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '$item',
                        style: textTheme.caption,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 8),
          ],
          if (images != null) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var item in images)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        ConfigurationItems.configurations[item],
                        height: 32,
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 48,
                        child: Text(
                          item,
                          style: textTheme.caption.copyWith(fontSize: 10),
                        ),
                      )
                    ],
                  ),
              ],
            ),
            SizedBox(height: 16),
          ],
          if (button != null) button,
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
