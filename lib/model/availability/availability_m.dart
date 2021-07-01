class AvailabilityM {
  List<DeliveryCodes> deliveryCodes;

  AvailabilityM({this.deliveryCodes});

  AvailabilityM.fromJson(Map<String, dynamic> json) {
    if (json['delivery_codes'] != null) {
      deliveryCodes = new List<DeliveryCodes>();
      json['delivery_codes'].forEach((v) {
        deliveryCodes.add(new DeliveryCodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deliveryCodes != null) {
      data['delivery_codes'] =
          this.deliveryCodes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryCodes {
  PostalCode postalCode;

  DeliveryCodes({this.postalCode});

  DeliveryCodes.fromJson(Map<String, dynamic> json) {
    postalCode = json['postal_code'] != null
        ? new PostalCode.fromJson(json['postal_code'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.postalCode != null) {
      data['postal_code'] = this.postalCode.toJson();
    }
    return data;
  }
}

class PostalCode {
  String inc;
  var covidZone;
  var pin;
  var maxAmount;
  String prePaid;
  String cash;
  String pickup;
  String repl;
  String cod;
  String countryCode;
  String sortCode;
  String isOda;
  String district;
  String stateCode;
  var maxWeight;

  PostalCode(
      {this.inc,
        this.covidZone,
        this.pin,
        this.maxAmount,
        this.prePaid,
        this.cash,
        this.pickup,
        this.repl,
        this.cod,
        this.countryCode,
        this.sortCode,
        this.isOda,
        this.district,
        this.stateCode,
        this.maxWeight});

  PostalCode.fromJson(Map<String, dynamic> json) {
    inc = json['inc'];
    covidZone = json['covid_zone'];
    pin = json['pin'];
    maxAmount = json['max_amount'];
    prePaid = json['pre_paid'];
    cash = json['cash'];
    pickup = json['pickup'];
    repl = json['repl'];
    cod = json['cod'];
    countryCode = json['country_code'];
    sortCode = json['sort_code'];
    isOda = json['is_oda'];
    district = json['district'];
    stateCode = json['state_code'];
    maxWeight = json['max_weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inc'] = this.inc;
    data['covid_zone'] = this.covidZone;
    data['pin'] = this.pin;
    data['max_amount'] = this.maxAmount;
    data['pre_paid'] = this.prePaid;
    data['cash'] = this.cash;
    data['pickup'] = this.pickup;
    data['repl'] = this.repl;
    data['cod'] = this.cod;
    data['country_code'] = this.countryCode;
    data['sort_code'] = this.sortCode;
    data['is_oda'] = this.isOda;
    data['district'] = this.district;
    data['state_code'] = this.stateCode;
    data['max_weight'] = this.maxWeight;
    return data;
  }
}
