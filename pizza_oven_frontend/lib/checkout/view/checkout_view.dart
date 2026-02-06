import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_oven_frontend/checkout/cubit/checkout_cubit.dart';
import 'package:pizza_oven_frontend/home/cubit/home_cubit.dart';
import 'package:pizza_oven_frontend/home/view/home_view.dart';
import 'package:pizza_oven_frontend/profile/cubit/profile_cubit.dart';
import 'package:pizza_oven_frontend/profile/view/edit_profile_view.dart';
import 'package:pizza_oven_frontend/utility/colors.dart';
import 'package:pizza_oven_frontend/utility/widgets.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen(
      {super.key,
      required this.subTotal,
      required this.tax,
      required this.total});

  final String subTotal;
  final String tax;
  final String total;

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenStateState();
}

class _CheckOutScreenStateState extends State<CheckOutScreen> {
  List<bool> selected = [true, false, false, false];
  bool cash = false;

  @override
  void initState() {
    super.initState();
    context.read<CheckoutCubit>().callgetAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundTheme,
      appBar: AppBar(
          backgroundColor: backGroundTheme,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: iconColor, size: 25)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Checkout",
                  style: GoogleFonts.caveat(
                      color: textColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w800)),
            ],
          )),
      body: BlocBuilder<CheckoutCubit, CheckoutState>(
        builder: (context, state) {
          return state.loading
              ? loader()
              : Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Shipping to :",
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                          (state.addressModel?.addresses?.isNotEmpty ?? false)
                              ? GestureDetector(
                                onTap:() async {
                                  var ret = await Navigator.push(context,MaterialPageRoute(builder: (_)=>BlocProvider(create: (_)=>ProfileCubit(),child:const EditProfileScreen(editSection: "A"))));
                                  if(ret != null && ret == true){
                                    // ignore: use_build_context_synchronously
                                    context.read<CheckoutCubit>().callgetAddress();
                                  }
                                },
                                child: Row(
                                    children: [
                                      const Icon(Icons.add,
                                          color: Colors.white,
                                          weight: 40,
                                          size: 30),
                                      Text("New",
                                          style: GoogleFonts.actor(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                              )
                              : const SizedBox(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      addressSection(state),
                      const SizedBox(height: 30),
                      billSection(),
                      const SizedBox(height: 30),
                      paymentSection(),
                      const SizedBox(height: 30),
                      endSection(state)
                    ],
                  ),
                );
        },
      ),
    );
  }

  addressSection(CheckoutState state) {
    return (state.addressModel?.addresses?.isEmpty ?? true)
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            height: 50,
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: buttonColor, borderRadius: BorderRadius.circular(10)),
            child: Text("+ Add address",
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.addressModel?.addresses?.length,
                itemBuilder: (context, index) {
                  String houseNo =
                      state.addressModel?.addresses?[index].houseNo ?? "";
                  String buildingNo =
                      state.addressModel?.addresses?[index].buildingNo ?? "";
                  String district =
                      state.addressModel?.addresses?[index].district ?? "";
                  String aState =
                      state.addressModel?.addresses?[index].state ?? "";
                  String locality =
                      state.addressModel?.addresses?[index].locality ?? "";
                  String landmark =
                      state.addressModel?.addresses?[index].landmark ?? "";
                  String address =
                      "# $houseNo, $buildingNo, $locality, $landmark, $district, $aState ";
                  return GestureDetector(
                    onTap: () {
                      for (int i = 0; i < selected.length; i++) {
                        setState(() {
                          if (i == index) {
                            selected[i] = true;
                          } else {
                            selected[i] = false;
                          }
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                          color: selected[index] ? Colors.orange : Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      height: 100,
                      width: 180,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                state.addressModel?.addresses?[index]
                                        .addressName ??
                                    "N/A",
                                style: GoogleFonts.caveat(
                                    color: selected[index]
                                        ? Colors.white
                                        : Colors.orange,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                address,
                                style: GoogleFonts.inter(
                                    color: selected[index]
                                        ? Colors.white
                                        : Colors.orange,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                maxLines: 4,
                                overflow: TextOverflow.clip,
                              )),
                        ],
                      ),
                    ),
                  );
                }),
          );
  }

  billSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      height: MediaQuery.of(context).size.height * 0.16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sub Total :",
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                Text("₹ ${widget.subTotal}",
                    style: GoogleFonts.inter(
                        color: Colors.orange,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Taxes :",
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                Text("₹ ${widget.tax}",
                    style: GoogleFonts.inter(
                        color: Colors.orange,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delivery :",
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                Text(r"₹ 10",
                    style: GoogleFonts.inter(
                        color: Colors.orange,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  paymentSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text("Payment :",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    cash = false;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: cash ? Colors.white : buttonColor,
                      borderRadius: BorderRadius.circular(15)),
                  height: 50,
                  width: 170,
                  child: Text("Pay Online",
                      style: GoogleFonts.inter(
                          color: cash ? Colors.black : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    cash = true;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: cash ? buttonColor : Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  height: 50,
                  width: 170,
                  child: Text("COD",
                      style: GoogleFonts.inter(
                          color: cash ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  endSection(CheckoutState state) {
    return SizedBox(
      height: (state.addressModel?.addresses?.isEmpty ?? true)
          ? MediaQuery.of(context).size.height * 0.25
          : MediaQuery.of(context).size.height * 0.15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            height: 50,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 254, 228, 189),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Payable :",
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                Text("₹ ${widget.total}",
                    style: GoogleFonts.inter(
                        color: buttonColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          (state.addressModel?.addresses?.isEmpty ?? true)
              ? const Spacer()
              : const SizedBox(),
          GestureDetector(
            onTap: () async {
              bool clear = await context.read<CheckoutCubit>().clearCart();
              if(clear){
                // ignore: use_build_context_synchronously
                showCustomPopupOne(context, "Order is Placed", 'S', () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => BlocProvider(
                            create: (_) => HomeCubit(),
                            child: const HomeScreen())),
                    (route) => false);
              });
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(10)),
              child: Text("Place Order",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
