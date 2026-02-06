part of 'favourite_cubit.dart';

class FavouriteState {
  FavouriteState({this.isLoading = true, this.success = false, this.message = "", this.favouriteModel});

  bool isLoading;
  bool success;
  String message;
  FavouriteModel? favouriteModel;

  FavouriteState copyWith({
    bool? isLoading,
    bool? success,
    String? message,
    FavouriteModel? favouriteModel
  }){
    return FavouriteState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      message: message ?? this.message,
      favouriteModel: favouriteModel ?? this.favouriteModel
    );
  }
}

class FavouriteInitial extends FavouriteState {}


