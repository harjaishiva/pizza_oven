import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_oven_frontend/utility/api_urls.dart';
import 'package:pizza_oven_frontend/utility/shared_preferences.dart';
import 'package:http/http.dart' as http;
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super( SplashInitialState());

  callVerifyToken() async{
    try{
      String? token = SharedPreferencesClass.prefs.getString(tOKEN);
    log("Token == $token\n");
    const url = baseUrl+verifyToken;
    log("Url == $url\n");
    var uri = Uri.parse(url);
    var response = await http.post(uri,headers: {"Content-Type" : "application/json","Authorization":"Bearer $token"});
    
    // log("Response == $reponseBody\n");
    if(response.statusCode == 200){
      var reponseBody = jsonDecode(response.body);
      emit(state.copyWith(loading: false, message: reponseBody['message'], isSuccess: true));
    }else{
      var reponseBody = jsonDecode(response.body);
      emit(state.copyWith(loading: false, message: reponseBody['message'], isSuccess: false));
    }
    }catch(e){
      log("$e");
    }
  }
}
