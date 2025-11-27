import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pizza_oven_frontend/utility/api_urls.dart';
import 'package:http/http.dart' as http;

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());
  
  callSignUp({required String name, required String email, required String password}) async{
    try{
    const url = baseUrl+signUp;
    Map map = {
      "name": name,
      "email": email,
      "password": password
    };

    var requestBody = jsonEncode(map);
    log("URL == $url\nRequestbody == $requestBody");
    var uri = Uri.parse(url);
    var response = await http.post(uri,headers: {"Content-Type" : "application/json"},body:requestBody);
    var responseBody = jsonDecode(response.body);
    log("Response == $responseBody\n");
    if(response.statusCode == 201){
      emit(state.copyWith(loading: false, message: responseBody['message'], isSuccess: true));
    }else{
      emit(state.copyWith(loading: false, message: responseBody['message'], isSuccess: false));
    }
    }catch(e){
      log("ERROR ==== $e");
    }
  }
  
}
