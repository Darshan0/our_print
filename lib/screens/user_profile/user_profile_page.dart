part of 'user_profile.dart';

class UserProfilePage extends State<UserProfile> {
  static final Map genderMap = {'male': 'Male', 'female': 'Female'};
  Future<UserProfileModel> future;
  FormState formState;

  @override
  void initState() {
    super.initState();
    future = getDetails();
    focusNode.addListener(() {
      if (!focusNode.hasFocus)
        updatedDetails['college_name'] = collegeNameCtrl.text;
    });
//    updateProfile(context, {'year':null,'sem':null});
  }

  String course = '';
  String branch = '';
  bool isCollegeNameEditable = false;
  String year = '';
  String sem = '';
  String occupation = '';
  final collegeNameCtrl = TextEditingController();
  final focusNode = FocusNode();

  Future<UserProfileModel> getDetails() async {
    final userId = await Prefs.getUserId();
    UserProfileModel model = await UserRepo.getProfile(userId);
    isStudent = model.isStudent;
    collegeNameCtrl.text = model.collegeName ?? '';
    course = model.course ?? 'NA';
    branch = model.branch ?? 'NA';
    year = model.year?.toString() ?? 'NA';
    sem = model.sem?.toString() ?? 'NA';

    occupation = model.occupation ?? 'NA';
    return model;
  }

  bool isStudent = true;

  String getAge(String dob) {
    var ageInDays = DateTime.now()
        .difference(DateTime.tryParse(dob) ?? DateTime.now())
        .inDays;
    return (ageInDays / 365).toStringAsFixed(0);
  }

  Map updatedDetails = {};

