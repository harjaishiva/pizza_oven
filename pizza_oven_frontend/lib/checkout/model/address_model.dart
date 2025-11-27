class AddressModel {
  int? status;
  String? message;
  List<Addresses>? addresses;

  AddressModel({this.status, this.message, this.addresses});

  AddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  int? id;
  int? userId;
  String? addressName;
  String? houseNo;
  String? buildingNo;
  String? locality;
  String? district;
  String? state;
  String? landmark;

  Addresses(
      {this.id,
      this.userId,
      this.addressName,
      this.houseNo,
      this.buildingNo,
      this.locality,
      this.district,
      this.state,
      this.landmark});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    addressName = json['address_name'];
    houseNo = json['house_no'];
    buildingNo = json['building_no'];
    locality = json['locality'];
    district = json['district'];
    state = json['state'];
    landmark = json['landmark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['address_name'] = addressName;
    data['house_no'] = houseNo;
    data['building_no'] = buildingNo;
    data['locality'] = locality;
    data['district'] = district;
    data['state'] = state;
    data['landmark'] = landmark;
    return data;
  }
}