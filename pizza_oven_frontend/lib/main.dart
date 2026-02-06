import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_oven_frontend/splash/cubit/splash_cubit.dart';
import 'package:pizza_oven_frontend/splash/view/splash_view.dart';
import 'package:pizza_oven_frontend/utility/shared_preferences.dart';
import 'package:pizza_oven_frontend/utility/sqflite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesClass.intializePrefs();
  await AppDataBase.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
      BlocProvider(
        create: (context) => SplashCubit(),
        child: const SplashScreen(),
      )
    );
  }
}