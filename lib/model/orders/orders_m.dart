class OrdersM {
  List<Order> data;

  OrdersM({this.data});

  OrdersM.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Order>();
      json['data'].forEach((v) {
        data.add(new Order.fromJson(v));
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

class Order {
  String orderId;
  String uId;
  String transactionId;
  String waybill;
  String orderTotal;
  String paymentType;
  String orderAddress;
  String datetime;
  String orderStatus;
  String delivery;
  List<LineItems> lineItems;

  Order({
    this.orderId,
    this.uId,
    this.transactionId,
    this.waybill,
    this.orderTotal,
    this.paymentType,
    this.orderAddress,
    this.datetime,
    this.orderStatus,
    this.delivery,
    this.lineItems,
  });

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    uId = json['u_id'];
    transactionId = json['transaction_id'];
    waybill = json['waybill'];
    orderTotal = json['order_total'];
    paymentType = json['payment_type'];
    orderAddress = json['order_address'];
    datetime = json['datetime'];
    orderStatus = json['order_status'];
    delivery = json['delivery'];
    if (json['line_items'] != null) {
      lineItems = new List<LineItems>();
      json['line_items'].forEach((v) {
        lineItems.add(new LineItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['u_id'] = this.uId;
    data['transaction_id'] = this.transactionId;
    data['waybill'] = this.waybill;
    data['order_total'] = this.orderTotal;
    data['payment_type'] = this.paymentType;
    data['order_address'] = this.orderAddress;
    data['datetime'] = this.datetime;
    data['order_status'] = this.orderStatus;
    data['delivery'] = this.delivery;
    if (this.lineItems != null) {
      data['line_items'] = this.lineItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LineItems {
  String odId;
  String orderId;
  String proId;
  String qty;
  String odDesc;
  String price;
  String selId;
  String status;
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
  String uniqueId;
  String imgLink;

  LineItems(
      {this.odId,
      this.orderId,
      this.proId,
      this.qty,
      this.odDesc,
      this.price,
      this.selId,
      this.status,
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
      this.uniqueId,
      this.imgLink});

  LineItems.fromJson(Map<String, dynamic> json) {
    odId = json['od_id'];
    orderId = json['order_id'];
    proId = json['pro_id'];
    qty = json['qty'];
    odDesc = json['od_desc'];
    price = json['price'];
    selId = json['sel_id'];
    status = json['status'];
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
    uniqueId = json['unique_id'];
    imgLink = json['img_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['od_id'] = this.odId;
    data['order_id'] = this.orderId;
    data['pro_id'] = this.proId;
    data['qty'] = this.qty;
    data['od_desc'] = this.odDesc;
    data['price'] = this.price;
    data['sel_id'] = this.selId;
    data['status'] = this.status;
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
    data['unique_id'] = this.uniqueId;
    data['img_link'] = this.imgLink;
    return data;
  }
}
