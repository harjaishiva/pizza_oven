part of 'sign_up_cubit.dart';

class SignUpState {
  const SignUpState({this.loading = true, this.message = "", this.isSuccess = false});

  final bool loading;
  final String message;
  final bool isSuccess;

  SignUpState copyWith(
    {bool? loading,
    String? message,
    bool? isSuccess}
  ){
    return SignUpState(
      loading: loading ?? this.loading,
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess
          );
  }
}

class SignUpInitial extends SignUpState {}


