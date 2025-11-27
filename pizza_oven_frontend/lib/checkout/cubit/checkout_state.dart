part of 'checkout_cubit.dart';

class CheckoutState {
  const CheckoutState({this.loading = true, this.message= "", this.isSuccess= false, this.addressModel});

  final bool loading;
  final String message;
  final bool isSuccess;
  final AddressModel? addressModel;

  CheckoutState copyWith({
    bool? loading,
    String? message,
    bool? isSuccess,
    AddressModel? addressModel
  }){
    return CheckoutState(
      loading: loading ?? this.loading,
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess,
      addressModel: addressModel ?? this.addressModel
    );
  }
}

class CheckoutInitial extends CheckoutState {}


