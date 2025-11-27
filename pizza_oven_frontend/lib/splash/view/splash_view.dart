import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_oven_frontend/home/cubit/home_cubit.dart';
import 'package:pizza_oven_frontend/home/view/home_view.dart';
import 'package:pizza_oven_frontend/sign_in/cubit/sign_in_cubit.dart';
import 'package:pizza_oven_frontend/sign_in/view/sign_in_view.dart';
import 'package:pizza_oven_frontend/splash/cubit/splash_cubit.dart';
import 'package:pizza_oven_frontend/utility/colors.dart';
import 'package:pizza_oven_frontend/utility/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    intialize(context);
  }

  intialize(BuildContext context) async {
    await SharedPreferencesClass.intializePrefs();
    if(context.mounted){
      context.read<SplashCubit>().callVerifyToken();
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if(state.isSuccess){
          Future.delayed(const Duration(seconds: 3),(){Navigator.push(context,MaterialPageRoute(builder: (_)=>BlocProvider(create: (_)=>HomeCubit(), child: const HomeScreen())));});
        }
        else{
          Future.delayed(const Duration(seconds: 3),(){Navigator.push(context,MaterialPageRoute(builder: (_)=>BlocProvider(create: (_)=>SignInCubit(), child: const SignInScreen())));});
        }
      },
      child: Scaffold(
        backgroundColor: backGroundTheme,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width * 0.5) - 125,
                  bottom: 20),
              child: SizedBox(
                  height: 250,
                  width: 250,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(250),
                      child: Image.asset('images/splash.jpg',
                          fit: BoxFit.contain))),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 100,
              ),
              child: Text(
                "Welcome to \nPizza Oven",
                style: GoogleFonts.caveat(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
