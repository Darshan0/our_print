import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:ourprint/resources/images.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  static open(context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactUs()),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            'Contact Us',
            style: textTheme.title.copyWith(color: Color(0xFF173A50)),
          ),
          SizedBox(height: 40),
          Image.asset(Images.appLogo, height: 130),
          SizedBox(height: 32),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('WhatsApp'),
                SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    FlutterOpenWhatsapp.sendSingleMessage(
                      "+919100533391",
                      "",
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('+919100533391'),
                      SizedBox(width: 4),
                      Image.asset(
                        Images.whatsapp,
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text('Email'),
                SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    final Uri _emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'ask@ourprint.in',
                        queryParameters: {
                        }
                    );

                    launch(_emailLaunchUri.toString());
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ask@ourprint.in'),
                      SizedBox(width: 4),
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 12,
                        child: Icon(
                          Icons.email,
                          color: Colors.white,
                          size: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
