import 'dart:convert';

CityModel cityModelFromJson(String str) => CityModel.fromJson(json.decode(str));

String cityModelToJson(CityModel data) => json.encode(data.toJson());

class CityModel {
  CityModel({this.status, this.data});

  int status;
  List<dynamic> data;

  CityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] is String) {
      data = json['data'] ?? '';
    } else if (json['data'] != null && json['data'].length > 0 && json['data'][0]['city'] != null) {
      data = new List<City>();
      json['data'][0]['city'].forEach((v) {
        data.add(new City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class City {
  City({
    this.id,
    this.name,
    this.stateId,
  });

  final String id;
  final String name;
  final String stateId;

  bool operator ==(dynamic other) => other != null && other is City && this.name == other.name;

  @override
  int get hashCode => super.hashCode;


  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        stateId: json["state_id"] == null ? null : json["state_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "state_id": stateId == null ? null : stateId,
      };
}
