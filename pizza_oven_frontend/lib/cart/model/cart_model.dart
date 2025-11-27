class CartModel {
  int? status;
  String? message;
  List<Data>? data;

  CartModel({this.status, this.message, this.data});

  CartModel.fromJson(Map<String, dynamic> json) {
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
  int? pizzaId;
  int? cartId;
  String? name;
  String? image;
  String? size;
  int? price;
  int? quantity;
  int? totalPrice;

  Data(
      {this.pizzaId,
      this.cartId,
      this.name,
      this.image,
      this.size,
      this.price,
      this.quantity,
      this.totalPrice});

  Data.fromJson(Map<String, dynamic> json) {
    pizzaId = json['pizza_id'];
    cartId= json['cart_id'];
    name = json['name'];
    image = json['image'];
    size = json['size'];
    price = json['price'];
    quantity = json['quantity'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pizza_id'] = pizzaId;
    data['cartId'] = cartId;
    data['name'] = name;
    data['image'] = image;
    data['size'] = size;
    data['price'] = price;
    data['quantity'] = quantity;
    data['totalPrice'] = totalPrice;
    return data;
  }
}