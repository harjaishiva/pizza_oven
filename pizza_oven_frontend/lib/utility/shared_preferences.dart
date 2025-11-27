import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClass{
  static late SharedPreferences prefs;
  static intializePrefs() async{
    prefs = await SharedPreferences.getInstance();
  }
}

const tOKEN = "token";
const uSERID = "userid";
const oTPID = "otpid";
const iMAGE = "image";