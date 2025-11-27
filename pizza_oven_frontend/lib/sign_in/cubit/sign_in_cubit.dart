import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pizza_oven_frontend/utility/api_urls.dart';
import 'package:pizza_oven_frontend/utility/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());
  
  callSignIn({required String email, required String password}) async{
    try{
    const url = baseUrl+signIn;
    Map map = {
      "email": email,
      "password": password
    };

    var requestBody = jsonEncode(map);
    log("URL == $url\nRequestbody == $requestBody");
    var uri = Uri.parse(url);
    var response = await http.post(uri,headers: {"Content-Type" : "application/json"},body:requestBody);
    var responseBody = jsonDecode(response.body);
    log("Response == $responseBody\n");
    if(response.statusCode == 200){
      SharedPreferencesClass.prefs.setString(tOKEN,responseBody['token']);
      SharedPreferencesClass.prefs.setString(uSERID,responseBody['userId'].toString());
      SharedPreferencesClass.prefs.setString(iMAGE,responseBody['image']);
      emit(state.copyWith(loading: false, message: responseBody['message'], isSuccess: true));
    }else{
      emit(state.copyWith(loading: false, message: responseBody['message'], isSuccess: false));
    }
    }catch(e){
      log("ERROR ==== $e");
    }
  }
  
}
