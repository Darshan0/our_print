import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/login_page/login.dart';
import 'package:ourprint/widgets/container_shadow.dart';

class StartupPage extends StatefulWidget {
  static open(context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => StartupPage()));

  @override
  _StartupPageState createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  int index = 0;
  final controller = SwiperController();
  final List titles = ['Print anything', 'Easy Payments', 'Get it Delivered'];
  final List subtitles = [
    'Select your documents and upload the file',
    'Review your order and pay',
    'Doorstep delivery within 2-3 business days'
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accentColor = Theme.of(context).accentColor;
    return Scaffold(
      backgroundColor: Color(0xFFEDF4EF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFEDF4EF),
        leading: Container(),
        actions: <Widget>[
          Theme(
            data: ThemeData(),
            child: FlatButton(
              onPressed: () async {
                await controller.move(2);
                return LoginPage.open(context);
              },
              child: Text(
                'SKIP',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.3),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Swiper(
        controller: controller,
        itemCount: titles.length,
        loop: false,
        onIndexChanged: (index) {
          this.index = index;
          setState(() {});
        },
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Expanded(
                  flex: 4,
                  child: Image.asset(
                    Images.startup[index],
                    width: 280,
                  )),
              Expanded(
                flex: 3,
                child: ContainerShadow(
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                titles[index],
                                style: textTheme.headline.copyWith(
                                  color: accentColor,
                                ),
                              ),
                              SizedBox(height: 24),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0,
                                ),
                                child: Text(
                                  subtitles[index],
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Navigation(
                            index: index,
                            controller: controller,
                            length: titles.length,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class Navigation extends StatelessWidget {
  final int index;
  final controller;
  final int length;

  const Navigation({Key key, this.index, this.controller, this.length})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).accentColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Row(
            children: List.generate(
              length,
              (int j) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: index == j ? accent : accent.withOpacity(0.5),
                ),
                margin: EdgeInsets.only(left: 4),
                height: 16,
                width: 4,
              ),
            ),
          ),
        ),
        Theme(
          data: ThemeData(fontFamily: 'Avenir'),
          child: FlatButton(
            onPressed: () {
              index == length - 1 ? LoginPage.open(context) : controller.next();
            },
            child: Text(
              index == length - 1 ? 'GET STARTED' : 'NEXT',
              style: TextStyle(color: accent, fontWeight: FontWeight.w800),
            ),
          ),
        )
      ],
    );
  }
}
