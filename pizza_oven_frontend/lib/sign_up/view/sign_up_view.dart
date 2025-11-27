import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_oven_frontend/sign_in/cubit/sign_in_cubit.dart';
import 'package:pizza_oven_frontend/sign_in/view/sign_in_view.dart';
import 'package:pizza_oven_frontend/sign_up/cubit/sign_up_cubit.dart';
import 'package:pizza_oven_frontend/utility/colors.dart';
import 'package:pizza_oven_frontend/utility/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode nameNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.isSuccess) {
          showCustomPopupOne(context, state.message, 'S', (){Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider(
                      create: (_) => SignInCubit(),
                      child: const SignInScreen())));});
        } else {
          showCustomPopupOne(context, state.message, 'E', (){Navigator.pop(context);});
        }
      },
      child: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
            return Scaffold(
              backgroundColor: backGroundTheme,
              body: state.loading ? loader() :
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: (MediaQuery.of(context).size.width * 0.5) - 185,
                          bottom: 20),
                      child: SizedBox(
                          height: 250,
                          width: 250,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(250),
                              child: Image.asset('images/splash.jpg',
                                  fit: BoxFit.contain))),
                    ),
                    Text("Register",
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 40)),
                    textFeild(
                        controller: nameController,
                        focusNode: nameNode,
                        head: "Name"),
                    textFeild(
                        controller: emailController,
                        focusNode: emailNode,
                        head: "Email"),
                    textFeild(
                        controller: passwordController,
                        focusNode: passwordNode,
                        head: "Password"),
                    const SizedBox(height: 20),
                    signUpButton(context),
                    const SizedBox(height: 20),
                    alreadyHaveAccount()
                  ],
                ),
              ),
            );
        },
      ),
    );
  }

  textFeild(
      {required TextEditingController controller,
      required FocusNode focusNode,
      required String head}) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.only(left: 30),
            alignment: Alignment.topLeft,
            child: Text(head,
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 22))),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width - 20,
          padding: const EdgeInsets.only(top: 5, left: 10, bottom: 10),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
                filled: true,
                fillColor: textFeildColor,
                hoverColor: textFeildColor,
                focusColor: textFeildColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none)),
          ),
        ),
      ],
    );
  }

  signUpButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<SignUpCubit>().callSignUp(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text);
      },
      child: Container(
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(50)),
        height: 50,
        width: 200,
        alignment: Alignment.center,
        child: Text("Submit",
            style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 22)),
      ),
    );
  }

  alreadyHaveAccount() {
    return Column(
      children: [
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width - 20,
          color: Colors.white,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 5,
              right: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Already registered? ",
                    style:
                        GoogleFonts.inter(color: Colors.white, fontSize: 16)),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                  create: (_) => SignInCubit(),
                                  child: const SignInScreen())));
                    },
                    child: Text("Login",
                        style:
                            GoogleFonts.inter(color: textColor, fontSize: 16))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
