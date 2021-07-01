import 'dart:convert';

ChangeOrderStatusModel changeOrderStatusModelFromJson(String str) => ChangeOrderStatusModel.fromJson(json.decode(str));

String changeOrderStatusModelToJson(ChangeOrderStatusModel data) => json.encode(data.toJson());

class ChangeOrderStatusModel {
  ChangeOrderStatusModel({
    this.data,
  });

  final ChangeOrderStatus data;

  factory ChangeOrderStatusModel.fromJson(Map<String, dynamic> json) => ChangeOrderStatusModel(
    data: json["data"] == null ? null : ChangeOrderStatus.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data.toJson(),
  };
}

class ChangeOrderStatus {
  ChangeOrderStatus({
    this.status,
    this.message,
  });

  final String status;
  final String message;

  factory ChangeOrderStatus.fromJson(Map<String, dynamic> json) => ChangeOrderStatus(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
