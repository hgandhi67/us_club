import 'dart:convert';

CountryModel countryModelFromJson(String str) => CountryModel.fromJson(json.decode(str));

String countryModelToJson(CountryModel data) => json.encode(data.toJson());

class CountryModel {
  CountryModel({this.status, this.data});

  int status;
  List<dynamic> data;

  CountryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] is String) {
      data = json['data'] ?? '';
    } else if (json['data'] != null && json['data'].length > 0 && json['data'][0]['country'] != null) {
      data = new List<Country>();
      json['data'][0]['country'].forEach((v) {
        data.add(new Country.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Country {
  Country({
    this.id,
    this.sortName,
    this.name,
    this.phoneCode,
  });

  final String id;
  final String sortName;
  final String name;
  final String phoneCode;

  bool operator ==(dynamic other) => other != null && other is Country && this.sortName == other.sortName;

  @override
  int get hashCode => super.hashCode;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"] == null ? null : json["id"],
        sortName: json["sortname"] == null ? null : json["sortname"],
        name: json["name"] == null ? null : json["name"],
        phoneCode: json["phonecode"] == null ? null : json["phonecode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "sortname": sortName == null ? null : sortName,
        "name": name == null ? null : name,
        "phonecode": phoneCode == null ? null : phoneCode,
      };
}
