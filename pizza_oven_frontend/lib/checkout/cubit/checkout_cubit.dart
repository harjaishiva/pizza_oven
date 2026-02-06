import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pizza_oven_frontend/checkout/model/address_model.dart';
import 'package:pizza_oven_frontend/utility/api_urls.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_oven_frontend/utility/shared_preferences.dart';
import 'package:pizza_oven_frontend/utility/sqflite_service.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  AddressModel _addressModel = AddressModel();
  
  callgetAddress() async{
    try{
      String token = SharedPreferencesClass.prefs.getString(tOKEN) ?? "";
      String userId = SharedPreferencesClass.prefs.getString(uSERID) ?? "";

      String url = "$baseUrl$getAddress$userId";
      var uri = Uri.parse(url);

      log("url == $url\ntoken == $token");

      var response = await http.get(uri,headers:{"Content-Type":"application/json","Authorization":"Bearer $token"});
      
      _addressModel = AddressModel.fromJson(jsonDecode(response.body));

      log("Response Body == ${response.body}");

      if(response.statusCode == 200){
        emit(state.copyWith(loading: false, message: _addressModel.message, isSuccess: true, addressModel: _addressModel));
      }else{
        emit(state.copyWith(loading: false, message: _addressModel.message, isSuccess: false, addressModel: _addressModel));
      }

    }catch(e){
      log("ERROR == $e");
    }
  }

  clearCart() async{
    int result = await AppDataBase.instance.deleteCart();

    if(result == 1){
      return true;
    }
    else{
      return false;
    }
  }
  
}
