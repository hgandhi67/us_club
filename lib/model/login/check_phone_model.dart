import 'dart:convert';

CheckPhoneModel checkPhoneModelFromJson(String str) => CheckPhoneModel.fromJson(json.decode(str));

String checkPhoneModelToJson(CheckPhoneModel data) => json.encode(data.toJson());

class CheckPhoneModel {
  CheckPhoneModel({
    this.status,
    this.message,
    this.description,
  });

  final bool status;
  final String message;
  final String description;

  factory CheckPhoneModel.fromJson(Map<String, dynamic> json) => CheckPhoneModel(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "description": description == null ? null : description,
  };
}
