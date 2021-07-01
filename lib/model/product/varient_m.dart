class VariantM {
  int status;
  List<Variant> data;

  VariantM({this.status, this.data});

  VariantM.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Variant>();
      json['data'].forEach((v) {
        data.add(new Variant.fromJson(v));
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

class Variant {
  String ptId;
  String proId;
  String ptName;
  String ptDesc;
  String ptPrice;
  String ptQty;
  String colorCode;
  bool isSelected = false;

  Variant({
    this.ptId,
    this.proId,
    this.ptName,
    this.ptDesc,
    this.ptPrice,
    this.ptQty,
    this.colorCode,
    this.isSelected = false,
  });

  Variant.fromJson(Map<String, dynamic> json) {
    ptId = json['pt_id'];
    proId = json['pro_id'];
    ptName = json['pt_name'];
    ptDesc = json['pt_desc'];
    ptPrice = json['pt_price'];
    ptQty = json['pt_qty'];
    colorCode = json['color_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pt_id'] = this.ptId;
    data['pro_id'] = this.proId;
    data['pt_name'] = this.ptName;
    data['pt_desc'] = this.ptDesc;
    data['pt_price'] = this.ptPrice;
    data['pt_qty'] = this.ptQty;
    data['color_code'] = this.colorCode;
    return data;
  }
}
