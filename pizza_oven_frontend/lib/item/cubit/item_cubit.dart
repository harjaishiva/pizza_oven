import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pizza_oven_frontend/item/model/items_model.dart';
import 'package:pizza_oven_frontend/utility/api_urls.dart';
import 'package:pizza_oven_frontend/utility/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  ItemCubit() : super(ItemInitial());


 ItemModel _itemModel = ItemModel();

callItemdata(String itemId) async{
    try{

    var token = SharedPreferencesClass.prefs.getString(tOKEN);
    var userId = SharedPreferencesClass.prefs.getString(uSERID);
    var url = "$baseUrl$getoneItem$userId/$itemId";

    log("URL == $url");
    log("token == $token");
    var uri = Uri.parse(url);
    var response = await http.get(uri,headers: {"Content-Type" : "application/json","Authorization": "Bearer $token"});
     _itemModel = ItemModel.fromJson(jsonDecode(response.body));
    log("RESPONSE == ${ _itemModel.toJson()}");
    if(response.statusCode == 200){
      splitIngredients();
      emit(state.copyWith(loading: false, message:  _itemModel.message, isSuccess: true, itemModel:  _itemModel, isLiked: (_itemModel.data?.isLiked == 1) ? true : false));
    }else{
      emit(state.copyWith(loading: false, message:  _itemModel.message, isSuccess: false));
    }
    }catch(e){
      log("ERROR ==== $e");
    }
  }

  callupdatefavourite(String itemId) async{
    try{

      emit(state.copyWith(sLoading: true));

    var token = SharedPreferencesClass.prefs.getString(tOKEN);
    var userId = SharedPreferencesClass.prefs.getString(uSERID);
    var url = "$baseUrl$updateFavourite$userId/$itemId";

    log("URL == $url");
    log("token == $token");
    var uri = Uri.parse(url);
    var response = await http.put(uri,headers: {"Content-Type" : "application/json","Authorization": "Bearer $token"});
    if(response.statusCode == 201){
      var responseBody = jsonDecode(response.body);
      log("$responseBody");
      emit(state.copyWith(sLoading: false, message: responseBody['message'], isSuccess: true, isLiked: true));
    }else if(response.statusCode == 204){
      emit(state.copyWith(sLoading: false, isSuccess: true, isLiked: false));
    }else{
      var responseBody = jsonDecode(response.body);
      log("$responseBody");
     emit(state.copyWith(sLoading: false, message:  responseBody['message'], isSuccess: false)); 
    }
    }catch(e){
      log("ERROR ==== $e");
    }
  }

  callAddToCart({required String pizzaId, required String size, required String quantity}) async{
    try{

      emit(state.copyWith(sLoading: true));

      var token = SharedPreferencesClass.prefs.getString(tOKEN);
      var userId = SharedPreferencesClass.prefs.getString(uSERID);

    const url = baseUrl+addToCart;
    Map map = {
      "user_id": userId,
      "pizza_id": pizzaId,
      "size": size,
      "quantity": quantity
    };

    var requestBody = jsonEncode(map);
    log("URL == $url\nRequestbody == $requestBody");
    var uri = Uri.parse(url);
    var response = await http.post(uri,headers: {"Content-Type" : "application/json","Authorization": "Bearer $token"},body:requestBody);
    if(response.statusCode == 200){
      var responseBody = jsonDecode(response.body);
      log(response.body);
      log("$responseBody");
      emit(state.copyWith(sLoading: false, message: responseBody['message'], isSuccessC: true));
    }else if(response.statusCode == 204){
      emit(state.copyWith(sLoading: false, message: "Updated the pre existing order", isSuccessC: true));
    }else{
      var responseBody = jsonDecode(response.body);
      log("$responseBody");
      log(response.body);
      emit(state.copyWith(sLoading: false, message: responseBody['message'], isSuccessC: false));
    }
    }catch(e){
      log("ERROR ==== $e");
    }
  }

  splitIngredients(){
    List<String> ingredientList = [];
    String ingredients = _itemModel.data?.ingredients ?? "";
    if(ingredients!=""){
      ingredientList = ingredients.split(",");
    }

    emit(state.copyWith(ingredients: ingredientList));
  }
  
}
