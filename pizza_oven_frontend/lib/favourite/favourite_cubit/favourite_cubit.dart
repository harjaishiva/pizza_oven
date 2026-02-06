import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pizza_oven_frontend/favourite/model/favourite_model.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_oven_frontend/utility/api_urls.dart';
import 'package:pizza_oven_frontend/utility/shared_preferences.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteInitial());

  FavouriteModel _favouriteModel = FavouriteModel();

  getFavourites() async{
    try{
        final token = SharedPreferencesClass.prefs.getString(tOKEN);
        final userId = SharedPreferencesClass.prefs.getString(uSERID);

        final uri = "$baseUrl$getFavourite$userId";
        final url = Uri.parse(uri);

        log("URL : $url\ntoken: $token");

        final response = await http.get(url,headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});
        log(response.body);
        if(response.statusCode == 200){
          _favouriteModel = FavouriteModel.fromJson(jsonDecode(response.body));
          emit(state.copyWith(isLoading: false, success: true, message: _favouriteModel.message, favouriteModel: _favouriteModel));
        }else{
          emit(state.copyWith(isLoading: false, success: false, message: _favouriteModel.message, favouriteModel: _favouriteModel));
        }
    }catch(e){
      log("Error while making api call : $e");
    }
  }  
}
