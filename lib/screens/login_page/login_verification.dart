import 'package:flutter/material.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/model/user_profile_model.dart';
import 'package:ourprint/repository/user_repo.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/home_page/home_page.dart';
import 'package:ourprint/screens/registeration/registration.dart';
import 'package:ourprint/widgets/container_shadow.dart';
import 'package:ourprint/widgets/dialog_boxes.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:toast/toast.dart';

class LoginVerification extends StatefulWidget {
  final String mobile;

  const LoginVerification({Key key, this.mobile}) : super(key: key);

  static open(context, String mobile) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginVerification(mobile: mobile)),
      );

  @override
  _LoginVerificationState createState() => _LoginVerificationState();
}

class _LoginVerificationState extends State<LoginVerification> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future otp;

  @override
  void initState() {
    super.initState();
    listenToOTP();
    otp = UserRepo.requestOTP(widget.mobile);
  }

  listenToOTP() async {
    await SmsAutoFill().listenForCode;
    SmsAutoFill().code.listen((event) {
      print('event is ');
      print(event);
      _login();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              Images.verificationBg,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        iconSize: 28,
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(height: 12),
                      InkWell(
                        onTap: () async {
                          if (otp == null) return;
                          otp.then(
                            (val) => Toast.show(val['otp'].toString(), context),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            'OTP Verification',
                            style: textTheme.title.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Enter 5 digit code',
                          style: textTheme.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: PinFieldAutoFill(
                          codeLength: 5,
                          controller: controller,
                          decoration: UnderlineDecoration(
                              colorBuilder: FixedColorBuilder(Colors.grey),
                              textStyle: textTheme.caption.copyWith(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              lineHeight: 0.5,
                              hintText: 'XXXXX',
                              hintTextStyle: textTheme.caption.copyWith(
                                fontSize: 16,
                              )),
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: RaisedButton(
                          onPressed: () async {
                            _login();
                          },
                          child: Text('CONTINUE'),
                        ),
                      ),
                      SizedBox(height: 32),
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Didn\'t receive OTP? ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () {
                                otp = UserRepo.requestOTP(widget.mobile);
                                Toast.show('OTP has been resent', context);
                              },
                              child: Text(
                                'RESEND',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: Theme.of(context).accentColor),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _login() async {
    await Future.delayed(Duration(milliseconds: 500));
    if (controller.text.length != 5) return;
    LoadingWidget.showLoadingDialog(context);
    String code = controller.text;
    try {
      UserProfileModel response =
          await UserRepo.verifyOTP({'mobile': widget.mobile, 'code': code});
      Navigator.pop(context);
      if (response.success == false)
        return Registration.open(
          context,
          widget.mobile,
          code,
        );
      await Prefs.setLoginData(response);
      HomePage.openReplacement(context);
    } catch (e) {
      print(e);
      Navigator.pop(context);
      DialogBox.parseAndShowErrorDialog(context, e);
    }
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }
}
