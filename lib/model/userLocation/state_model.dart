import 'dart:convert';

StateModel stateModelFromJson(String str) => StateModel.fromJson(json.decode(str));

String stateModelToJson(StateModel data) => json.encode(data.toJson());

class StateModel {
  StateModel({this.status, this.data});

  int status;
  List<dynamic> data;

  StateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] is String) {
      data = json['data'] ?? '';
    } else if (json['data'] != null && json['data'].length > 0 && json['data'][0]['state'] != null) {
      data = new List<States>();
      json['data'][0]['state'].forEach((v) {
        data.add(new States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class States {
  States({
    this.id,
    this.name,
    this.countryId,
  });

  final String id;
  final String name;
  final String countryId;

  bool operator ==(dynamic other) => other != null && other is States && this.name == other.name;

  @override
  int get hashCode => super.hashCode;

  factory States.fromJson(Map<String, dynamic> json) => States(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        countryId: json["country_id"] == null ? null : json["country_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "country_id": countryId == null ? null : countryId,
      };
}
