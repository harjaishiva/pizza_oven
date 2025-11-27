part of 'profile_cubit.dart';

class ProfileState {
  const ProfileState(
      {this.loading = true,
      this.message = "",
      this.isSuccess = false,
      this.isESuccess = false,
      this.isOtpSent = false,
      this.isOtpVerified = false,
      this.profileModel,
      this.addressesList});

  final bool loading;
  final String message;
  final bool isSuccess;
  final bool isESuccess;
  final bool isOtpSent;
  final bool isOtpVerified;
  final ProfileModel? profileModel;
  final List<String>? addressesList;

  ProfileState copyWith({
    bool? loading,
    String? message,
    bool? isSuccess,
    bool? isESuccess,
    bool? isOtpSent,
    bool? isOtpVerified,
    ProfileModel? profileModel,
    List<String>? addressesList,
  }) {
    return ProfileState(
        loading: loading ?? this.loading,
        message: message ?? this.message,
        isSuccess: isSuccess ?? this.isSuccess,
        isESuccess: isESuccess ?? this.isESuccess,
        isOtpSent : isOtpSent ?? this.isOtpSent,
        isOtpVerified: isOtpVerified ?? this.isOtpVerified,
        profileModel: profileModel ?? this.profileModel,
        addressesList: addressesList ?? this.addressesList);
  }
}

class ProfileInitial extends ProfileState {}
