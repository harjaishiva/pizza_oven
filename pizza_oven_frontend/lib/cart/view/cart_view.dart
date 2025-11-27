import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_oven_frontend/cart/cubit/cart_cubit.dart';
import 'package:pizza_oven_frontend/checkout/cubit/checkout_cubit.dart';
import 'package:pizza_oven_frontend/checkout/view/checkout_view.dart';
import 'package:pizza_oven_frontend/utility/colors.dart';
import 'package:pizza_oven_frontend/utility/widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  final  List<int> _counter = [];
  bool firstTime = true;
  String subTotal = "";
  String tax = "";
  String total = "";

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().callCartData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if(firstTime && state.isSuccess){
          firstTime = false;
          for(int i = 0; i < (state.cartModel?.data?.length ?? 0); i++){
            _counter.add(state.cartModel?.data?[i].quantity ?? 1);
          }
        }
        List values = context.read<CartCubit>().cacultion();
        subTotal = values[0].toString();
        tax = values[1].toString();
        total = values[2].toString();
          return Scaffold(
            backgroundColor: backGroundTheme,
            appBar: AppBar(
                backgroundColor: backGroundTheme,
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child:
                        Icon(Icons.arrow_back_ios, color: iconColor, size: 25)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Cart",
                        style: GoogleFonts.caveat(
                            color: textColor,
                            fontSize: 25,
                            fontWeight: FontWeight.w800)),
                  ],
                )),
            body: state.loading ? loader() :
            (state.cartModel?.data?.isNotEmpty == true) ? Column(
              children: [upperSection(state),bottomSection()],
            ) : noData("Cart is Empty"),
          );
      },
    );
  }

  upperSection(CartState state) {
    return 
    // Column(
    //   children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.573,
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
                itemCount: state.cartModel?.data?.length,
                itemBuilder: (context, index) {
                  return listTile(state, index);
                }));

    //      GestureDetector(
    //               onTap: () {
    //                 Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                         builder: (_) => BlocProvider(
    //                             create: (_) => CheckoutCubit(),
    //                             child: const CheckOutScreen())));
    //               },
    //               child: Container(
    //                   decoration: BoxDecoration(
    //                       color: buttonColor,
    //                       borderRadius: BorderRadius.circular(10)),
    //                   height: 50,
    //                   width: 150,
    //                   alignment: Alignment.center,
    //                   child: Text("Place Order",
    //                       style: GoogleFonts.inter(
    //                           color: Colors.white,
    //                           fontSize: 20,
    //                           fontWeight: FontWeight.w700))),
    //             ),
    //   ],
    // );
  }

  listTile(CartState state, int index) {
    return Container(
      height: 130,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          markedCircle(state, index),
          const SizedBox(width: 15),
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(80)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Image.asset("images/splash.jpg"),
            ),
          ),
            
           Container(
            width: 200,
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.center,
              child: Column(
                children: [
                  Text(state.cartModel?.data?[index].name ?? "N/A",
                                        style: GoogleFonts.caveat(
                                            color: backGroundTheme,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,),
                  Text("₹ ${state.cartModel?.data?[index].totalPrice ?? "N/A"}",
                      style: GoogleFonts.inter(
                          color: buttonColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_counter[index] != 1) {
                                _counter[index]--;
                                context.read<CartCubit>().callupdateQuantity(state.cartModel?.data?[index].pizzaId.toString() ?? "", _counter[index].toString());
                              }
                            });
                          },
                          child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: const Color(0xffF9D9B5),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Icon(Icons.remove,
                                  color: backGroundTheme, size: 22)),
                        ),
                        const SizedBox(width: 15),
                        Text("${_counter[index]}",
                            style: GoogleFonts.inter(
                                color: buttonColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                                _counter[index]++;
                                
                            });
                            context.read<CartCubit>().callupdateQuantity(state.cartModel?.data?[index].pizzaId.toString() ?? "", _counter[index].toString());
                          },
                          child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: const Color(0xffF9D9B5),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Icon(Icons.add,
                                  color: backGroundTheme, size: 22)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  markedCircle(CartState state, int index) {
    return GestureDetector(
      onTap:(){
        context.read<CartCubit>().calldeleteFromCart(state.cartModel?.data?[index].pizzaId.toString() ?? "",state.cartModel?.data?[index].cartId.toString() ?? "" );
      },
      child: Container(
        alignment: Alignment.center,
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
                color: buttonColor, width: 5, style: BorderStyle.solid)),
        child: Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
                color: buttonColor, borderRadius: BorderRadius.circular(12))),
      ),
    );
  }

  bottomSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(50)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subtotal",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)),
                    Text("₹ $subTotal",
                        style: GoogleFonts.inter(
                            color: buttonColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Taxes",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)),
                    Text("₹ $tax",
                        style: GoogleFonts.inter(
                            color: buttonColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delivery",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)),
                    Text("₹ 10",
                        style: GoogleFonts.inter(
                            color: buttonColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xffF9D9B5),
            padding: const EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height * 0.13,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total",
                        style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)),
                    Text("₹ $total",
                        style: GoogleFonts.inter(
                            color: buttonColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BlocProvider(
                                create: (_) => CheckoutCubit(),
                                child: CheckOutScreen(subTotal: subTotal,tax: tax,total: total))));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(10)),
                      height: 50,
                      width: 150,
                      alignment: Alignment.center,
                      child: Text("Place Order",
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
