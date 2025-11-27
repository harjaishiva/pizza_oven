import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_oven_frontend/cart/cubit/cart_cubit.dart';
import 'package:pizza_oven_frontend/cart/view/cart_view.dart';
import 'package:pizza_oven_frontend/home/cubit/home_cubit.dart';
import 'package:pizza_oven_frontend/home/model/home_model.dart';
import 'package:pizza_oven_frontend/item/cubit/item_cubit.dart';
import 'package:pizza_oven_frontend/item/view/item_view.dart';
import 'package:pizza_oven_frontend/settings/cubit/settings_cubit.dart';
import 'package:pizza_oven_frontend/settings/view/settings_view.dart';
import 'package:pizza_oven_frontend/utility/colors.dart';
import 'package:pizza_oven_frontend/utility/shared_preferences.dart';
import 'package:pizza_oven_frontend/utility/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String image = "";

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().callHomeData();
    image = SharedPreferencesClass.prefs.getString(iMAGE) ?? "";
  }

  final List<String> options = [
    "All",
    "High to Low",
    "Veg",
    "Non-Veg"  ];
  final List<bool> selected = [true, false, false, false];


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: backGroundTheme,
          appBar: AppBar(
              leadingWidth: 50,
              backgroundColor: backGroundTheme,
              leading:
                  meSection(), //const Icon(Icons.menu, color: Color(0xffDB9147), size: 25),
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
              (state.homeModel?.data?.isEmpty == true) ?
              noData("No data found") :
              Column(
                  children: [searchBar(), filterList(), grid()],
                ),
        );
      },
    );
  }

  meSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 10, top: 10),
      child: GestureDetector(
        onTap: () async {
          bool ret = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BlocProvider(
                    create: (_) => SettingsCubit(),
                    child: const SettingsScreen())),
          );

          if(ret){
            setState((){image = SharedPreferencesClass.prefs.getString(iMAGE) ?? "";});
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: image == "" ? Image.asset(
            'images/splash.jpg',
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          ) : Image.network(image),
        ),
      ),
    );
  }

  searchBar() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: searchBarColor, borderRadius: BorderRadius.circular(15)),
        height: 45,
        width: MediaQuery.of(context).size.width - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, color: Colors.white, size: 25),
            const SizedBox(width: 5),
            Text("Search...",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                )),
          ],
        ),
      ),
    );
  }

  filterList() {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          filterListTile(0),
          filterListTile(1),
          filterListTile(2),
          filterListTile(3),
        ],
      ),
    );
  }

  filterListTile(int index){
    return GestureDetector(
            onTap: () {
              
              for (int i = 0; i < selected.length; i++) {
                setState(() {
                  if (i == index) {
                    selected[i] = !selected[i];
                  } else {
                    selected[i] = false;
                  }
                });
              }
            },

            child: Padding(
              padding:
                  const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: selected[index] ? buttonColor : searchBarColor,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 8, bottom: 10),
                alignment: Alignment.center,
                child: Text(options[index],
                    style: GoogleFonts.inter(
                        color: selected[index] ? Colors.white : textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18)),
              ),
            ),
          );
  }

  grid() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        List<Data>? data = selected[0] ? state.homeModel?.data : (selected[1] ? state.lowToHigh : (selected[2] ? state.veg : state.nonVeg));
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.72,
            child: GridView.builder(
                itemCount: data?.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.7),
                itemBuilder: (context, index) {
                  int weight = data?[index].weight ?? 0;
                  int price = data?[index].price ?? 0;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                  create: (_) => ItemCubit(),
                                  child: ItemScreen(itemId:data?[index].id.toString() ?? "0"))));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: searchBarColor,
                                borderRadius: BorderRadius.circular(40)),
                            height: MediaQuery.of(context).size.height * 0.25,
                            width:
                                (MediaQuery.of(context).size.width * 0.5) - 20,
                            margin: const EdgeInsets.only(top: 70),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 50),
                                  Text(data?[index].name ?? "N/A",
                                      style: GoogleFonts.caveat(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,),
                                  Text("$weight g",
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                  Text("₹ $price",
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16)),
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                      onTap: () {
                                        context.read<HomeCubit>().filter();
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: buttonColor,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          height: 30,
                                          width: 120,
                                          child: Text("Add to cart",
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16))))
                                ]),
                          ),
                          Positioned(
                            left: 28,
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(120)),
                                height: 130,
                                width: 130,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(130),
                                    child: Image.asset('images/splash.jpg',
                                        height: 130, width: 130))),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
      },
    );
  }
}
