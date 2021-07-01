import 'package:us_club/model/models.dart';

class SearchProductM {
  SearchData data;

  SearchProductM({this.data});

  SearchProductM.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new SearchData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class SearchData {
  List<Product> products;
  List<SubCategories> subCategories;
  List<SubCategoryTypes> subCategoryTypes;

  SearchData({this.products, this.subCategories, this.subCategoryTypes});

  SearchData.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = new List<Product>();
      json['products'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
    if (json['sub_categories'] != null) {
      subCategories = new List<SubCategories>();
      json['sub_categories'].forEach((v) {
        subCategories.add(new SubCategories.fromJson(v));
      });
    }
    if (json['sub_category_types'] != null) {
      subCategoryTypes = new List<SubCategoryTypes>();
      json['sub_category_types'].forEach((v) {
        subCategoryTypes.add(new SubCategoryTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    if (this.subCategories != null) {
      data['sub_categories'] = this.subCategories.map((v) => v.toJson()).toList();
    }
    if (this.subCategoryTypes != null) {
      data['sub_category_types'] = this.subCategoryTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  String subcatId;
  String catId;
  String subcatName;

  SubCategories({this.subcatId, this.catId, this.subcatName});

  SubCategories.fromJson(Map<String, dynamic> json) {
    subcatId = json['subcat_id'];
    catId = json['cat_id'];
    subcatName = json['subcat_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcat_id'] = this.subcatId;
    data['cat_id'] = this.catId;
    data['subcat_name'] = this.subcatName;
    return data;
  }
}

class SubCategoryTypes {
  String sctId;
  String catId;
  String subcatId;
  String sctName;

  SubCategoryTypes({this.sctId, this.catId, this.subcatId, this.sctName});

  SubCategoryTypes.fromJson(Map<String, dynamic> json) {
    sctId = json['sct_id'];
    catId = json['cat_id'];
    subcatId = json['subcat_id'];
    sctName = json['sct_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sct_id'] = this.sctId;
    data['cat_id'] = this.catId;
    data['subcat_id'] = this.subcatId;
    data['sct_name'] = this.sctName;
    return data;
  }
}
