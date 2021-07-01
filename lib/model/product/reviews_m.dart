class ProductReviewsM {
  List<Reviews> data;

  ProductReviewsM({this.data});

  ProductReviewsM.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Reviews>();
      json['data'].forEach((v) {
        data.add(new Reviews.fromJson(v));
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

class Reviews {
  String response;
  String rId;
  String proId;
  String rMsg;
  String rRating;
  String rDate;
  String uId;
  String uName;

  Reviews({
    this.response,
    this.rId,
    this.proId,
    this.rMsg,
    this.rRating,
    this.rDate,
    this.uId,
    this.uName,
  });

  Reviews.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    rId = json['r_id'];
    proId = json['pro_id'];
    rMsg = json['r_msg'];
    rRating = json['r_rating'];
    rDate = json['r_date'];
    uId = json['u_id'];
    uName = json['u_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['r_id'] = this.rId;
    data['pro_id'] = this.proId;
    data['r_msg'] = this.rMsg;
    data['r_rating'] = this.rRating;
    data['r_date'] = this.rDate;
    data['u_id'] = this.uId;
    data['u_name'] = this.uName;
    return data;
  }
}
