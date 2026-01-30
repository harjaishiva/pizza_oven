import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pizza_oven_frontend/profile/cubit/profile_cubit.dart';
import 'package:pizza_oven_frontend/profile/view/edit_profile_view.dart';
import 'package:pizza_oven_frontend/utility/colors.dart';
import 'package:pizza_oven_frontend/utility/shared_preferences.dart';
import 'package:pizza_oven_frontend/utility/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  bool visible = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().callGetProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: backGroundTheme,
              body: state.loading
                  ? loader()
                  : Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.15),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          infoSection(state),
                          Positioned(
                            top: -MediaQuery.of(context).size.height * 0.13,
                            left: MediaQuery.of(context).size.width -
                                (MediaQuery.of(context).size.width * 0.75),
                            child: circularImage(),
                          ),
                          Positioned(
                            top: 20,
                            left: 40,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context,true);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: iconColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        );
      },
    );
  }

  circularImage() {
    String limage = SharedPreferencesClass.prefs.getString(iMAGE) ?? "";
    double imageSize = MediaQuery.of(context).size.height * 0.2;
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width * 0.5) -
                ((MediaQuery.of(context).size.height * 0.25) * 0.9)),
        height: imageSize,
        width: imageSize,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(imageSize),
            child: (image != null && (image?.path.isNotEmpty ?? false))
                ? Image.file(image!)
                : (limage == "") ? Image.asset('images/splash.jpg') : Image.network(limage)),
      ),
      Positioned(
        bottom: 0,
        right: 10,
        child: GestureDetector(
          onTap: () async {
            try {
              ImagePicker picker = ImagePicker();
              XFile? imageFile =
                  await picker.pickImage(source: ImageSource.gallery);
              setState(() {
                image = File(imageFile?.path ?? '');
              });
              // ignore: use_build_context_synchronously
              context.read<ProfileCubit>().callImageUpload(imageFile?.path ?? "");
            } catch (e) {
              log("EXCEPTION OF IMAGE PICKER == $e");
            }
          },
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(50)),
              height: 50,
              width: 50,
              child: const Icon(Icons.edit, color: Colors.white, size: 30)),
        ),
      ),
    ]);
  }

  infoSection(ProfileState state) {
    return Container(
      decoration: BoxDecoration(
          color: cardColor, borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          personalInfo(state),
          const SizedBox(height: 15),
          passwordInfo(state),
          const SizedBox(height: 15),
          addressInfo(state)
        ],
      ),
    );
  }

  personalInfo(ProfileState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        style: BorderStyle.solid,
      )),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Name",
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            Text(state.profileModel?.data?.user?.name ?? "N/A",
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        Divider(
          color: buttonColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Email",
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(
              width: 130,
            ),
            Expanded(
              child: Text(
                state.profileModel?.data?.user?.email ?? "N/A",
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                softWrap: true,
                maxLines: 2,
              ),
            ),
          ],
        ),
        Divider(
          color: buttonColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Phone No.",
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            Text(state.profileModel?.data?.user?.phoneNumber ?? "N/A",
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        Divider(
          color: buttonColor,
        ),
        GestureDetector(
          onTap: () async {
            var ret = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BlocProvider(
                        create: (_) => ProfileCubit(),
                        child: EditProfileScreen(
                            editSection: 'I',
                            name: state.profileModel?.data?.user?.name ?? "N/A",
                            email:
                                state.profileModel?.data?.user?.email ?? "N/A",
                            phoneNo:
                                state.profileModel?.data?.user?.phoneNumber ??
                                    "N/A"))));
            if (ret != null  && ret == true) {
              // ignore: use_build_context_synchronously
              context.read<ProfileCubit>().callGetProfile();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Edit",
                  style: GoogleFonts.inter(
                      color: backGroundTheme,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Icon(Icons.edit, color: iconColor, size: 20),
            ],
          ),
        ),
      ]),
    );
  }

  passwordInfo(ProfileState state) {
    int len = state.profileModel?.data?.user?.password?.length ?? 1;
    String hide = "";
    for (int i = 0; i < len; i++) {
      hide += "*";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        style: BorderStyle.solid,
      )),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Password",
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    visible
                        ? state.profileModel?.data?.user?.password ?? "N/A"
                        : hide,
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        visible = !visible;
                      });
                    },
                    child: Icon(
                        visible ? Icons.visibility : Icons.visibility_off,
                        color: buttonColor)),
              ],
            ),
          ],
        ),
        Divider(
          color: buttonColor,
        ),
        GestureDetector(
          onTap: () async {
            var ret = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BlocProvider(
                        create: (_) => ProfileCubit(),
                        child: EditProfileScreen(editSection: 'P', email: state.profileModel?.data?.user?.email))));

            if (ret != null  && ret == true) {
              // ignore: use_build_context_synchronously
              context.read<ProfileCubit>().callGetProfile();
            }
          },
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Change Password",
                  style: GoogleFonts.inter(
                      color: backGroundTheme,
                      fontSize: 14,
                      fontWeight: FontWeight.bold))),
        ),
      ]),
    );
  }

  addressInfo(ProfileState state) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.27),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        style: BorderStyle.solid,
      )),
      child: Column(children: [
        Text("Addresses",
            style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        Divider(
          color: buttonColor,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.139,
          child: addressList(state),
        ),
        Divider(
          color: buttonColor,
        ),
        GestureDetector(
          onTap: () async {
            var ret = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BlocProvider(
                        create: (_) => ProfileCubit(),
                        child: const EditProfileScreen(editSection: 'A'))));

            if (ret != null  && ret == true) {
              // ignore: use_build_context_synchronously
              context.read<ProfileCubit>().callGetProfile();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.add, color: iconColor, size: 20),
              Text("Add new address",
                  style: GoogleFonts.inter(
                      color: backGroundTheme,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ]),
    );
  }

  addressList(ProfileState state) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: state.profileModel?.data?.addresses?.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.profileModel?.data?.addresses?[index].addName ??
                              "N/A",
                          style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  var ret = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                              create: (_) => ProfileCubit(),
                                              child: EditProfileScreen(
                                                editSection: 'A',
                                                addId: state
                                                        .profileModel
                                                        ?.data
                                                        ?.addresses?[index]
                                                        .addId
                                                        .toString() ??
                                                    "",
                                                addname: state
                                                        .profileModel
                                                        ?.data
                                                        ?.addresses?[index]
                                                        .addName
                                                        .toString() ??
                                                    "",
                                                houseNo: state
                                                        .profileModel
                                                        ?.data
                                                        ?.addresses?[index]
                                                        .houseNo
                                                        .toString() ??
                                                    "",
                                                buildingNo: state
                                                        .profileModel
                                                        ?.data
                                                        ?.addresses?[index]
                                                        .buildingNo
                                                        .toString() ??
                                                    "",
                                                locality: state
                                                        .profileModel
                                                        ?.data
                                                        ?.addresses?[index]
                                                        .locality
                                                        .toString() ??
                                                    "",
                                                district: state
                                                        .profileModel
                                                        ?.data
                                                        ?.addresses?[index]
                                                        .district
                                                        .toString() ??
                                                    "",
                                                state: state
                                                        .profileModel
                                                        ?.data
                                                        ?.addresses?[index]
                                                        .state
                                                        .toString() ??
                                                    "",
                                                landmark: state
                                                        .profileModel
                                                        ?.data
                                                        ?.addresses?[index]
                                                        .landmark
                                                        .toString() ??
                                                    "",
                                              ))));

                                  if (ret != null  && ret == true) {
                                    // ignore: use_build_context_synchronously
                                    context
                                        .read<ProfileCubit>()
                                        .callGetProfile();
                                  }
                                },
                                child: Icon(Icons.edit, color: buttonColor)),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () {
                                  context
                                      .read<ProfileCubit>()
                                      .calldeleteAddress(
                                        state.profileModel?.data
                                                ?.addresses?[index].addId
                                                .toString() ??
                                            "",
                                        state.profileModel?.data
                                                ?.addresses?[index].addName
                                                .toString() ??
                                            "",
                                      );
                                },
                                child: Icon(Icons.delete, color: buttonColor)),
                          ],
                        ),
                      ],
                    ),
                    Text(state.addressesList?[index] ?? "N/A",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              index != 5
                  ? Divider(
                      color: buttonColor,
                    )
                  : const SizedBox(),
            ],
          );
        });
  }
}
