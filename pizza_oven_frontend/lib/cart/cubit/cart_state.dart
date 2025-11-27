part of 'cart_cubit.dart';

class CartState {
  const CartState({this.loading = true, this.message = "", this.isSuccess = false, this.cartModel});

  final bool loading;
  final String message;
  final bool isSuccess;
  final CartModel? cartModel;

  CartState copyWith(
    {bool? loading,
    String? message,
    bool? isSuccess,
    CartModel? cartModel}
  ){
    return CartState(
      loading: loading ?? this.loading,
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess,
      cartModel: cartModel ?? this.cartModel
          );
  }
}

class CartInitial extends CartState {}


