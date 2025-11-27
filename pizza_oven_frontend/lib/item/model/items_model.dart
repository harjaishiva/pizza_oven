class ItemModel {
  int? status;
  String? message;
  Data? data;

  ItemModel({this.status, this.message, this.data});

  ItemModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? image;
  String? name;
  int? price;
  int? weight;
  String? description;
  int? likes;
  int? isVeg;
  String? ingredients;
  int? isLiked;

  Data(
      {this.id,
      this.image,
      this.name,
      this.price,
      this.weight,
      this.description,
      this.likes,
      this.isVeg,
      this.ingredients,
      this.isLiked});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    price = json['price'];
    weight = json['weight'];
    description = json['description'];
    likes = json['likes'];
    isVeg = json['is_veg'];
    ingredients = json['ingredients'];
    isLiked = json['is_liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['price'] = price;
    data['weight'] = weight;
    data['description'] = description;
    data['likes'] = likes;
    data['is_veg'] = isVeg;
    data['ingredients'] = ingredients;
    data['is_liked'] = isLiked;
    return data;
  }
}