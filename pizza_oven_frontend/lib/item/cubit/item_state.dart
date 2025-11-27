part of 'item_cubit.dart';

class ItemState {
  const ItemState({this.loading = true,this.sLoading = false, this.message = "", this.isSuccess = false, this.isSuccessC = false, this.isLiked = false, this.itemModel,this.ingredients});

  final bool loading;
  final bool sLoading;
  final String message;
  final bool isSuccess;
  final bool isSuccessC;
  final bool isLiked;
  final ItemModel? itemModel;
  final List<String>? ingredients;

  ItemState copyWith(
    {bool? loading,
    bool? sLoading,
    String? message,
    bool? isSuccess,
    bool? isSuccessC,
    bool? isLiked,
    ItemModel? itemModel,
    List<String>? ingredients}
  ){
    return ItemState(
      loading: loading ?? this.loading,
      sLoading: sLoading ?? this.sLoading,
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess,
      isSuccessC: isSuccessC ?? this.isSuccessC,
      isLiked: isLiked ?? this.isLiked,
      itemModel: itemModel ?? this.itemModel,
      ingredients: ingredients ?? this.ingredients
          );
  }
}

class ItemInitial extends ItemState {}


