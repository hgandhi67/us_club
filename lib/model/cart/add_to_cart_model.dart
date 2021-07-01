class AddToCartModel {
  dynamic data;

  AddToCartModel({this.data});

  AddToCartModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] is String) {
      data = json['data'] ?? '';
    } else if (json['data'] != null) {
      data = new List<AddToCartData>();
      json['data'].forEach((v) {
        data.add(new AddToCartData.fromJson(v));
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

class AddToCartData {
  int status;
  String data;

  AddToCartData({this.status});

  AddToCartData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    return data;
  }
}
