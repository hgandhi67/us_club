class FilterM {
  dynamic data;

  FilterM({this.data});

  FilterM.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? json['data'] is! String
            ? new FilterData.fromJson(json['data'])
            : null
        : json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null && this.data is! String) {
      data['data'] = this.data.toJson();
    } else {
      data['data'] = this.data;
    }
    return data;
  }
}

class FilterData {
  List<String> size;
  List<String> color;
  List<String> price;

  FilterData({this.size, this.color, this.price});

  FilterData.fromJson(Map<String, dynamic> json) {
    size = json['Size']?.cast<String>();
    color = json['color']?.cast<String>();
    price = json['Price']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Size'] = this.size;
    data['color'] = this.color;
    data['Price'] = this.price;
    return data;
  }
}
