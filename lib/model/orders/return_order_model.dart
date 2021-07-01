import 'dart:convert';

ReturnOrderModel returnOrderModelFromJson(String str) => ReturnOrderModel.fromJson(json.decode(str));

String returnOrderModelToJson(ReturnOrderModel data) => json.encode(data.toJson());

class ReturnOrderModel {
  ReturnOrderModel({
    this.cashPickupsCount,
    this.packageCount,
    this.uploadWbn,
    this.replacementCount,
    this.rmk,
    this.pickupsCount,
    this.packages,
    this.cashPickups,
    this.codCount,
    this.success,
    this.prepaidCount,
    this.codAmount,
  });

  final double cashPickupsCount;
  final dynamic packageCount;
  final String uploadWbn;
  final dynamic replacementCount;
  final String rmk;
  final dynamic pickupsCount;
  final List<Package> packages;
  final dynamic cashPickups;
  final dynamic codCount;
  final bool success;
  final dynamic prepaidCount;
  final dynamic codAmount;

  factory ReturnOrderModel.fromJson(Map<String, dynamic> json) => ReturnOrderModel(
    cashPickupsCount: json["cash_pickups_count"] == null ? null : json["cash_pickups_count"],
    packageCount: json["package_count"] == null ? null : json["package_count"],
    uploadWbn: json["upload_wbn"] == null ? null : json["upload_wbn"],
    replacementCount: json["replacement_count"] == null ? null : json["replacement_count"],
    rmk: json["rmk"] == null ? null : json["rmk"],
    pickupsCount: json["pickups_count"] == null ? null : json["pickups_count"],
    packages: json["packages"] == null ? null : List<Package>.from(json["packages"].map((x) => Package.fromJson(x))),
    cashPickups: json["cash_pickups"] == null ? null : json["cash_pickups"],
    codCount: json["cod_count"] == null ? null : json["cod_count"],
    success: json["success"] == null ? null : json["success"],
    prepaidCount: json["prepaid_count"] == null ? null : json["prepaid_count"],
    codAmount: json["cod_amount"] == null ? null : json["cod_amount"],
  );

  Map<String, dynamic> toJson() => {
    "cash_pickups_count": cashPickupsCount == null ? null : cashPickupsCount,
    "package_count": packageCount == null ? null : packageCount,
    "upload_wbn": uploadWbn == null ? null : uploadWbn,
    "replacement_count": replacementCount == null ? null : replacementCount,
    "rmk": rmk == null ? null : rmk,
    "pickups_count": pickupsCount == null ? null : pickupsCount,
    "packages": packages == null ? null : List<dynamic>.from(packages.map((x) => x.toJson())),
    "cash_pickups": cashPickups == null ? null : cashPickups,
    "cod_count": codCount == null ? null : codCount,
    "success": success == null ? null : success,
    "prepaid_count": prepaidCount == null ? null : prepaidCount,
    "cod_amount": codAmount == null ? null : codAmount,
  };
}

class Package {
  Package({
    this.status,
    this.client,
    this.sortCode,
    this.remarks,
    this.waybill,
    this.codAmount,
    this.payment,
    this.serviceable,
    this.refnum,
  });

  final String status;
  final String client;
  final dynamic sortCode;
  final List<String> remarks;
  final String waybill;
  final dynamic codAmount;
  final String payment;
  final bool serviceable;
  final String refnum;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    status: json["status"] == null ? null : json["status"],
    client: json["client"] == null ? null : json["client"],
    sortCode: json["sort_code"],
    remarks: json["remarks"] == null ? null : List<String>.from(json["remarks"].map((x) => x)),
    waybill: json["waybill"] == null ? null : json["waybill"],
    codAmount: json["cod_amount"] == null ? null : json["cod_amount"],
    payment: json["payment"] == null ? null : json["payment"],
    serviceable: json["serviceable"] == null ? null : json["serviceable"],
    refnum: json["refnum"] == null ? null : json["refnum"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "client": client == null ? null : client,
    "sort_code": sortCode,
    "remarks": remarks == null ? null : List<dynamic>.from(remarks.map((x) => x)),
    "waybill": waybill == null ? null : waybill,
    "cod_amount": codAmount == null ? null : codAmount,
    "payment": payment == null ? null : payment,
    "serviceable": serviceable == null ? null : serviceable,
    "refnum": refnum == null ? null : refnum,
  };
}
