import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/firebase/firebase_notification_listener.dart';
import 'package:ourprint/firebase/firebase_token_setup.dart';
import 'package:ourprint/repository/user_repo.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/home_page/home_page_body.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';

import 'drawer_menu.dart';

class HomePage extends StatefulWidget {
  static openReplacement(context) => Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => HomePage()), (route) => false);

  static openAndRemoveUntil(context) => Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => HomePage()), (route) => false);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future future;

  @override
  void initState() {
    super.initState();
    FirebaseNotificationListener.init();
    FirebaseTokenSetup.init();
    future = UserRepo.isFreemiumAvailable();
    getUserDetails();
  }

  String userImage;
  String userName = '';

  getUserDetails() async {
    userImage = await Prefs.getUserImage();
    await Prefs.getFirstName().then((firstName) async {
      userName = '$firstName ' + await Prefs.getLastName();
    });
    setState(() {});
  }

  MenuState menuState;

  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
      menu: DrawerMenu(userImage: userImage, userName: userName),
      screenSelectedBuilder: (position, controller) {
        return Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              child: Image.asset(
                Images.homepageBg2,
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            FutureBuilder(
              future: future,
              builder: (context, snap) {
                if (snap.hasError)
                  return Scaffold(body: CustomErrorWidget(error: snap.error));
                if (!snap.hasData) return Scaffold(body: LoadingWidget());
                return HomePageBody(
                  controller: controller,
                  menuState: menuState,
                  userImage: userImage,
                  snap: snap,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
