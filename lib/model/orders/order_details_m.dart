class OrderDetailsM {
  List<ShipmentData> shipmentData;

  OrderDetailsM({this.shipmentData});

  OrderDetailsM.fromJson(Map<String, dynamic> json) {
    if (json['ShipmentData'] != null) {
      shipmentData = new List<ShipmentData>();
      json['ShipmentData'].forEach((v) {
        shipmentData.add(new ShipmentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shipmentData != null) {
      data['ShipmentData'] = this.shipmentData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShipmentData {
  Shipment shipment;

  ShipmentData({this.shipment});

  ShipmentData.fromJson(Map<String, dynamic> json) {
    shipment = json['Shipment'] != null ? new Shipment.fromJson(json['Shipment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shipment != null) {
      data['Shipment'] = this.shipment.toJson();
    }
    return data;
  }
}

class Shipment {
  String origin;
  Status status;
  String pickUpDate;
  var chargedWeight;
  String orderType;
  String destination;
  Consignee consignee;
  String referenceNo;
  var returnedDate;
  var destRecieveDate;
  var originRecieveDate;
  var outDestinationDate;
  int cODAmount;
  var firstAttemptDate;
  bool reverseInTransit;
  List<Scans> scans;
  String senderName;
  String aWB;
  int dispatchCount;
  int invoiceAmount;

  Shipment(
      {this.origin,
      this.status,
      this.pickUpDate,
      this.chargedWeight,
      this.orderType,
      this.destination,
      this.consignee,
      this.referenceNo,
      this.returnedDate,
      this.destRecieveDate,
      this.originRecieveDate,
      this.outDestinationDate,
      this.cODAmount,
      this.firstAttemptDate,
      this.reverseInTransit,
      this.scans,
      this.senderName,
      this.aWB,
      this.dispatchCount,
      this.invoiceAmount});

  Shipment.fromJson(Map<String, dynamic> json) {
    origin = json['Origin'];
    status = json['Status'] != null ? new Status.fromJson(json['Status']) : null;
    pickUpDate = json['PickUpDate'];
    chargedWeight = json['ChargedWeight'];
    orderType = json['OrderType'];
    destination = json['Destination'];
    consignee = json['Consignee'] != null ? new Consignee.fromJson(json['Consignee']) : null;
    referenceNo = json['ReferenceNo'];
    returnedDate = json['ReturnedDate'];
    destRecieveDate = json['DestRecieveDate'];
    originRecieveDate = json['OriginRecieveDate'];
    outDestinationDate = json['OutDestinationDate'];
    cODAmount = json['CODAmount'];
    firstAttemptDate = json['FirstAttemptDate'];
    reverseInTransit = json['ReverseInTransit'];
    if (json['Scans'] != null) {
      scans = new List<Scans>();
      json['Scans'].forEach((v) {
        scans.add(new Scans.fromJson(v));
      });
    }
    senderName = json['SenderName'];
    aWB = json['AWB'];
    dispatchCount = json['DispatchCount'];
    invoiceAmount = json['InvoiceAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Origin'] = this.origin;
    if (this.status != null) {
      data['Status'] = this.status.toJson();
    }
    data['PickUpDate'] = this.pickUpDate;
    data['ChargedWeight'] = this.chargedWeight;
    data['OrderType'] = this.orderType;
    data['Destination'] = this.destination;
    if (this.consignee != null) {
      data['Consignee'] = this.consignee.toJson();
    }
    data['ReferenceNo'] = this.referenceNo;
    data['ReturnedDate'] = this.returnedDate;
    data['DestRecieveDate'] = this.destRecieveDate;
    data['OriginRecieveDate'] = this.originRecieveDate;
    data['OutDestinationDate'] = this.outDestinationDate;
    data['CODAmount'] = this.cODAmount;
    data['FirstAttemptDate'] = this.firstAttemptDate;
    data['ReverseInTransit'] = this.reverseInTransit;
    if (this.scans != null) {
      data['Scans'] = this.scans.map((v) => v.toJson()).toList();
    }
    data['SenderName'] = this.senderName;
    data['AWB'] = this.aWB;
    data['DispatchCount'] = this.dispatchCount;
    data['InvoiceAmount'] = this.invoiceAmount;
    return data;
  }
}

class Status {
  String status;
  String statusLocation;
  String statusDateTime;
  String recievedBy;
  String instructions;
  String statusType;
  String statusCode;

  Status(
      {this.status,
      this.statusLocation,
      this.statusDateTime,
      this.recievedBy,
      this.instructions,
      this.statusType,
      this.statusCode});

  Status.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    statusLocation = json['StatusLocation'];
    statusDateTime = json['StatusDateTime'];
    recievedBy = json['RecievedBy'];
    instructions = json['Instructions'];
    statusType = json['StatusType'];
    statusCode = json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['StatusLocation'] = this.statusLocation;
    data['StatusDateTime'] = this.statusDateTime;
    data['RecievedBy'] = this.recievedBy;
    data['Instructions'] = this.instructions;
    data['StatusType'] = this.statusType;
    data['StatusCode'] = this.statusCode;
    return data;
  }
}

class Consignee {
  String city;
  String name;
  String country;
  List<Address2> address2;
  String address3;
  int pinCode;
  String state;
  String telephone2;
  String telephone1;
  List<String> address1;

  Consignee(
      {this.city,
      this.name,
      this.country,
      this.address2,
      this.address3,
      this.pinCode,
      this.state,
      this.telephone2,
      this.telephone1,
      this.address1});

  Consignee.fromJson(Map<String, dynamic> json) {
    city = json['City'];
    name = json['Name'];
    country = json['Country'];
    if (json['Address2'] != null) {
      address2 = new List<Address2>();
      json['Address2'].forEach((v) {
        address2.add(new Address2.fromJson(v));
      });
    }
    address3 = json['Address3'];
    pinCode = json['PinCode'];
    state = json['State'];
    telephone2 = json['Telephone2'];
    telephone1 = json['Telephone1'];
    address1 = json['Address1'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['City'] = this.city;
    data['Name'] = this.name;
    data['Country'] = this.country;
    if (this.address2 != null) {
      data['Address2'] = this.address2.map((v) => v.toJson()).toList();
    }
    data['Address3'] = this.address3;
    data['PinCode'] = this.pinCode;
    data['State'] = this.state;
    data['Telephone2'] = this.telephone2;
    data['Telephone1'] = this.telephone1;
    data['Address1'] = this.address1;
    return data;
  }
}

class Scans {
  ScanDetail scanDetail;

  Scans({this.scanDetail});

  Scans.fromJson(Map<String, dynamic> json) {
    scanDetail = json['ScanDetail'] != null ? new ScanDetail.fromJson(json['ScanDetail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.scanDetail != null) {
      data['ScanDetail'] = this.scanDetail.toJson();
    }
    return data;
  }
}

class ScanDetail {
  String scanDateTime;
  String scanType;
  String scan;
  String statusDateTime;
  String scannedLocation;
  String instructions;
  String statusCode;

  ScanDetail({
    this.scanDateTime,
    this.scanType,
    this.scan,
    this.statusDateTime,
    this.scannedLocation,
    this.instructions,
    this.statusCode,
  });

  ScanDetail.fromJson(Map<String, dynamic> json) {
    scanDateTime = json['ScanDateTime'];
    scanType = json['ScanType'];
    scan = json['Scan'];
    statusDateTime = json['StatusDateTime'];
    scannedLocation = json['ScannedLocation'];
    instructions = json['Instructions'];
    statusCode = json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ScanDateTime'] = this.scanDateTime;
    data['ScanType'] = this.scanType;
    data['Scan'] = this.scan;
    data['StatusDateTime'] = this.statusDateTime;
    data['ScannedLocation'] = this.scannedLocation;
    data['Instructions'] = this.instructions;
    data['StatusCode'] = this.statusCode;
    return data;
  }
}

class Address2 {
  String scanDateTime;
  String scanType;
  String scan;
  String statusDateTime;
  String scannedLocation;
  String instructions;
  String statusCode;

  Address2(
      {this.scanDateTime,
      this.scanType,
      this.scan,
      this.statusDateTime,
      this.scannedLocation,
      this.instructions,
      this.statusCode});

  Address2.fromJson(Map<String, dynamic> json) {
    scanDateTime = json['ScanDateTime'];
    scanType = json['ScanType'];
    scan = json['Scan'];
    statusDateTime = json['StatusDateTime'];
    scannedLocation = json['ScannedLocation'];
    instructions = json['Instructions'];
    statusCode = json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ScanDateTime'] = this.scanDateTime;
    data['ScanType'] = this.scanType;
    data['Scan'] = this.scan;
    data['StatusDateTime'] = this.statusDateTime;
    data['ScannedLocation'] = this.scannedLocation;
    data['Instructions'] = this.instructions;
    data['StatusCode'] = this.statusCode;
    return data;
  }
}
