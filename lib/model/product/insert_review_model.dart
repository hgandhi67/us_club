class InsertReviewModel {
  List<DataStatus> data;

  InsertReviewModel({this.data});

  InsertReviewModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] is String) {
      data = json['data'] ?? '';
    } else if (json['data'] != null) {
      data = new List<DataStatus>();
      json['data'].forEach((v) {
        data.add(new DataStatus.fromJson(v));
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

class DataStatus {
  String message;

  DataStatus({this.message});

  DataStatus.fromJson(Map<String, dynamic> json) {
    message = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.message;
    return data;
  }
}
