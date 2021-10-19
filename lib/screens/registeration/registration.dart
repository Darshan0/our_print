import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/model/user_profile_model.dart';
import 'package:ourprint/repository/user_repo.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/home_page/home_page.dart';
import 'package:ourprint/my_html_viewer.dart';
import 'package:ourprint/widgets/container_shadow.dart';
import 'package:ourprint/widgets/dialog_boxes.dart';
import 'package:ourprint/widgets/error_snackbar.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:toast/toast.dart';

class Registration extends StatefulWidget {
  final String mobile;
  final String code;

  const Registration({Key key, this.mobile, this.code}) : super(key: key);

  static open(context, String mobile, String code) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Registration(
                mobile: mobile,
                code: code,
              )));

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String gender = 'male';

  final formKey = GlobalKey<FormState>();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailController = TextEditingController();
  DateTime dob;
  bool isAccepted = false;

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
                Images.registrationBg,
                fit: BoxFit.fill,
              ),
            ),
            ListView(
              children: <Widget>[
                ContainerShadow(
                  yAxis: 40,
                  blurRadius: 40,
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back),
                            iconSize: 28,
                            onPressed: () => Navigator.pop(context)),
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            'User Registration',
                            style: textTheme.title
                                .copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                        SizedBox(height: 16),
                        ListTile(
                          title: Text(
                            'Enter your First Name',
                            style: textTheme.caption,
                          ),
                          subtitle: TextFormField(
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w900),
                            controller: firstNameCtrl,
                            textCapitalization: TextCapitalization.words,
                            validator: (name) => name.trim().isEmpty
                                ? 'Please enter your first name'
                                : null,
                            decoration:
                                InputDecoration(hintText: 'Tap to edit'),
                          ),
                        ),
                        SizedBox(height: 12),
                        ListTile(
                          title: Text(
                            'Enter your Last Name',
                            style: textTheme.caption,
                          ),
                          subtitle: TextFormField(
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w900),
                            controller: lastNameCtrl,
                            textCapitalization: TextCapitalization.words,
                            validator: (name) => name.trim().isEmpty
                                ? 'Please enter your last name'
                                : null,
                            decoration:
                                InputDecoration(hintText: 'Tap to edit'),
                          ),
                        ),
                        SizedBox(height: 12),
                        ListTile(
                          title: Text(
                            'Enter your Mail ID',
                            style: textTheme.caption,
                          ),
                          subtitle: TextFormField(
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w900),
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (RegexValidation.hasMatch(
                                  val, RegexPattern.email)) return null;
                              return 'Please enter a valid email-address';
                            },
                            decoration:
                                InputDecoration(hintText: 'Tap to edit'),
                          ),
                        ),
                        SizedBox(height: 12),
                        ListTile(
                          title: Text(
                            'Select your Date of Birth',
                            style: textTheme.caption,
                          ),
                          subtitle: Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                  primary: Theme.of(context).accentColor),
                            ),
                            child: DateTimeField(
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w900),
                                validator: (date) => date == null
                                    ? 'Please select a date'
                                    : null,
                                decoration: InputDecoration(
                                  hintText: 'Tap to edit',
                                  suffixIcon:
                                      Icon(Icons.calendar_today, size: 20),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.3)),
                                  ),
                                ),
                                format: DateFormat("dd-MM-yyyy"),
                                //8985658786
                                onShowPicker: (context, date) async {
                                  var date = await showDatePicker(
                                      context: context,
                                      initialDate: dob ?? DateTime(2000),
                                      firstDate: DateTime(1500),
                                      lastDate:
                                          DateTime(DateTime.now().year + 1));
                                  if (date != null) {
                                    dob = date;
                                  }
                                  return dob;
                                }),
                          ),
                        ),
                        SizedBox(height: 12),
                        ListTile(
                          title: Text(
                            'Gender',
                            style: textTheme.caption,
                          ),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: 'male',
                                groupValue: gender,
                                onChanged: (value) {
                                  gender = 'male';
                                  setState(() {});
                                },
                              ),
                              Image.asset(Images.maleIcon, height: 20),
                              SizedBox(width: 8),
                              Text('Male', style: textTheme.body2),
                              SizedBox(width: 24),
                              Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: 'female',
                                groupValue: gender,
                                onChanged: (value) {
                                  gender = 'female';
                                  setState(() {});
                                },
                              ),
                              Image.asset(Images.femaleIcon, height: 20),
                              SizedBox(width: 8),
                              Text(
                                'Female',
                                style: textTheme.body2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              value: isAccepted,
                              onChanged: (value) {
                                isAccepted = value;
                                setState(() {});
                              },
                            ),
                            RichText(
                              text: TextSpan(
                                style: textTheme.caption
                                    .copyWith(color: Colors.black),
                                children: [
                                  TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms and Conditions ',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        print('here');
                                        HtmlViewer.open(
                                          context,
                                          'http://www.ourprint.in/terms.html',
                                          'Terms and Conditions',
                                        );
                                      },
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: 'set by\n'),
                                  TextSpan(text: 'Our Print')
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: RaisedButton(
                              onPressed: () async {
                                if (!formKey.currentState.validate()) return;
                                if (!isAccepted)
                                  return Toast.show(
                                      'Please accept the terms and conditions',
                                      context);
                                var body = {
                                  'first_name': firstNameCtrl.text,
                                  'last_name': lastNameCtrl.text,
                                  'gender': gender,
                                  'mobile': widget.mobile,
                                  'code': widget.code,
                                  'dob': dob.toString(),
                                  'email': emailController.text
                                };
                                print(body);
                                LoadingWidget.showLoadingDialog(context);
                                try {
                                  UserProfileModel response =
                                      await UserRepo.register(body);
                                  if (response.success == true) {
                                    await Prefs.setLoginData(response);
                                    return HomePage.openAndRemoveUntil(context);
                                  }
                                  Navigator.pop(context);
                                } catch (e) {
                                  print(e);
                                  Navigator.pop(context);
                                  DialogBox.parseAndShowErrorDialog(context, e);
                                }
                              },
                              child: Text('DONE')),
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
      ),
    );
  }
}
