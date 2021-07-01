class CreateOrderM {
  OrderData data;

  CreateOrderM({this.data});

  CreateOrderM.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new OrderData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class OrderData {
  String status;
  String waybill;
  String transactionId;
  var amount;
  List<CartsData> cartData;

  OrderData({this.status, this.waybill, this.transactionId, this.amount, this.cartData});

  OrderData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    waybill = json['waybill'];
    transactionId = json['transaction_id'];
    amount = json['amount'];
    if (json['cart_data'] != null) {
      cartData = new List<CartsData>();
      json['cart_data'].forEach((v) {
        cartData.add(new CartsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['waybill'] = this.waybill;
    data['transaction_id'] = this.transactionId;
    data['amount'] = this.amount;
    if (this.cartData != null) {
      data['cart_data'] = this.cartData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartsData {
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

  CartsData(
      {this.cartId,
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
      this.imgLink});

  CartsData.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    uId = json['u_id'];
    proId = json['pro_id'];
    qty = json['qty'];
    price = json['price'];
    ptId = json['pt_id'];
    pincode = json['pincode'];
    cartDesc = json['cart_desc'];
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
    data['cart_id'] = this.cartId;
    data['u_id'] = this.uId;
    data['pro_id'] = this.proId;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['pt_id'] = this.ptId;
    data['pincode'] = this.pincode;
    data['cart_desc'] = this.cartDesc;
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
