part of 'sign_in_cubit.dart';

class SignInState {
  const SignInState({this.loading = true, this.message = "", this.isSuccess = false});

  final bool loading;
  final String message;
  final bool isSuccess;

  SignInState copyWith(
    {bool? loading,
    String? message,
    bool? isSuccess}
  ){
    return SignInState(
      loading: loading ?? this.loading,
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess
          );
  }
}

class SignInInitial extends SignInState {}


