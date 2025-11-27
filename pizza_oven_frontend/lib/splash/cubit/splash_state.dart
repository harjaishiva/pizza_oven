part of 'splash_cubit.dart';

class SplashState {
  const SplashState({this.loading = true, this.message = "", this.isSuccess = false});

  final bool loading;
  final String message;
  final bool isSuccess;

  SplashState copyWith(
    {bool? loading,
    String? message,
    bool? isSuccess}
  ){
    return SplashState(
      loading: loading ?? this.loading,
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess
          );
  }
}

class SplashInitialState extends SplashState{}