  @override
  Widget build(BuildContext context) {
    final inputStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w900,
      fontSize: 18,
    );
    return FutureBuilder<UserProfileModel>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError)
            return Material(child: CustomErrorWidget(error: snap.error));
          if (!snap.hasData) return Material(child: LoadingWidget());
          return Scaffold(
            floatingActionButton: SizedBox(
              height: 60,
              width: 130,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await Future.delayed(Duration.zero);
                  if (updatedDetails.length == 0) return;

                  print(updatedDetails.values.toList()[0].runtimeType);
                  updateProfile(context, updatedDetails);
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Theme.of(context).accentColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 28,
                onPressed: () => HomePage.openAndRemoveUntil(context),
                color: Colors.white,
              ),
            ),
            body: Theme(
              data: Theme.of(context).copyWith(
                textTheme: Theme.of(context).textTheme.copyWith(
                      subhead: Theme.of(context).textTheme.caption,
                    ),
              ),
              child: ListView(
                children: <Widget>[
                  ViewProfile(profileModel: snap.data),
                  SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text('Are you a Student?'),
                    ),
                    subtitle: snap.data.isStudent != null
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, top: 20, bottom: 8),
                            child: Text(
                              snap.data.isStudent ? 'Yes' : 'No',
                              style: inputStyle,
                            ),
                          )
                        : Row(
                            children: <Widget>[
                              Radio(
                                value: true,
                                groupValue: isStudent,
                                onChanged: (value) async {
//                                  await updateProfile(
//                                      context, {'is_student': value});
                                  updatedDetails['is_student'] = value;
                                  isStudent = value;
                                  setState(() {});
                                },
                              ),
                              Text('Yes', style: inputStyle),
                              SizedBox(width: 12),
                              Radio(
                                value: false,
                                groupValue: isStudent,
                                onChanged: (value) async {
//                                  await updateProfile(
//                                      context, {'is_student': value});
                                  isStudent = value;
                                  setState(() {});
                                },
                              ),
                              Text(
                                'No',
                                style: inputStyle,
                              ),
                            ],
                          ),
                  ),
                  isStudent == false
                      ? ProfileDropDown(
                          value: occupation,
                          keY: 'occupation',
                          title: 'Occupation',
                          onChanged: (String val, context,
                              {bool textField}) async {
                            updatedDetails['occupation'] = val;
                            if (textField != true) occupation = val;
//                            await updateProfile(
//                                context, {'occupation': occupation});
                            setState(() {});
                          },
                          items: UserProfile.occupations,
                        )
                      : isStudent == true
                          ? Column(
                              children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text('Enter College Name'),
                                  ),
                                  subtitle: TextFormField(
                                    focusNode: focusNode,
                                    controller: collegeNameCtrl,
                                    readOnly: !isCollegeNameEditable,
                                    style: inputStyle,
                                    onFieldSubmitted: (val) {
                                      if (val.trim().length > 0)
//                          updateProfile(context, {'college_name': val});
                                        isCollegeNameEditable =
                                            !isCollegeNameEditable;
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'NA',
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 16.0, top: 12),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            isCollegeNameEditable == false
                                                ? BorderSide.none
                                                : BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(0.4),
                                                  ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.edit,
                                            color:
                                                Theme.of(context).accentColor,
                                            size: 20),
                                        onPressed: () {
                                          isCollegeNameEditable =
                                              !isCollegeNameEditable;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                ProfileDropDown(
                                  keY: 'course',
                                  value: course,
                                  title: 'Course of Study',
                                  onChanged: (String val, context,
                                      {bool textField}) async {
                                    updatedDetails['course'] = val;
                                    updatedDetails['branch'] = null;
                                    branch = 'NA';
                                    print(branch);
                                    if (textField != true) course = val;
//                                    await updateProfile(
//                                        context, {'course': val});
                                    setState(() {});
                                  },
                                  items:
                                      EducationalBackground.list.keys.toList(),
                                ),
                                EducationalBackground.list[course] == null ||
                                        course.toLowerCase() == 'others' ||
                                        EducationalBackground
                                            .list[course].isEmpty
                                    ? Container()
                                    : ProfileDropDown(
                                        keY: 'branch',
                                        value: branch,
                                        title: 'Branch',
                                        onChanged: (String val, context,
                                            {bool textField}) async {
                                          updatedDetails['branch'] = val;
                                          if (textField != true) branch = val;
                                          setState(() {});
                                        },
                                        items:
                                            EducationalBackground.list[course],
                                      ),

                                ProfileDropDown(
                                  keY: 'year',
                                  value: year,
                                  title: 'Year',
                                  onChanged: (String val, context,
                                      {bool textField}) async {
                                    updatedDetails['year'] = int.tryParse(val);
                                    if (textField != true) year = val;
                                    setState(() {});
                                  },
                                  items: UserProfile.collegeYears,
                                ),

                                ProfileDropDown(
                                  keY: 'sem',
                                  value: sem,
                                  title: 'Semester',
                                  onChanged: (String val, context,
                                      {bool textField}) async {
                                    updatedDetails['sem'] = int.tryParse(val);
                                    if (textField != true) sem = val;
                                    setState(() {});
                                  },
                                  items: UserProfile.collegeSem,
                                ),
//                    ProfileDropDown(
//                      value: UserProfile.years[year],
//                      title: 'Year',
//                      onChanged: ({String val, c, bool textField}) {
//                        year = UserProfile.years.keys.firstWhere(
//                            (value) => UserProfile.years[value] == year);
//                        updateProfile(context, {'year': year});
//                      },
//                      items: UserProfile.years.values.toList(),
//                    ),
                              ],
                            )
                          : Container(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, bottom: 24, top: 12),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: OutlineButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text(
                                    'Are you sure you want to logout?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(color: Colors.black),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () async {
                                          await Prefs.clearPrefs();
                                          LoginPage.openAndRemoveUntil(context);
                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(color: Colors.green),
                                        )),
                                    FlatButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'No',
                                          style: TextStyle(color: Colors.green),
                                        )),
                                  ],
                                )),
                        child: Text(
                          'LOGOUT',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  updateProfile(context, Map body) async {
    try {
      LoadingWidget.showLoadingDialog(context);
      await UserRepo.editProfile(body);
      Navigator.pop(context);
    } catch (e) {
      print(e);
      Navigator.pop(context);
      DialogBox.parseAndShowErrorDialog(context, e);
    }
  }
}
