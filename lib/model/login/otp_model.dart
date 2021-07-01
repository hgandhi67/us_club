class OtpModel {
  String status;
  String details;

  OtpModel({this.status, this.details});

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        status: json["Status"] == null ? null : json["Status"],
        details: json["Details"] == null ? null : json["Details"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status == null ? null : status,
        "Details": details == null ? null : details,
      };
}
