class ProductDetailsM {
  List<PData> data;

  ProductDetailsM({this.data});

  ProductDetailsM.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PData>[];
      json['data'].forEach((v) {
        data.add(new PData.fromJson(v));
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

class PData {
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
  String catName;
  String catImg;
  String subcatName;
  String sctId;
  String sctName;
  String vid;
  String vPath;
  String seller;
  String imgLink;
  List<Media> media;

  PData(
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
      this.catName,
      this.catImg,
      this.subcatName,
      this.sctId,
      this.sctName,
      this.vid,
      this.vPath,
      this.seller,
      this.imgLink,
      this.media});

  PData.fromJson(Map<String, dynamic> json) {
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
    catName = json['cat_name'];
    catImg = json['cat_img'];
    subcatName = json['subcat_name'];
    sctId = json['sct_id'];
    sctName = json['sct_name'];
    vid = json['vid'];
    vPath = json['v_path'];
    seller = json['seller'];
    imgLink = json['img_link']??json['url'];
    if (json['media'] != null) {
      media = new List<Media>();
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
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
    data['cat_name'] = this.catName;
    data['cat_img'] = this.catImg;
    data['subcat_name'] = this.subcatName;
    data['sct_id'] = this.sctId;
    data['sct_name'] = this.sctName;
    data['vid'] = this.vid;
    data['v_path'] = this.vPath;
    data['seller'] = this.seller;
    data['img_link'] = this.imgLink;
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Media {
  String url;
  String ptId;
  String type;

  Media({this.url, this.ptId, this.type});

  Media.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    ptId = json['pt_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['pt_id'] = this.ptId;
    data['type'] = this.type;
    return data;
  }
}
