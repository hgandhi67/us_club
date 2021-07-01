import 'dart:convert';

ProfilePicUpdateModel profilePicUpdateModelFromJson(String str) => ProfilePicUpdateModel.fromJson(json.decode(str));

String profilePicUpdateModelToJson(ProfilePicUpdateModel data) => json.encode(data.toJson());

class ProfilePicUpdateModel {
  ProfilePicUpdateModel({this.data});

  final Data data;

  factory ProfilePicUpdateModel.fromJson(Map<String, dynamic> json) => ProfilePicUpdateModel(
        data: json['data'] is String
            ? json["data"]
            : json["data"] == null
                ? null
                : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({this.uImg});

  final String uImg;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        uImg: json["u_img"] == null ? null : json["u_img"],
      );

  Map<String, dynamic> toJson() => {
        "u_img": uImg == null ? null : uImg,
      };
}
