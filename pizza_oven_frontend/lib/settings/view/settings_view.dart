import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_oven_frontend/profile/cubit/profile_cubit.dart';
import 'package:pizza_oven_frontend/profile/view/profile_view.dart';
import 'package:pizza_oven_frontend/sign_in/cubit/sign_in_cubit.dart';
import 'package:pizza_oven_frontend/sign_in/view/sign_in_view.dart';
import 'package:pizza_oven_frontend/utility/colors.dart';
import 'package:pizza_oven_frontend/utility/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  List<String> options = ["My Profile", "Order History", "Favourites", "Cart", "Rate Us"];
  String image = "";

  @override
  void initState() {
    super.initState();
    image = SharedPreferencesClass.prefs.getString(iMAGE) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundTheme,
      appBar: AppBar(
        backgroundColor: backGroundTheme,
        leading: GestureDetector(
          onTap:(){
            Navigator.pop(context,true);
          },
          child: Icon(Icons.arrow_back_ios,color:iconColor, size: 25)
          ),
      ),

      body: Column(
        children:[
          circularImage(),
          optionList(),
          signOutButton()
        ],
      ),
    );
  }

  circularImage(){
    double imageSize = MediaQuery.of(context).size.height * 0.25;
    return Container(
      margin: EdgeInsets.only(left: (MediaQuery.of(context).size.width * 0.5) - ((MediaQuery.of(context).size.height * 0.25) * 0.9)),
      height: imageSize,
      width: imageSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(imageSize),
        child: image == "" ? Image.asset('images/splash.jpg') : Image.network(image)
        ),
    );
  }
  optionList(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.52,
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context,index){
          return GestureDetector(
            onTap:() async{
              if(index == 0){
                bool ret = await Navigator.push(context, MaterialPageRoute(builder:(_)=>BlocProvider(create: (_)=>ProfileCubit(), child: const ProfileScreen())));
                if(ret){setState((){image = SharedPreferencesClass.prefs.getString(iMAGE) ?? "";});}
              }
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal:20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(options[index],style: GoogleFonts.inter(color: backGroundTheme, fontSize: 20, fontWeight: FontWeight.w600)),
                  Icon(Icons.arrow_right, color: backGroundTheme, size: 40)
                ],
              )
            ),
          );
        }
        ),
    );
  }
  signOutButton(){
    return GestureDetector(
      onTap:(){
        SharedPreferencesClass.prefs.setString(tOKEN, "");
        SharedPreferencesClass.prefs.setString(uSERID, "");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => BlocProvider(create: (_)=>SignInCubit(),child: const SignInScreen()),), (route)=>false);
      },
      child: Container(
        height: 60,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sign Out",style: GoogleFonts.inter(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(width:20),
            const Icon(Icons.logout,color: Colors.red),
          ],
        ),
      ),
    );
  }
}