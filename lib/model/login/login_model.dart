import 'dart:convert';

class LoginModel {
  int status;
  String message;
  dynamic data;

  LoginModel({this.status, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    if (json['status'] is bool) {
      if(json['status']){
        status = 200;
      }else{
        status = 205;
      }
    } else {
      status = json['status'];
    }
    message = json['message'] != null ? json['message'] : '';
    if (json['data'] is String) {
      data = json['data'] ?? '';
    } else if (json['data'] != null) {
      print("Run time type : ${json['data'].runtimeType}");
      if (json['data'] is List<dynamic>) {
        data = new List<LoginData>();
        json['data'].forEach((v) {
          data.add(new LoginData.fromJson(v));
        });
      } else {
        data = [LoginData.fromJson(json['data'])];
      }
    }
  }

  Map<String, dynamic> toJson(LoginModel model) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = model.status;
    data['message'] = model.message;
    if (model.data != null) {
      data['data'] = model.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoginData {
  String login;
  String id;
  String userName;
  String userAddress;
  String pinCode;
  String userGender;
  String userEmail;
  String userMobile;
  String userImage;
  String userStateId;
  String userCountryId;
  String userCityId;
  String userImageLink;
  String userCountryName;
  String userStateName;
  String userCityName;
  String error;

  LoginData({
    this.login,
    this.id,
    this.userName,
    this.userAddress,
    this.pinCode,
    this.userGender,
    this.userEmail,
    this.userMobile,
    this.userImage,
    this.userStateId,
    this.userCountryId,
    this.userCityId,
    this.userImageLink,
    this.error,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    login = json['login'] != null ? json['login'] : '';
    id = json['u_id'] != null ? json['u_id'] : '';
    userName = json['u_name'] != null ? json['u_name'] : '';
    userAddress = json['u_add'] != null ? json['u_add'] : '';
    pinCode = json['pincode'] != null ? json['pincode'] : '';
    userGender = json['u_gen'] != null ? json['u_gen'] : '';
    userEmail = json['u_email'] != null ? json['u_email'] : '';
    userMobile = json['u_mob'] != null ? json['u_mob'] : '';
    userImage = json['u_img'] != null ? json['u_img'] : '';
    userStateId = json['state_id'] != null ? json['state_id'] : '';
    userCountryId = json['country_id'] != null ? json['country_id'] : '';
    userCityId = json['city_id'] != null ? json['city_id'] : '';
    userImageLink = json['img_link'] != null ? json['img_link'] : '';
    error = json['Error'] != null ? json['Error'] : '';
  }

  String toJson(LoginData dataLogin) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = dataLogin.login ?? '';
    data['u_id'] = dataLogin.id ?? '';
    data['u_name'] = dataLogin.userName ?? '';
    data['u_add'] = dataLogin.userAddress ?? '';
    data['pincode'] = dataLogin.pinCode ?? '';
    data['u_gen'] = dataLogin.userGender ?? '';
    data['u_email'] = dataLogin.userEmail ?? '';
    data['u_mob'] = dataLogin.userMobile ?? '';
    data['u_img'] = dataLogin.userImage ?? '';
    data['state_id'] = dataLogin.userStateId ?? '';
    data['country_id'] = dataLogin.userCountryId ?? '';
    data['city_id'] = dataLogin.userCityId ?? '';
    data['img_link'] = dataLogin.userImageLink ?? '';
    data['Error'] = dataLogin.error ?? '';
    return json.encode(data);
  }
}
