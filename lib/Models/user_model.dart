// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String? userid;
    String? username;
    String? mobileno;
    String? name;
    DateTime? dateofbirth;
    DateTime? registrationdate;
    dynamic profilepicture;
    String? isActive;
    String? city;
    String? address;
    String? emailid;

    UserModel({
        this.userid,
        this.username,
        this.mobileno,
        this.name,
        this.dateofbirth,
        this.registrationdate,
        this.profilepicture,
        this.isActive,
        this.city,
        this.address,
        this.emailid,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userid: json["userid"],
        username: json["username"],
        mobileno: json["mobileno"],
        name: json["name"],
        dateofbirth: json["dateofbirth"] == null ? null : DateTime.parse(json["dateofbirth"]),
        registrationdate: json["registrationdate"] == null ? null : DateTime.parse(json["registrationdate"]),
        profilepicture: json["profilepicture"],
        isActive: json["IsActive"],
        city: json["city"],
        address: json["address"],
        emailid: json["emailid"],
    );

    Map<String, dynamic> toJson() => {
        "userid": userid,
        "username": username,
        "mobileno": mobileno,
        "name": name,
        "dateofbirth": "${dateofbirth!.year.toString().padLeft(4, '0')}-${dateofbirth!.month.toString().padLeft(2, '0')}-${dateofbirth!.day.toString().padLeft(2, '0')}",
        "registrationdate": registrationdate?.toIso8601String(),
        "profilepicture": profilepicture,
        "IsActive": isActive,
        "city": city,
        "address": address,
        "emailid": emailid,
    };
}
