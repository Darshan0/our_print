import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/contact_us/contact_us.dart';
import 'package:ourprint/screens/freemium_page/freemium_coming_soon.dart';
import 'package:ourprint/screens/orders_page/all_orders.dart';
import 'package:ourprint/screens/subscription_page/my_subscription.dart';
import 'package:ourprint/screens/user_profile/user_profile.dart';
import 'package:ourprint/my_html_viewer.dart';
import 'package:ourprint/widgets/profile_image_from_net.dart';
import 'package:share/share.dart';

class DrawerMenu extends StatelessWidget {
  final String userName;
  final String userImage;

  const DrawerMenu({Key key, this.userName, this.userImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 32,
          onPressed: () {
            SimpleHiddenDrawerProvider.of(context).setSelectedMenuPosition(0);
          },
        ),
      ),
      body: FractionallySizedBox(
        widthFactor: 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () => UserProfile.open(context),
              child: userImage == null
                  ? CircleAvatar(
                      backgroundImage: AssetImage(Images.noProfile),
                      radius: 32,
                    )
                  : ProfileImageFromNet(
                      radius: 80, borderRadius: 25, imageUrl: userImage),
            ),
            SizedBox(height: 16),
            Text(
              '$userName',
              style: textTheme.title
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    CardButton(
                      text: 'Orders',
                      image: Images.orderMenuIcon,
                      onTap: () => AllOrders.open(context),
                    ),
                    CardButton(
                      text: 'Subscription',
                      image: Images.subscription,
                      onTap: () {
                        MySubscription.open(context);
                        // return AboutSubscription.open(context);
                      },
                    ),
                    CardButton(
                      text: 'Share',
                      image: Images.shareMenuIcon,
                      onTap: () {
                        Share.share('OURPRINT\n'
                            'Print anything, Easy Payments, Get it Delivered\n'
                            'Google play store: https://play.google.com'
                            '/store/apps/details?id=com.ourprint.app&hl=en\n '
                            'IOS app store: https://apps.apple.com/in/'
                            'app/ourprint/id1518757713');
                      },
                    ),
                    CardButton(
                      text: 'Privacy',
                      image: Images.privacyMenuIcon,
                      onTap: () {
                        HtmlViewer.open(
                            context,
                            'http://www.ourprint.in/privacy.html',
                            'Privacy Policy');
                      },
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    CardButton(
                      text: 'Freemium',
                      image: Images.freemiumMenuIcon,
                      onTap: () => FreemiumComingSoon.open(context),
                    ),
                    CardButton(
                      text: 'Partners',
                      image: Images.partnersIcon,
                    ),
                    CardButton(
                      text: 'Terms',
                      image: Images.termsMenuIcon,
                      onTap: () {
                        HtmlViewer.open(
                            context,
                            'http://www.ourprint.in/terms.html',
                            'Terms and Conditions');
                      },
                    ),
                    CardButton(
                      text: 'Contact',
                      image: Images.contact,
                      onTap: () => ContactUs.open(context),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final String image;

  const CardButton({
    Key key,
    @required this.text,
    this.onTap,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Image.asset(
                image,
                height: 20,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: textTheme.subhead.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12)
        ],
      ),
    );
  }
}
