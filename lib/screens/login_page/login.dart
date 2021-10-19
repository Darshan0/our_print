import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/login_page/login_verification.dart';
import 'package:ourprint/widgets/container_shadow.dart';

class LoginPage extends StatelessWidget {
  static open(context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );

  static openAndRemoveUntil(context) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );

  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Form(
        key: formKey,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                Images.loginBg,
                fit: BoxFit.fill,
              ),
            ),
            ListView(
              children: <Widget>[
                ContainerShadow(
                  yAxis: 40,
                  blurRadius: 40,
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(Images.appLogo, height: 70),
                          SizedBox(height: 12),
                          Text(
                            'Welcome to Our Print',
                            style: textTheme.title.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 32),
                          Text(
                            'Enter your Mobile Number to Proceed',
                            style: textTheme.caption,
                          ),
                          TextFormField(
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w900),
                            controller: controller,
                            validator: (value) => value.trim().length == 10
                                ? null
                                : 'Please enter a 10 digit phone number',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              hintText: 'Tap to edit',
                              prefixText: '+91',
                              prefixStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(height: 32),
                          RaisedButton(
                            onPressed: () {
                              if (!formKey.currentState.validate()) return;
                              return LoginVerification.open(
                                  context, controller.text);
                            },
                            child: Text('CONTINUE'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
