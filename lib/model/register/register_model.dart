class RegisterModel {
  bool status;
  String message;
  dynamic data;

  RegisterModel({this.data, this.status, this.message});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null ? json['status'] : false;
    message = json['message'] != null ? json['message'] : '';
    if (json['data'] is String) {
      data = json['data'] ?? '';
    } else if (json['data'] != null) {
      // data = new List<RegisterData>();
      data = [(new RegisterData.fromJson(json['data']))];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['status'] = this.status;
      data['message'] = this.message;
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RegisterData {
  int status;
  String data;
  String error;
  String userEmail;
  String description;
  String userId;

  RegisterData({this.status, this.data, this.description, this.error, this.userEmail, this.userId});

  RegisterData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['u_id'];
    data = json['data'];
    userEmail = json['u_email'];
    error = json['Error'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    data['u_email'] = this.userEmail;
    data['Error'] = error;
    data['Description'] = this.description;
    data['u_id'] = this.userId;
    return data;
  }
}
