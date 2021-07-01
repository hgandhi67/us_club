
class CancelOrderModel {
  Root root;

  CancelOrderModel({this.root});

  CancelOrderModel.fromJson(Map<String, dynamic> json) {
    root = json['root'] != null ? new Root.fromJson(json['root']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.root != null) {
      data['root'] = this.root.toJson();
    }
    return data;
  }
}

class Root {
  CStatus status;
  CStatus waybill;
  CStatus orderId;
  CStatus error;

  Root({this.status, this.waybill, this.orderId, this.error});

  Root.fromJson(Map<String, dynamic> json) {
    status =
    json['status'] != null ? new CStatus.fromJson(json['status']) : null;
    waybill =
    json['waybill'] != null ? new CStatus.fromJson(json['waybill']) : null;
    orderId =
    json['order_id'] != null ? new CStatus.fromJson(json['order_id']) : null;
    error = json['error'] != null ? new CStatus.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    if (this.waybill != null) {
      data['waybill'] = this.waybill.toJson();
    }
    if (this.orderId != null) {
      data['order_id'] = this.orderId.toJson();
    }
    if (this.error != null) {
      data['error'] = this.error.toJson();
    }
    return data;
  }
}

class CStatus {
  String t;

  CStatus({this.t});

  CStatus.fromJson(Map<String, dynamic> json) {
    t = json['\$t'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['\$t'] = this.t;
    return data;
  }
}