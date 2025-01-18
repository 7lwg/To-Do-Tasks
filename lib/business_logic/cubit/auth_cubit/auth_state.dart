part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthRegitster extends AuthState {}

final class AuthLogin extends AuthState {}

final class AuthLogout extends AuthState {}

final class AuthRefreshToken extends AuthState {}

final class AuthProfile extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthExperienceLevelError extends AuthState {}

final class AuthPhoneNumberError extends AuthState {}

final class AuthError extends AuthState {
  late final String errorMessage;
  AuthError(this.errorMessage);
}

final class AuthShowPassword extends AuthState {}
