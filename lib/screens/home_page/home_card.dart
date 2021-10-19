import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ourprint/configuration_items.dart';

class HomeCard extends StatefulWidget {
  final String title;
  final String subTitle;
  final String image;
  final Function onLaunch;
  final List<String> expansionTexts;
  final List<String> images;

  HomeCard({
    Key key,
    @required this.title,
    @required this.subTitle,
    this.image,
    this.onLaunch,
    this.expansionTexts,
    this.images,
  }) : super(key: key);

  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  // 20 pages
  bool autoExpand = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    if (widget.title == 'Freemium') {
      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.green.withOpacity(0.4)),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          onTap: () {
            widget.onLaunch();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 24),
                    Text(
                      widget.title,
                      style: textTheme.title.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.green.withOpacity(0.4)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ExpansionTile(
        children: widget.expansionTexts == null
            ? []
            : <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        children: List.generate(widget.expansionTexts.length,
                            (int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '* ',
                                  style: textTheme.caption.copyWith(
                                    fontWeight: FontWeight.w100,
                                    // color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    widget.expansionTexts[index],
                                    style: textTheme.caption.copyWith(
                                      fontWeight: FontWeight.w100,
                                      // color: Colors.white.withOpacity(0.7)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      )),
                ),
                SizedBox(height: 12),
                widget.images.isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.5,
                          children: List.generate(
                            widget.images.length,
                            (int index) => Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset(
                                    ConfigurationItems
                                        .configurations[widget.images[index]],
                                    height: 32,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    widget.images[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      // color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                if (widget.title != 'Freemium')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      height: 44,
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: OutlineButton(
                          textColor: theme.accentColor,
                          padding: EdgeInsets.zero,
                          onPressed: widget.onLaunch,
                          highlightedBorderColor: theme.accentColor,
                          borderSide: BorderSide(color: theme.accentColor),
                          child: Text('Upload files'),
                        ),
                      ),
                    ),
                  )
              ],
        trailing: Icon(
          Icons.info_outline,
          color: theme.accentColor,
          size: 20,
        ),
        title: InkWell(
          onTap: widget.title == 'Freemium'
              ? () {
                  widget.onLaunch();
                }
              : null,
          child: Text(
            widget.title,
            style: textTheme.title.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
