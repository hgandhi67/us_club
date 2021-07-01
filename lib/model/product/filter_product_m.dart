import 'package:us_club/model/models.dart';

class FilterProductM {
  List<Product> data;

  FilterProductM({this.data});

  FilterProductM.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Product>();
      json['data'].forEach((v) {
        data.add(new Product.fromJson(v));
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
