import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_oven_frontend/profile/cubit/profile_cubit.dart';
import 'package:pizza_oven_frontend/utility/colors.dart';
import 'package:pizza_oven_frontend/utility/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.editSection,
    this.name,
    this.email,
    this.phoneNo,
    this.addId,
    this.addname,
    this.houseNo,
    this.buildingNo,
    this.locality,
    this.district,
    this.state,
    this.landmark,
  });

  final String editSection;
  final String? name;
  final String? email;
  final String? phoneNo;
  final String? addId;
  final String? addname;
  final String? houseNo;
  final String? buildingNo;
  final String? locality;
  final String? district;
  final String? state;
  final String? landmark;

  @override
  State<EditProfileScreen> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  TextEditingController addNameController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  TextEditingController buildingNumberController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();

  FocusNode newPasswordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  FocusNode otpNode = FocusNode();

  FocusNode addNameNode = FocusNode();
  FocusNode houseNoNode = FocusNode();
  FocusNode buidingnoNode = FocusNode();
  FocusNode localityNode = FocusNode();
  FocusNode districtNode = FocusNode();
  FocusNode stateNode = FocusNode();
  FocusNode landmarkNode = FocusNode();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name ?? "";
    emailController.text = widget.email ?? "";
    phoneNumberController.text = widget.phoneNo ?? "";

    if (widget.addId?.isNotEmpty == true || widget.addId != "") {
      addNameController.text = widget.addname ?? "";
      houseNumberController.text = widget.houseNo ?? "";
      buildingNumberController.text = widget.buildingNo ?? "";
      localityController.text = widget.locality ?? "";
      districtController.text = widget.district ?? "";
      stateController.text = widget.state ?? "";
      landmarkController.text = widget.landmark ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.isESuccess) {
          showCustomPopupOne(context, state.message, 'S', () {
            Navigator.pop(context);
            Navigator.pop(context, true);
          });
        } else if (state.isOtpSent) {
          showCustomPopupOne(context, state.message, 'S', () {
            Navigator.pop(context);
          });
        } else if (state.isOtpVerified) {
          showCustomPopupOne(context, state.message, 'S', () {
            Navigator.pop(context);
          });
        } else {
          showCustomPopupOne(context, state.message, 'E', () {
            Navigator.pop(context);
            Navigator.pop(context, false);
          });
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: backGroundTheme,
              appBar: AppBar(
                backgroundColor: backGroundTheme,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back_ios, color: iconColor, size: 25),
                ),
                title: Center(
                  child: Text("Edit Profile",
                      style: GoogleFonts.caveat(
                          color: textColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              body: widget.editSection == 'I'
                  ? infoSection()
                  : (widget.editSection == 'P'
                      ? passwordSection(state)
                      : addressSection()));
        },
      ),
    );
  }

  infoSection() {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              textFeild(
                  controller: nameController,
                  focusNode: nameNode,
                  head: "Name",
                  istext: true),
              textFeild(
                  controller: emailController,
                  focusNode: emailNode,
                  head: "Email",
                  istext: true),
              textFeild(
                  controller: phoneNumberController,
                  focusNode: phoneNumberNode,
                  head: "Phone Number",
                  istext: false),
            ]),
            //const Spacer(),
            GestureDetector(
              onTap: () {
                context.read<ProfileCubit>().callEditInfo(nameController.text,
                    emailController.text, phoneNumberController.text);
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(20)),
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text("Save",
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }

  passwordSection(ProfileState state) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              state.isOtpSent
                  ? const SizedBox()
                  : state.isOtpVerified
                      ? const SizedBox()
                      : textFeild(
                          controller: emailController,
                          focusNode: emailNode,
                          head: "Email ID",
                          read: true,
                          istext: true),
              state.isOtpVerified
                  ? textFeild(
                      controller: newPasswordController,
                      focusNode: newPasswordNode,
                      head: "New Password",
                      istext: true)
                  : const SizedBox(),
              state.isOtpVerified
                  ? textFeild(
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordNode,
                      head: "Confirm New Password",
                      istext: true)
                  : const SizedBox(),
              state.isOtpSent
                  ? textFeild(
                      controller: otpController,
                      focusNode: otpNode,
                      head: "OTP verfication",
                      istext: true)
                  : const SizedBox(),
            ]),
            //const Spacer(),
            GestureDetector(
              onTap: () {
                if (state.isOtpSent == false && state.isOtpVerified == false) {
                  context.read<ProfileCubit>().callGetOtp(widget.email ?? "");
                } else if (state.isOtpSent == true) {
                  context
                      .read<ProfileCubit>()
                      .callVerifyOtp(widget.email ?? "", otpController.text);
                } else if(state.isOtpVerified == true){
                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
                    showCustomPopupOne(
                        context,
                        "Password and confirm password does not match",
                        'E', () {
                      Navigator.pop(context);
                    });
                  } else {
                    context.read<ProfileCubit>().callupdatePassword(
                        widget.email ?? "", newPasswordController.text);
                  }
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(20)),
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                      state.isOtpSent
                          ? "Verify"
                          : (state.isOtpVerified ? "Save" : "Send OTP"),
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }

  addressSection() {
    return SingleChildScrollView(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              textFeild(
                  controller: addNameController,
                  focusNode: addNameNode,
                  head: "Address Name",
                  istext: true),
              textFeild(
                  controller: houseNumberController,
                  focusNode: houseNoNode,
                  head: "House Number",
                  istext: false),
              textFeild(
                  controller: buildingNumberController,
                  focusNode: buidingnoNode,
                  head: "Building Number",
                  istext: false),
              textFeild(
                  controller: localityController,
                  focusNode: localityNode,
                  head: "Locality",
                  istext: true),
              textFeild(
                  controller: districtController,
                  focusNode: districtNode,
                  head: "District",
                  istext: true),
              textFeild(
                  controller: stateController,
                  focusNode: stateNode,
                  head: "State",
                  istext: true),
              textFeild(
                  controller: landmarkController,
                  focusNode: landmarkNode,
                  head: "Landmark",
                  istext: true),
            ]),
            //const Spacer(),
            GestureDetector(
              onTap: () {
                if (widget.addId == null || widget.addId == "") {
                  context.read<ProfileCubit>().callAddAddress(
                      addNameController.text,
                      houseNumberController.text,
                      buildingNumberController.text,
                      localityController.text,
                      districtController.text,
                      stateController.text,
                      landmarkController.text);
                } else {
                  context.read<ProfileCubit>().callupdateAddress(
                      widget.addId ?? "",
                      addNameController.text,
                      houseNumberController.text,
                      buildingNumberController.text,
                      localityController.text,
                      districtController.text,
                      stateController.text,
                      landmarkController.text);
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(20)),
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text("Save",
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }

  textFeild(
      {required TextEditingController controller,
      required FocusNode focusNode,
      bool read = false,
      required String head,
      required bool istext}) {
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
            readOnly: read,
            maxLength: istext ? 255 : 10,
            keyboardType: istext ? TextInputType.text : TextInputType.number,
            decoration: InputDecoration(
                counterText: "",
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
}
