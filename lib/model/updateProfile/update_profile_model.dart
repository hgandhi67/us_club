class UpdateProfileModel {
  dynamic data;

  UpdateProfileModel({this.data});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] is String) {
      data = json['data'] ?? '';
    } else if (json['data'] != null) {
      data = new List<UpdateProfileData>();
      json['data'].forEach((v) {
        data.add(new UpdateProfileData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpdateProfileData {
  String status;

  UpdateProfileData({this.status});

  UpdateProfileData.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}
