class FavouriteModel {
  int? status;
  String? message;
  List<Data>? data;

  FavouriteModel({this.status, this.message, this.data});

  FavouriteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? image;
  int? weight;
  int? price;
  int? isVeg;

  Data({this.id, this.name, this.image, this.weight, this.price, this.isVeg});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    weight = json['weight'];
    price = json['price'];
    isVeg = json['is_veg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['weight'] = weight;
    data['price'] = price;
    data['is_veg'] = isVeg;
    return data;
  }
}