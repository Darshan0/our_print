library user_profile;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/model/user_profile_model.dart';
import 'package:ourprint/repository/user_repo.dart';
import 'package:ourprint/screens/home_page/home_page.dart';
import 'package:ourprint/screens/login_page/login.dart';
import 'package:ourprint/screens/user_profile/profile_drop_down.dart';
import 'package:ourprint/static_data/educational_background.dart';
import 'package:ourprint/widgets/container_shadow.dart';
import 'package:ourprint/widgets/dialog_boxes.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/image_picker.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:ourprint/widgets/profile_image_from_net.dart';
import 'package:toast/toast.dart';

part 'view_profile.dart';

part 'user_profile_page.dart';

class UserProfile extends StatefulWidget {
  static final List<String> occupations = [
    'NA',
    'Professional',
    'Household',
    'Self-employed',
    'Others'
  ];

  static final List<String> collegeYears = ['NA','1', '2', '3', '4', '5'];
  static final List<String> collegeSem = ['NA','1', '2'];

  static open(context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => UserProfile()));

  @override
  UserProfilePage createState() => UserProfilePage();
}
