// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromMap(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toMap());

class UserProfileModel {
  bool success;
  String token;
  String fullName;
  String firstName;
  String lastName;
  String mobile;
  int id;
  String gender;
  String email;
  String dob;
  String image;
  String course;
  String branch;
  bool isStudent;
  int year;
  int sem;
  DateTime createdAt;
  bool isEmailVerified;
  String occupation;
  String collegeName;

  UserProfileModel(
      {this.success,
      this.token,
      this.fullName,
      this.firstName,
      this.lastName,
      this.mobile,
      this.id,
      this.gender,
      this.email,
      this.dob,
      this.image,
      this.course,
      this.branch,
      this.isStudent,
      this.year,
      this.sem,
      this.createdAt,
      this.isEmailVerified,
      this.occupation,
      this.collegeName});

  factory UserProfileModel.fromMap(Map<String, dynamic> json) =>
      UserProfileModel(
        success: json["success"],
        token: json["token"],
        fullName: json["full_name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        mobile: json["mobile"],
        id: json["id"],
        gender: json["gender"],
        email: json["email"],
        dob: json["dob"].toString(),
        image: json["image"],
        course: json["course"],
        branch: json["branch"],
        isStudent: json["is_student"],
        year: json["year"],
        sem: json["sem"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        isEmailVerified: json["is_email_verified"],
        occupation: json["occupation"],
        collegeName: json["college_name"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "token": token,
        "full_name": fullName,
        "first_name": firstName,
        "last_name": lastName,
        "mobile": mobile,
        "id": id,
        "gender": gender,
        "email": email,
        "dob": dob.toString(),
        "image": image,
        "course": course,
        "branch": branch,
        "is_student": isStudent,
        "year": year,
        "sem": sem,
        "created_at": createdAt,
        "is_email_verified": isEmailVerified,
        "occupation": occupation,
        "college_name": collegeName
      };
}
