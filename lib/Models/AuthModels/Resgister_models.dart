class RegisterModels {
  int key;
  Data data;
  String msg;
  bool status;
  int code;

  RegisterModels({this.key, this.data, this.msg, this.status, this.code});

  RegisterModels.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
    status = json['status'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['code'] = this.code;
    return data;
  }
}

class Data {
  String id;
  String userName;
  String email;
  int cityID;
  String phone;
  String lat;
  Null lng;
  Null address;
  String lang;

  Data(
      {this.id,
      this.userName,
      this.email,
      this.cityID,
      this.phone,
      this.lat,
      this.lng,
      this.address,
      this.lang});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    email = json['email'];
    cityID = json['cityID'];
    phone = json['phone'];
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    lang = json['lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['email'] = this.email;
    data['cityID'] = this.cityID;
    data['phone'] = this.phone;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['lang'] = this.lang;
    return data;
  }
}
