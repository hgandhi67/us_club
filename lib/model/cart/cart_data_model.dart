class CartDataModel {
  int status;
  List<CartData> data;

  CartDataModel({this.status, this.data});

  CartDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CartData>[];
      json['data'].forEach((v) {
        data.add(new CartData.fromJson(v));
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

class CartData {
  String cartId;
  String uId;
  String proId;
  String qty;
  String price;
  String ptId;
  String pincode;
  String cartDesc;
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

  CartData({
    this.cartId,
    this.uId,
    this.proId,
    this.qty,
    this.price,
    this.ptId,
    this.pincode,
    this.cartDesc,
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
    this.imgLink,
  });

  CartData.fromJson(Map<String, dynamic> json) {
    cartId = json["cart_id"] == null ? null : json["cart_id"];
    uId = json["u_id"] == null ? null : json["u_id"];
    proId = json["pro_id"] == null ? null : json["pro_id"];
    qty = json["qty"] == null ? null : json["qty"];
    price = json["price"] == null ? null : json["price"];
    ptId = json["pt_id"] == null ? null : json["pt_id"];
    pincode = json["pincode"] == null ? null : json["pincode"];
    cartDesc = json["cart_desc"] == null ? null : json["cart_desc"];
    catId = json["cat_id"] == null ? null : json["cat_id"];
    subcatId = json["subcat_id"] == null ? null : json["subcat_id"];
    subcattypeId = json["subcattype_id"] == null ? null : json["subcattype_id"];
    proName = json["pro_name"] == null ? null : json["pro_name"];
    proImg = json["pro_img"] == null ? null : json["pro_img"];
    proCompany = json["pro_company"] == null ? null : json["pro_company"];
    proDesc = json["pro_desc"] == null ? null : json["pro_desc"];
    proQty = json["pro_qty"] == null ? null : json["pro_qty"];
    proPrice = json["pro_price"] == null ? null : json["pro_price"];
    proTags = json["pro_tags"] == null ? null : json["pro_tags"];
    selId = json["sel_id"] == null ? null : json["sel_id"];
    uniqueId = json["unique_id"] == null ? null : json["unique_id"];
    imgLink = json["img_link"] == null ? null : json["img_link"];
  }

  Map<String, dynamic> toJson() => {
        "cart_id": cartId == null ? null : cartId,
        "u_id": uId == null ? null : uId,
        "pro_id": proId == null ? null : proId,
        "qty": qty == null ? null : qty,
        "price": price == null ? null : price,
        "pt_id": ptId == null ? null : ptId,
        "pincode": pincode == null ? null : pincode,
        "cart_desc": cartDesc == null ? null : cartDesc,
        "cat_id": catId == null ? null : catId,
        "subcat_id": subcatId == null ? null : subcatId,
        "subcattype_id": subcattypeId == null ? null : subcattypeId,
        "pro_name": proName == null ? null : proName,
        "pro_img": proImg == null ? null : proImg,
        "pro_company": proCompany == null ? null : proCompany,
        "pro_desc": proDesc == null ? null : proDesc,
        "pro_qty": proQty == null ? null : proQty,
        "pro_price": proPrice == null ? null : proPrice,
        "pro_tags": proTags == null ? null : proTags,
        "sel_id": selId == null ? null : selId,
        "unique_id": uniqueId == null ? null : uniqueId,
        "img_link": imgLink == null ? null : imgLink,
      };
}
