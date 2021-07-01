class RandomModel {
  int status;
  List<Random> data;

  RandomModel({this.status, this.data});

  RandomModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Random>();
      json['data'].forEach((v) {
        data.add(new Random.fromJson(v));
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

class Random {
  Header header;
  List<Product> product;

  Random({this.header, this.product});

  Random.fromJson(Map<String, dynamic> json) {
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['product'] != null) {
      product = new List<Product>();
      json['product'].forEach((v) {
        product.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Header {
  String sctId;
  String catId;
  String subcatId;
  String sctName;

  Header({this.sctId, this.catId, this.subcatId, this.sctName});

  Header.fromJson(Map<String, dynamic> json) {
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

class Product {
  String proId;
  String catId;
  String subcatId;
  String subcattypeId;
  String proName;
  String proImg;
  String proCompany;
  String proDesc;
  String proQty;
  String proPrice;
  String proTags;
  String selId;
  String uniqueId;
  String imgLink;

  Product(
      {this.proId,
        this.catId,
        this.subcatId,
        this.subcattypeId,
        this.proName,
        this.proImg,
        this.proCompany,
        this.proDesc,
        this.proQty,
        this.proPrice,
        this.proTags,
        this.selId,
        this.uniqueId,
        this.imgLink});

  Product.fromJson(Map<String, dynamic> json) {
    proId = json['pro_id'];
    catId = json['cat_id'];
    subcatId = json['subcat_id'];
    subcattypeId = json['subcattype_id'];
    proName = json['pro_name'];
    proImg = json['pro_img'];
    proCompany = json['pro_company'];
    proDesc = json['pro_desc'];
    proQty = json['pro_qty'];
    proPrice = json['pro_price'];
    proTags = json['pro_tags'];
    selId = json['sel_id'];
    uniqueId = json['unique_id'];
    imgLink = json['img_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pro_id'] = this.proId;
    data['cat_id'] = this.catId;
    data['subcat_id'] = this.subcatId;
    data['subcattype_id'] = this.subcattypeId;
    data['pro_name'] = this.proName;
    data['pro_img'] = this.proImg;
    data['pro_company'] = this.proCompany;
    data['pro_desc'] = this.proDesc;
    data['pro_qty'] = this.proQty;
    data['pro_price'] = this.proPrice;
    data['pro_tags'] = this.proTags;
    data['sel_id'] = this.selId;
    data['unique_id'] = this.uniqueId;
    data['img_link'] = this.imgLink;
    return data;
  }
}
