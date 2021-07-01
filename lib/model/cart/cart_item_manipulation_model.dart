class CartItemManipulationModel {
  int status;
  List<MessageData> data;

  CartItemManipulationModel({this.status, this.data});

  CartItemManipulationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] is String) {
      data = json['data'] ?? '';
    } else if (json['data'] != null) {
      data = new List<MessageData>();
      json['data'].forEach((v) {
        data.add(new MessageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
      data['status'] = this.status;
    }
    return data;
  }
}

class MessageData {
  String message;

  MessageData({this.message});

  MessageData.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    return data;
  }
}
