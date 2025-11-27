part of 'home_cubit.dart';

class HomeState {
  const HomeState({this.loading = true, this.message = "", this.isSuccess = false, this.homeModel, this.veg, this.nonVeg, this.cheese, this.lowToHigh});

  final bool loading;
  final String message;
  final bool isSuccess;
  final HomeModel? homeModel;
  final List<Data>? veg;
  final List<Data>? nonVeg;
  final List<Data>? lowToHigh;
  final List<Data>? cheese;

  HomeState copyWith(
    {bool? loading,
    String? message,
    bool? isSuccess,
    HomeModel? homeModel,
    List<Data>? veg,
    List<Data>? nonVeg,
    List<Data>? cheese,
    List<Data>? lowToHigh}
  ){
    return HomeState(
      loading: loading ?? this.loading,
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess,
      homeModel: homeModel ?? this.homeModel,
      veg: veg ?? this.veg,
      nonVeg: nonVeg ?? this.nonVeg,
      cheese: cheese ?? this.cheese,
      lowToHigh: lowToHigh?? this.lowToHigh
          );
  }
}

class HomeInitial extends HomeState {}


