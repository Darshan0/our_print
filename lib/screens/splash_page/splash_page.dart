import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_version/get_version.dart';
import 'package:launch_review/launch_review.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/home_page/home_page.dart';
import 'package:ourprint/screens/startup_pages/startup_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  checkForUpdate() async {
    var stream =
        FirebaseDatabase.instance.reference().child('version_code').onValue;
    stream.listen((version) async {
      int serverVersion = version.snapshot.value;
      String appVersion = await GetVersion.projectCode;
      print(appVersion);
      print(serverVersion);
      if (int.tryParse(appVersion) < serverVersion) {
        _showUpdateDialog();
      } else {
        Prefs.getToken().then((token) {
          print(token);
          return token == null
              ? StartupPage.open(context)
              : HomePage.openReplacement(context);
        });
      }
    });
  }

  _showUpdateDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {},
            child: AlertDialog(
              title: Text('Update is available!'),
              content: Text('Kindly update the application.'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      LaunchReview.launch(
                          androidAppId: "com.ourprint.app",
                          iOSAppId: "com.ourprint.app");
                    },
                    child: Text('Update', style: TextStyle(color: Theme.of(context).accentColor),))
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    checkForUpdate();
//    Future.delayed(Duration(seconds: 2), () {
//      Prefs.getToken().then((token) {
//        print(token);
//        return token == null ? StartupPage.open(context) : HomePage.openReplacement(
//          context);
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    final texTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: FractionallySizedBox(
                heightFactor: 0.2,
                alignment: Alignment.center,
                child: Center(child: Image.asset(Images.appLogo))),
          )
        ],
      ),
    );
  }
}
