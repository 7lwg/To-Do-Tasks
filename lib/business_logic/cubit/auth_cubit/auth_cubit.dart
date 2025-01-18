import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:todo_app_task/data/repository/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  AuthRepo authRepo = AuthRepo();

  Future registerCubit() async {
    emit(AuthLoading());
    try {
      await authRepo.registerRepo().then((value) {
        if (value != null) {
          if (value.statusCode == 201) {
            emit(AuthRegitster());
          } else {
            emit(AuthError(jsonDecode(value.body)['message'].toString()));
          }
        } else {
          emit(AuthError(value.statusCode));
        }
      });
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future loginCubit() async {
    emit(AuthLoading());
    try {
      await authRepo.loginRepo().then((value) {
        if (value != null) {
          if (value.statusCode == 201) {
            emit(AuthLogin());
          } else {
            emit(AuthError(jsonDecode(value.body)['message'].toString()));
          }
        } else {
          emit(AuthError(value.statusCode));
        }
      });
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future logoutCubit() async {
    emit(AuthLoading());
    try {
      await authRepo.logoutRepo().then((value) async {
        if (value != null) {
          if (value.statusCode == 201) {          
            emit(AuthLogout());
          } else if (value.statusCode == 401) {
            await refreshTokenCubit();
          } else {
            emit(AuthError(jsonDecode(value.body)['message'].toString()));
          }
        } else {
          emit(AuthError(value.statusCode));
        }
      });
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future refreshTokenCubit() async {
    emit(AuthLoading());
    try {
      await authRepo.refreshTokenRepo().then((value) {
        if (value != null) {
          if (value.statusCode == 200) {
            emit(AuthRefreshToken());
          } else {          
            emit(AuthError(jsonDecode(value.body)['message'].toString()));
          }
        } else {
          emit(AuthError(value.statusCode));
        }
      });
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future profileDataCubit() async {
    emit(AuthLoading());
    try {
      await authRepo.profileDataRepo().then((value) async {
        if (value != null) {
          if (value.statusCode == 200) {        
            emit(AuthProfile());
          } else if (value.statusCode == 401) {
            await refreshTokenCubit();
            if (state is AuthError) {
              emit(AuthError(jsonDecode(value.body)['message'].toString()));
            } else {
              await profileDataCubit();
            }
          } else {
            emit(AuthError(jsonDecode(value.body)['message'].toString()));
          }
        } else {
          emit(AuthError(value.statusCode));
        }
      });
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }
}