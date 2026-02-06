import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_oven_frontend/favourite/favourite_cubit/favourite_cubit.dart';
import 'package:pizza_oven_frontend/item/cubit/item_cubit.dart';
import 'package:pizza_oven_frontend/item/view/item_view.dart';
import 'package:pizza_oven_frontend/utility/colors.dart';
import 'package:pizza_oven_frontend/utility/widgets.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavouriteCubit>().getFavourites();
  }

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: backGroundTheme,
            appBar: AppBar(
              backgroundColor: backGroundTheme,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: iconColor,
                  )),
              title: Text("Favourites",
                  style: GoogleFonts.caveat(
                      color: textColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w800)),
              centerTitle: true,
            ),
            body:BlocBuilder<FavouriteCubit, FavouriteState>(
              builder:(context, state){
                return  state.isLoading ? loader() :
             (state.favouriteModel?.data?.isEmpty == true || state.favouriteModel?.data == null)? noData("No Favourites") : Container(child: grid());
              }
            ),
          );
  }

  grid() {
    return BlocBuilder<FavouriteCubit, FavouriteState>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
              itemCount: state.favouriteModel?.data?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.7),
              itemBuilder: (context, index) {
                int weight = state.favouriteModel?.data?[index].weight ?? 0;
                int price = state.favouriteModel?.data?[index].price ?? 0;
                return GestureDetector(
                  onTap: () async{
                    var ret = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                create: (_) => ItemCubit(),
                                child: ItemScreen(itemId:state.favouriteModel?.data?[index].id.toString() ?? "0"))));

                                if(ret != null && ret == true){
                                  // ignore: use_build_context_synchronously
                                  context.read<FavouriteCubit>().getFavourites();
                                }
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
                          width: (MediaQuery.of(context).size.width * 0.5) - 20,
                          margin: const EdgeInsets.only(top: 70),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 50),
                                Text(
                                  state.favouriteModel?.data?[index].name ?? "N/A",
                                  style: GoogleFonts.caveat(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                                      //context.read<HomeCubit>().filter();
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
