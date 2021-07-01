class SubCategoriesM {
  List<CData> data;

  SubCategoriesM({this.data});

  SubCategoriesM.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CData>();
      json['data'].forEach((v) {
        data.add(new CData.fromJson(v));
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

class CData {
  String catId;
  String catName;
  List<SubCategory> subcat;
  List<SubCategory> subcatType;

  CData({this.catId, this.catName, this.subcat});

  CData.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'];
    catName = json['cat_name'];
    if (json['subcat'] != null) {
      subcat = new List<SubCategory>();
      json['subcat'].forEach((v) {
        subcat.add(new SubCategory.fromJson(v));
      });
    }

    if (json['subcattype'] != null) {
      subcatType = new List<SubCategory>();
      json['subcattype'].forEach((v) {
        subcatType.add(new SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_id'] = this.catId;
    data['cat_name'] = this.catName;
    if (this.subcat != null) {
      data['subcat'] = this.subcat.map((v) => v.toJson()).toList();
    }
    if (this.subcatType != null) {
      data['subcattype'] = this.subcatType.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  String subcatId;
  String subcatName;
  String sctId;
  String sctName;

  SubCategory({this.subcatId, this.subcatName, this.sctId, this.sctName});

  SubCategory.fromJson(Map<String, dynamic> json) {
    subcatId = json['subcat_id'];
    subcatName = json['subcat_name'];
    sctId = json['sct_id'];
    sctName = json['sct_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcat_id'] = this.subcatId;
    data['subcat_name'] = this.subcatName;
    data['sct_id'] = this.sctId;
    data['sct_name'] = this.sctName;
    return data;
  }
}
