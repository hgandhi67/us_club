import 'package:us_club/model/models.dart';

class ExploreModel {
  int status;
  List<Product> data;

  ExploreModel({this.status, this.data});

  ExploreModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Product>();
      json['data'].forEach((v) {
        data.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}