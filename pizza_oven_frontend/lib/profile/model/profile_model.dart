class ProfileModel {
  int? status;
  String? message;
  Data? data;

  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  List<Addresses>? addresses;

  Data({this.user, this.addresses});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? userId;
  String? name;
  String? email;
  String? password;
  String? phoneNumber;

  User({this.userId, this.name, this.email, this.password, this.phoneNumber});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}

class Addresses {
  int? addId;
  String? addName;
  String? houseNo;
  String? buildingNo;
  String? locality;
  String? district;
  String? state;
  String? landmark;

  Addresses(
      {this.addId,
      this.addName,
      this.houseNo,
      this.buildingNo,
      this.locality,
      this.district,
      this.state,
      this.landmark});

  Addresses.fromJson(Map<String, dynamic> json) {
    addId = json['addId'];
    addName = json['addName'];
    houseNo = json['houseNo'];
    buildingNo = json['buildingNo'];
    locality = json['locality'];
    district = json['district'];
    state = json['state'];
    landmark = json['landmark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addId'] = addId;
    data['addName'] = addName;
    data['houseNo'] = houseNo;
    data['buildingNo'] = buildingNo;
    data['locality'] = locality;
    data['district'] = district;
    data['state'] = state;
    data['landmark'] = landmark;
    return data;
  }
}