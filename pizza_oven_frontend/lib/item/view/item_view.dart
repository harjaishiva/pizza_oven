import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_oven_frontend/cart/cubit/cart_cubit.dart';
import 'package:pizza_oven_frontend/cart/view/cart_view.dart';
import 'package:pizza_oven_frontend/home/cubit/home_cubit.dart';
import 'package:pizza_oven_frontend/home/view/home_view.dart';
import 'package:pizza_oven_frontend/item/cubit/item_cubit.dart';
import 'package:pizza_oven_frontend/utility/colors.dart';
import 'package:pizza_oven_frontend/utility/dotted_line.dart';
import 'package:pizza_oven_frontend/utility/widgets.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({required this.itemId, super.key});

  final String itemId;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  int _counter = 1;
  bool isSmall = false;
  bool isMedium = true;
  bool isLarge = false;

  @override
  void initState() {
    super.initState();
    context.read<ItemCubit>().callItemdata(widget.itemId);
  }

  List<bool> selectedIng = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemCubit, ItemState>(
      listener: (context, state) {
        if (state.isSuccessC) {
          showCustomPopupTwo(context, state.message, 'Home', "Cart", () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider(
                    create: (_) => HomeCubit(), child: const HomeScreen())));
          }, () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider(
                    create: (_) => CartCubit(), child: const CartScreen())));
          });
        }
      },
      builder: (context, state) {
        return Stack(
          children:[
             Scaffold(
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
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                      create: (_) => CartCubit(),
                                      child: const CartScreen())));
                        },
                        child: Icon(Icons.shopping_cart,
                            color: iconColor, size: 25)),
                  ],
                )),
            body: state.loading
                ? loader()
                : 
                (state.itemModel?.data?.id == null || (state.itemModel?.data?.id ?? 0) <= 0) ?
                noData("No data found") :
                Column(
                    children: [
                      upperScreen(),
                      mediumSection(state),
                      bottomBar(state),
                    ],
                  ),
          ),
    if (state.sLoading)
      Positioned.fill(
        child: IgnorePointer(
          ignoring: true,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: CircularProgressIndicator(
                  color: buttonColor,
                  strokeWidth: 4,
                ),
              ),
            ),
          ),
        ),
      ),

          
          ]
        );
      },
    );
  }

  upperScreen() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.42,
      child: DeferredPointerHandler(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 600,
              width: 500,
              child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 20),
                height: 300,
                width: 300,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(300),
                    child: Image.asset('images/splash.jpg')),
              ),
            ),
            const Positioned(
              bottom: 0,
              left: 40,
              child: CustomPaint(
                size: Size(250, 250),
                painter: DottedCurveLine(
                    initialXPoint: 0.07,
                    initialYPoint: 0.54,
                    curveXPoint: -0.1,
                    curveYPoint: 0.85,
                    endXPoint: 0.545,
                    endYPoint: 0.78),
              ),
            ),
            const Positioned(
              bottom: -20,
              child: CustomPaint(
                size: Size(250, 250),
                painter: DottedCurveLine(
                    initialXPoint: 0.5,
                    initialYPoint: 0.68,
                    curveXPoint: 1.2,
                    curveYPoint: 0.5,
                    endXPoint: 1.12,
                    endYPoint: 0.72),
              ),
            ),
            Positioned(
              left: 30,
              bottom: 100,
              child: DeferPointer(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSmall = true;
                      isMedium = false;
                      isLarge = false;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: isSmall ? buttonColor : Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('S',
                          style: GoogleFonts.caveat(
                            color: isSmall ? Colors.white : backGroundTheme,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ))),
                ),
              ),
            ),
            Positioned(
              left: 180,
              bottom: 40,
              child: DeferPointer(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSmall = false;
                      isMedium = true;
                      isLarge = false;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: isMedium ? buttonColor : Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('M',
                          style: GoogleFonts.caveat(
                            color: isMedium ? Colors.white : backGroundTheme,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ))),
                ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: 10,
              child: DeferPointer(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSmall = false;
                      isMedium = false;
                      isLarge = true;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: isLarge ? buttonColor : Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('L',
                          style: GoogleFonts.caveat(
                            color: isLarge ? Colors.white : backGroundTheme,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ))),
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: -10,
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 35,
                width: 100,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 242, 177, 112),
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.favorite_border,
                        color: Colors.red, size: 30),
                    Text("20K",
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  mediumSection(ItemState state) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.375,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  state.itemModel?.data?.name ?? "N/A",
                  style: GoogleFonts.caveat(
                      color: textColor,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      context
                          .read<ItemCubit>()
                          .callupdatefavourite(widget.itemId);
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: state.isLiked ? buttonColor : backGroundTheme,
                          borderRadius: BorderRadius.circular(50)),
                      height: 50,
                      width: 50,
                      child: Icon(Icons.favorite_outline,
                          color: state.isLiked ? Colors.white : buttonColor,
                          size: 35)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.itemModel?.data?.description ?? "N/A",
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    const Divider(thickness: 3),
                    Text("Ingredients",
                        style: GoogleFonts.caveat(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                        spacing: 7,
                        runSpacing: 10,
                        direction: Axis.horizontal,
                        children: ingredient(state.ingredients ?? [])),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ingredient(List<String> ingList) {
    List<Widget> ing = [];
    for (int i = 0; i < ingList.length; i++) {
      Widget item = FilterChip(
        side:
            BorderSide(color: buttonColor, width: 2, style: BorderStyle.solid),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: buttonColor,
        label: Text(ingList[i],
            style: GoogleFonts.inter(
                color: backGroundTheme,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        onSelected: (bool selected) {},
      );
      ing.add(item);
    }
    return ing;
  }

  bottomBar(ItemState state) {
    int price = state.itemModel?.data?.price ?? 0;
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("₹ ${isSmall ? price - 20 : (isLarge ? price + 20 : price)}",
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 25)),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                  alignment: Alignment.center,
                  height: 35,
                  width: 130,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 195, 150),
                      borderRadius: BorderRadius.circular(35)),
                  child: Text("$_counter",
                      style: GoogleFonts.inter(
                          color: backGroundTheme,
                          fontSize: 25,
                          fontWeight: FontWeight.w500))),
              Positioned(
                left: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_counter != 1) {
                        _counter--;
                      }
                    });
                  },
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35)),
                      child:
                          Icon(Icons.remove, color: backGroundTheme, size: 22)),
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _counter++;
                    });
                  },
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35)),
                      child: Icon(Icons.add, color: backGroundTheme, size: 22)),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              context.read<ItemCubit>().callAddToCart(
                  pizzaId: widget.itemId,
                  size: isSmall ? 'S' : (isMedium ? 'M' : 'L'),
                  quantity: _counter.toString());
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 35,
              width: 100,
              child: Text("Add cart",
                  style: GoogleFonts.inter(
                      color: backGroundTheme,
                      fontWeight: FontWeight.w600,
                      fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
