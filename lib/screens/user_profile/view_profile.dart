part of 'user_profile.dart';

class ViewProfile extends StatefulWidget {
  final UserProfileModel profileModel;

  const ViewProfile({Key key, this.profileModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ViewProfileState();
}

class ViewProfileState extends State<ViewProfile> {
  static final Map genderMap = {'male': 'Male', 'female': 'Female'};

  @override
  void initState() {
    super.initState();
  }

  getAge(String dob) {
    final birthDate = DateTime.parse(dob);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final inputStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w900,
      fontSize: 18,
    );

    final disabledStyle = Theme.of(context).textTheme.caption.copyWith(
          color: Colors.white.withOpacity(0.5),
        );
    final textTheme = Theme.of(context).textTheme;
    return Container(
      color: Theme.of(context).accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 8),
            child: Text(
              'Profile',
              style: textTheme.title.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Stack(
                  children: <Widget>[
                    ContainerShadow(
                      blurRadius: 10,
                      yAxis: 8,
                      child: Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: ProfileImageFromNet(
                            radius: 100,
                            borderRadius: 30,
                            imageUrl: widget.profileModel.image
//                                    'https://imgix.ranker.com/collection_img/1/1863/original/animated-c'
//                                        'haracters-and-cartoons-u6?w=751&h=271&fm=pjpg&fit=crop&q=50',
                            ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: ImagePickerContainer(
                        onPick: (context, imageFile) async {
                          if (imageFile == null) return;
                          LoadingWidget.showLoadingDialog(context);
                          try {
                            UserProfileModel model = await UserRepo.editProfile(
                              FormData.fromMap({
                                'image':
                                    await MultipartFile.fromFile(imageFile.path)
                              }),
                            );
                            Prefs.setUserImage(model.image);
                            HomePage.openAndRemoveUntil(context);
                          } catch (e) {
                            print(e);
                            Navigator.pop(context);
                            DialogBox.parseAndShowErrorDialog(context, e);
                          }
                        },
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(Icons.edit,
                              color: Theme.of(context).accentColor, size: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: FutureBuilder(
                    future: UserRepo.getTotalPrints(),
                    builder: (_, snap) {
                      if (snap.hasError)
                        return CustomErrorWidget(error: snap.error);
                      if (!snap.hasData)
                        return Text(
                          'Loading...',
                          style: textTheme.caption.copyWith(
                            color: Colors.white54,
                          ),
                        );
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white54, width: 0.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 40,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${snap.data['total']}',
                                style: textTheme.headline4.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Pages printed',
                                style: textTheme.caption.copyWith(
                                  color: Colors.white54,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              '${widget.profileModel.firstName} ${widget.profileModel.lastName}',
              style: textTheme.title.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text(
              'Mobile Number',
              style: disabledStyle,
            ),
            subtitle: TextFormField(
              initialValue: '${widget.profileModel.mobile}',
              enabled: false,
              style: inputStyle.copyWith(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Mail-ID',
              style: disabledStyle,
            ),
            subtitle: TextFormField(
              initialValue: '${widget.profileModel.email}',
              readOnly: true,
              style: inputStyle.copyWith(color: Colors.white),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                suffix: widget.profileModel.isEmailVerified == true
                    ? Container(height: 1, width: 1)
                    : Builder(
                        builder: (context) => InkWell(
                          onTap: () async {
                            LoadingWidget.showLoadingDialog(context);
                            try {
                              Toast.show(
                                  'Sending email for verification', context);
                              final response =
                                  await UserRepo.sendEmailForVerification();
                              Toast.show(response['msg'], context);
                              HomePage.openAndRemoveUntil(context);
                            } catch (e) {
                              print(e);
                              Navigator.pop(context);
                              DialogBox.parseAndShowErrorDialog(context, e);
                            }
                          },
                          child: Text('VERIFY'),
                        ),
                      ),
                suffixStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Age',
              style: disabledStyle,
            ),
            subtitle: TextFormField(
              initialValue: '${getAge(widget.profileModel.dob)} y/o, '
                  '${DateFormat('dd MMM, yyyy').format(DateTime.parse(widget.profileModel.dob))}',
              enabled: false,
              style: inputStyle.copyWith(color: Colors.white),
              decoration: InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Gender',
              style: disabledStyle,
            ),
            subtitle: TextFormField(
              initialValue:
                  '${UserProfilePage.genderMap[widget.profileModel.gender] ?? widget.profileModel.gender}',
              enabled: false,
              style: inputStyle.copyWith(color: Colors.white),
              decoration: InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
