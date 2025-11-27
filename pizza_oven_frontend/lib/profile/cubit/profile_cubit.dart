import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pizza_oven_frontend/profile/model/profile_model.dart';
import 'package:pizza_oven_frontend/utility/api_urls.dart';
import 'package:pizza_oven_frontend/utility/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  ProfileModel _profileModel = ProfileModel();

  callGetProfile() async {
    try {
      String token = SharedPreferencesClass.prefs.getString(tOKEN) ?? "";
      String userId = SharedPreferencesClass.prefs.getString(uSERID) ?? "";

      final url = "$baseUrl$getProfile$userId";
      final uri = Uri.parse(url);

      log("URL == $url\nUserId == $userId");

      var response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });
      log(response.body);
      _profileModel = ProfileModel.fromJson(jsonDecode(response.body));
      if (response.statusCode == 200) {
        addressList();
        emit(state.copyWith(
            loading: false,
            message: _profileModel.message,
            isSuccess: true,
            profileModel: _profileModel));
      } else {
        emit(state.copyWith(
            loading: false,
            message: _profileModel.message,
            isSuccess: false,
            profileModel: _profileModel));
      }
    } catch (e) {
      log("ERROR == $e");
    }
  }

  callEditInfo(String name, String email, String phoneNo) async {
    try {
      String token = SharedPreferencesClass.prefs.getString(tOKEN) ?? "";
      String userId = SharedPreferencesClass.prefs.getString(uSERID) ?? "";

      const url = "$baseUrl$editprofile";
      final uri = Uri.parse(url);

      log("URL == $url\nUserId == $userId");

      Map map = {
        "userId": userId,
        "name": name,
        "email": email,
        "phoneNo": phoneNo
      };

      final reqBody = jsonEncode(map);

      log("REQUESTBODY == $reqBody");

      var response = await http.put(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },body: reqBody);
      log(response.body);
      if (response.statusCode == 204) {
        emit(state.copyWith(
          loading: false,
          message: "SuccessFully updated the data",
          isESuccess: true,
        ));
      } else {
        var responseBody = jsonDecode(response.body);
        emit(state.copyWith(
          loading: false,
          message: responseBody['message'],
          isESuccess: false,
        ));
      }
    } catch (e) {
      log("ERROR == $e");
    }
  }

  callAddAddress(String addname, String houseNo, String buildingNo, String locality, String district, String astate, String landmark) async {
    try {
      String token = SharedPreferencesClass.prefs.getString(tOKEN) ?? "";
      String userId = SharedPreferencesClass.prefs.getString(uSERID) ?? "";

      const url = "$baseUrl$addAddress";
      final uri = Uri.parse(url);

      log("URL == $url\nUserId == $userId");

      Map map = {
  "userId": userId,
  "addName": addname,
  "houseNo": houseNo,
  "buildingNo": buildingNo,
  "locality": locality,
  "district": district,
  "state": astate,
  "landmark": landmark
};

      final reqBody = jsonEncode(map);

      log("REQUESTBODY == $reqBody");

      var response = await http.post(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },body: reqBody);
      log(response.body);
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 201) {
        emit(state.copyWith(
          loading: false,
          message: responseBody['message'],
          isESuccess: true,
        ));
      } else {
        emit(state.copyWith(
          loading: false,
          message: responseBody['message'],
          isESuccess: false,
        ));
      }
    } catch (e) {
      log("ERROR == $e");
    }
  }

  callupdateAddress(String addId, String addname, String houseNo, String buildingNo, String locality, String district, String astate, String landmark) async {
    try {
      String token = SharedPreferencesClass.prefs.getString(tOKEN) ?? "";
      String userId = SharedPreferencesClass.prefs.getString(uSERID) ?? "";

      const url = "$baseUrl$updateAddress";
      final uri = Uri.parse(url);

      log("URL == $url\nUserId == $userId");

      Map map = {
  "userId": userId,
  "addId": addId,
  "addName": addname,
  "houseNo": houseNo,
  "buildingNo": buildingNo,
  "locality": locality,
  "district": district,
  "state": astate,
  "landmark": landmark
};

      final reqBody = jsonEncode(map);

      log("REQUESTBODY == $reqBody");

      var response = await http.put(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },body: reqBody);
      log(response.body);
      if (response.statusCode == 204) {
        emit(state.copyWith(
          loading: false,
          message: "Successfully updated",
          isESuccess: true,
        ));
      } else {
        var responseBody = jsonDecode(response.body);
        emit(state.copyWith(
          loading: false,
          message: responseBody['message'],
          isESuccess: false,
        ));
      }
    } catch (e) {
      log("ERROR == $e");
    }
  }

  calldeleteAddress(String addId, String addname) async {
    try {
      String token = SharedPreferencesClass.prefs.getString(tOKEN) ?? "";
      String userId = SharedPreferencesClass.prefs.getString(uSERID) ?? "";

      const url = "$baseUrl$deleteAddress";
      final uri = Uri.parse(url);

      log("URL == $url\nUserId == $userId");

      Map map = {
  "userId": userId,
  "addId": addId,
  "addName": addname
};

      final reqBody = jsonEncode(map);

      log("REQUESTBODY == $reqBody");

      var response = await http.delete(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },body: reqBody);
      log(response.body);
      if (response.statusCode == 204) {
        emit(state.copyWith(
          loading: false,
          message: "Successfully deleted",
          isESuccess: true,
        ));
        callGetProfile();
      } else {
        var responseBody = jsonDecode(response.body);
        emit(state.copyWith(
          loading: false,
          message: responseBody['message'],
          isESuccess: false,
        ));
      }
    } catch (e) {
      log("ERROR == $e");
    }
  }

  callGetOtp(String email) async {
    try {
      String token = SharedPreferencesClass.prefs.getString(tOKEN) ?? "";

      const url = "$baseUrl$getOtp";
      final uri = Uri.parse(url);

      log("URL == $url");

      Map map = {"email": email};
      var reqBody = jsonEncode(map);
      log("REQBODY == $reqBody");

      var response = await http.post(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },body: reqBody);
      log(response.body);
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        SharedPreferencesClass.prefs.setString(oTPID, responseBody['otpId']);
        emit(state.copyWith(
            loading: false,
            message: responseBody['message'],
            isOtpSent: true));
      } else {
        emit(state.copyWith(
            loading: false,
            message: responseBody['message'],
            isOtpSent: false));
      }
    } catch (e) {
      log("ERROR == $e");
    }
  }

  callVerifyOtp(String email, String otp) async {
    try {
      String token = SharedPreferencesClass.prefs.getString(tOKEN) ?? "";
      String otpId = SharedPreferencesClass.prefs.getString(oTPID) ?? "";

      const url = "$baseUrl$verifyOtp";
      final uri = Uri.parse(url);

      log("URL == $url");

      Map map = {"email": email, "otpId":otpId, "otp": otp};
      var reqBody = jsonEncode(map);
      log("REQBODY == $reqBody");

      var response = await http.post(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },body: reqBody);
      log(response.body);
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        emit(state.copyWith(
            loading: false,
            message: responseBody['message'],
            isOtpSent: false,
            isOtpVerified: true));
      } else {
        emit(state.copyWith(
            loading: false,
            message: responseBody['message'],
            isOtpSent: false,
            isOtpVerified: true));
      }
    } catch (e) {
      log("ERROR == $e");
    }
  }

  callupdatePassword(String email, String password) async {
    try {
      String token = SharedPreferencesClass.prefs.getString(tOKEN) ?? "";

      const url = "$baseUrl$updatePassword";
      final uri = Uri.parse(url);

      log("URL == $url");

      Map map = {
  "email": email,
  "newPassword": password
};

      final reqBody = jsonEncode(map);

      log("REQUESTBODY == $reqBody");

      var response = await http.put(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },body: reqBody);
      log(response.body);
      if (response.statusCode == 204) {
        emit(state.copyWith(
          loading: false,
          message: "Successfully updated",
          isESuccess: true,
        ));
      } else {
        var responseBody = jsonDecode(response.body);
        emit(state.copyWith(
          loading: false,
          message: responseBody['message'],
          isESuccess: false,
        ));
      }
    } catch (e) {
      log("ERROR == $e");
    }
  }

  callImageUpload(String imagePath) async{
    try{
      String token = SharedPreferencesClass.prefs.getString(tOKEN) ?? "";
      String userId = SharedPreferencesClass.prefs.getString(uSERID) ?? "";

      final url = "$baseUrl$imageUpload$userId";
      final uri = Uri.parse(url);

      final request = http.MultipartRequest("POST",uri);

      request.headers['Authorization'] = "Bearer $token";
      request.headers['Content-Type'] = "multipart/form-data";

      request.files.add(await http.MultipartFile.fromPath("image", imagePath));

      var streamResponse = await request.send();

      var response = await http.Response.fromStream(streamResponse);
      var responseBody = jsonDecode(response.body);
  if (response.statusCode == 200) {
    SharedPreferencesClass.prefs.setString(iMAGE,responseBody['imagePath']);
    emit(state.copyWith(loading: false,isSuccess: true, message: responseBody['message']));
  } else {
    emit(state.copyWith(loading: false,isSuccess: true, message: responseBody['message']));
  }
    }catch(e){log("EROR == $e");}
  }

  addressList() {
    List<String> addressesList = [];
    if (_profileModel.data?.addresses?.isNotEmpty == true) {
      for (int index = 0;
          index < (_profileModel.data?.addresses?.length ?? 0);
          index++) {
        String houseNo = _profileModel.data?.addresses?[index].houseNo ?? "";
        String buildingNo =
            _profileModel.data?.addresses?[index].buildingNo ?? "";
        String district = _profileModel.data?.addresses?[index].district ?? "";
        String aState = _profileModel.data?.addresses?[index].state ?? "";
        String locality = _profileModel.data?.addresses?[index].locality ?? "";
        String landmark = _profileModel.data?.addresses?[index].landmark ?? "";
        addressesList.add(
            "# $houseNo, $buildingNo, $locality, $landmark, $district, $aState ");
      }
    }
    emit(state.copyWith(addressesList: addressesList));
  }
}
