import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pizza_oven_frontend/home/model/home_model.dart';
import 'package:pizza_oven_frontend/utility/api_urls.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_oven_frontend/utility/shared_preferences.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  HomeModel _homeModel = HomeModel();

  callHomeData() async{
    try{

    var token = SharedPreferencesClass.prefs.getString(tOKEN);
    const url = baseUrl+getHomeData;

    log("URL == $url");
    log("token == $token");
    var uri = Uri.parse(url);
    var response = await http.get(uri,headers: {"Content-Type" : "application/json","Authorization": "Bearer $token"});
    _homeModel = HomeModel.fromJson(jsonDecode(response.body));
    log("RESPONSE == ${_homeModel.toJson()}");
    if(response.statusCode == 200){
      emit(state.copyWith(loading: false, message: _homeModel.message, isSuccess: true, homeModel: _homeModel));
      filter();
    }else{
      emit(state.copyWith(loading: false, message: _homeModel.message, isSuccess: false, homeModel: _homeModel));
    }
    }catch(e){
      log("ERROR ==== $e");
    }
  }

  filter(){
    List<Data> veg = [];
    List<Data> nonVeg = [];
    List<Data>? lowToHigh = _homeModel.data;
    for(int i = 0; i < (_homeModel.data?.length ?? 0); i++ ){
      if(_homeModel.data?[i].isVeg == 1){
        veg.add(_homeModel.data![i]);
      }else{
        nonVeg.add(_homeModel.data![i]);
      }
    }

    Data temp;

    for(int i = (lowToHigh?.length ?? 0) - 1; i >= 0; i--){
        for(int j = 0; j < i ; j++ ){
            if((lowToHigh![j].price ?? 0) > (lowToHigh[j+1].price ?? 0)){
                temp = lowToHigh[j];
                lowToHigh[j] = lowToHigh[j+1];
                lowToHigh[j+1] = temp;
            }
        }
    }
    emit(state.copyWith(veg: veg, nonVeg: nonVeg, lowToHigh: lowToHigh?.reversed.toList()));
  }
}
