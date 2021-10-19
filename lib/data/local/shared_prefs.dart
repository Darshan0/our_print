import 'package:ourprint/model/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const String token = "token";
  static const String userId = "userId";
  static const String userName = "userName";
  static const String fullName = "fullName";
  static const String firstName = "first_name";
  static const String lastName = "last_name";
  static const String mobileNumber = 'mobileNumber';
  static const String addressDetails = 'addressDetails';
  static const String userImage = 'userImage';
  static const String gender = 'gender';
  static const email = 'email';
  static const dob = 'dob';
  static const createdAt = 'created_at';

  static Future<bool> clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future<Null> setLoginData(UserProfileModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(token, 'Token ${model.token}');
    await prefs.setString(fullName, model.fullName);
    await prefs.setString(firstName, model.firstName);
    await prefs.setString(lastName, model.lastName);
    await prefs.setString(mobileNumber, model.mobile);
    await prefs.setString(userImage, model.image);
    await prefs.setInt(userId, model.id);
    await prefs.setString(gender, model.gender);
    await prefs.setString(email, model.email);
    await prefs.setString(dob, model.dob);
    await prefs.setString(createdAt, model.createdAt.toLocal().toString());

    return;
  }

  static Future getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userId);
  }

  static Future getUserCreatedAt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(createdAt);
  }

  static Future getUserMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(mobileNumber);
  }

  static Future setUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(fullName, name);
  }

  static Future setUserImage(String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImage, image);
  }

  static Future getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(email);
  }

  static getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(firstName) + prefs.getString(lastName);
  }

  static Future getFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(firstName);
  }

  static Future getLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastName);
  }

  static Future getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImage);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(token);
  }

  static Future setToken(String tok) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(token, tok);
  }

  static Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
