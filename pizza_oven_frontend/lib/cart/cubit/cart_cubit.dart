// import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pizza_oven_frontend/cart/model/cart_model.dart';
// import 'package:pizza_oven_frontend/utility/api_urls.dart';
// import 'package:pizza_oven_frontend/utility/shared_preferences.dart';
// import 'package:http/http.dart' as http;
import 'package:pizza_oven_frontend/utility/sqflite_service.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  // CartModel _cartModel = CartModel();

  callCartData() async {
    try {
      // var token = SharedPreferencesClass.prefs.getString(tOKEN);
      // var userid = SharedPreferencesClass.prefs.getString(uSERID);
      // String url = "$baseUrl$getCart$userid";

      // log("URL == $url");
      // log("token == $token");
      // var uri = Uri.parse(url);
      // var response = await http.get(uri,headers: {"Content-Type" : "application/json","Authorization": "Bearer $token"});
      // log(response.body);
      // _cartModel = CartModel.fromJson(jsonDecode(response.body));
      // log("RESPONSE == $_cartModel");
      // if(response.statusCode == 200){
      //   emit(state.copyWith(loading: false, message: _cartModel.message, isSuccess: true, cartModel: _cartModel));
      // }else{
      //   emit(state.copyWith(loading: false, message: _cartModel.message, isSuccess: false, cartModel: _cartModel));
      // }

      List<Cart> cartList = await AppDataBase.instance.getCart();

      log("$cartList");
      if (cartList.isEmpty) {
        emit(state.copyWith(loading: false));
        return <Cart>[];
      }

      emit(state.copyWith(loading: false));
      return cartList;
    } catch (e) {
      log("ERROR ==== $e");
      emit(state.copyWith(loading: false));
      return <Cart>[];
    }
  }

  callupdateQuantity(String cartid, String quantity) async {
    try {
      // var token = SharedPreferencesClass.prefs.getString(tOKEN);
      // var userid = SharedPreferencesClass.prefs.getString(uSERID);
      // String url = "$baseUrl$updateQuantity";

      // log("URL == $url");
      // log("token == $token");
      // var uri = Uri.parse(url);

      // Map map = {
      //   "userId": userid,
      //   "pizzaId": pizzaId,
      //   "quantity": quantity
      // };

      // String reqBody = jsonEncode(map);

      // log("reqBody == $reqBody");

      // var response = await http.put(uri,headers: {"Content-Type" : "application/json","Authorization": "Bearer $token"}, body: reqBody);
      // if(response.statusCode == 204){
      //   emit(state.copyWith(loading: false, message: "Success", isSuccess: true));
      //   callCartData();
      // }else{
      //   var resBody = jsonDecode(response.body);
      //   log(response.body);
      //   emit(state.copyWith(loading: false, message: resBody['message'], isSuccess: false));
      // }

      int result = await AppDataBase.instance.updateCartQuantity(
          cartId: int.parse(cartid), quantity: int.parse(quantity));
      if (result == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("ERROR ==== $e");
    }
  }

  calldeleteFromCart(String cartId) async {
    try {
      // var token = SharedPreferencesClass.prefs.getString(tOKEN);
      // var userid = SharedPreferencesClass.prefs.getString(uSERID);
      // String url = "$baseUrl$deleteFromCart";

      // log("URL == $url");
      // log("token == $token");
      // var uri = Uri.parse(url);

      // Map map = {
      //   "cart_id": cartId,
      //   "user_id": userid,
      //   "pizza_id": pizzaId,
      // };

      // String reqBody = jsonEncode(map);

      // log("reqBody == $reqBody");

      // var response = await http.delete(uri,headers: {"Content-Type" : "application/json","Authorization": "Bearer $token"}, body: reqBody);
      // if(response.statusCode == 204){
      //   emit(state.copyWith(loading: false, message: "Success", isSuccess: true));
      //   callCartData();
      // }else{
      //   var resBody = jsonDecode(response.body);
      //   log(response.body);
      //   emit(state.copyWith(loading: false, message: resBody['message'], isSuccess: false));
      // }

      int result = await AppDataBase.instance.deleteById(int.parse(cartId));
      if (result == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("ERROR ==== $e");
    }
  }

  cacultion(List<Cart>? list, bool priceCal) {
    double subTotalPrice = 0;
    List<int> counter = [];
    List<double> prices = [];

    for (int i = 0; i < (list?.length ?? 0); i++) {
      counter.add(list?[i].quantity ?? 0);
    }
    if (priceCal) {
      for (int index = 0; index < (list?.length ?? 0); index++) {
        if (list?[index].size == "S") {
          prices.add((list?[index].price ?? 0) - 20);
        } else if (list?[index].size == "L") {
          prices.add((list?[index].price ?? 0) + 20);
        } else {
          prices.add((list?[index].price ?? 0));
        }
      }
    }

    for (int i = 0; i < (prices.length); i++) {
      subTotalPrice += (prices[i] * counter[i]);
    }

    double tax = ((subTotalPrice * 12) / 100);
    String totalPrice = (subTotalPrice + tax + 10).toStringAsFixed(2);

    return [counter, prices, subTotalPrice, tax, totalPrice];
  }
}
