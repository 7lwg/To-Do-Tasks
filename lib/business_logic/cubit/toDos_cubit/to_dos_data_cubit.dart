import 'dart:convert';
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:todo_app_task/business_logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:todo_app_task/constants/variables.dart';
import 'package:todo_app_task/data/repository/todos_repo.dart';

part 'to_dos_data_state.dart';

class ToDosDataCubit extends Cubit<ToDosDataState> {
  ToDosDataCubit() : super(ToDosDataInitial());
  ToDosRepo toDosRepo = ToDosRepo();

  Future todoDataListCubit() async {
    emit(ToDosDataLoading());
    try {
      await toDosRepo.toDosDataListRepo().then((value) async {
        if (value != null) {
          if (value.statusCode == 200) {
            if (displayedPageOfData == 1) {
              if (value.body == '[]') {
                emit(ToDosDataEmpty());
              } else {
                emit(ToDosDataList());
              }
            } else if (value.body == '[]') {
              emit(ToDosDataInfiniteScroll());
            } else {
              emit(ToDosDataRefresher());
            }
          } else if (value.statusCode == 401) {
            await AuthCubit().refreshTokenCubit();
            if (state is AuthError) {
              emit(
                  ToDosDataError(jsonDecode(value.body)['message'].toString()));
            } else {
              await todoDataListCubit();
            }
          } else {
            emit(ToDosDataError(jsonDecode(value.body)['message'].toString()));
          }
        } else {
          emit(ToDosDataError(value.statusCode));
        }
      });
    } catch (error) {
      emit(ToDosDataError(error.toString()));
    }
  }

  Future todoDataCreateCubit() async {
    emit(ToDosDataLoading());
    try {
      await toDosRepo.toDosCreateRepo().then((value) async {
        if (value != null) {
          if (value.statusCode == 201) {
            emit(ToDosDataCreate());
          } else if (value.statusCode == 401) {
            await AuthCubit().refreshTokenCubit();
            if (state is AuthError) {
              emit(
                  ToDosDataError(jsonDecode(value.body)['message'].toString()));
            } else {
              await todoDataCreateCubit();
            }
          } else {
            emit(ToDosDataError(jsonDecode(value.body)['message'].toString()));
          }
        } else {
          emit(ToDosDataError(value.statusCode));
        }
      });
    } catch (error) {
      emit(ToDosDataError(error.toString()));
    }
  }

  Future todoDataEditCubit({required toDoID}) async {
    emit(ToDosDataLoading());
    try {
      await toDosRepo.toDosEditRepo(toDoID: toDoID).then((value) async {
        if (value != null) {
          if (value.statusCode == 200) {
            emit(ToDosDataEdit());
          } else if (value.statusCode == 401) {
            await AuthCubit().refreshTokenCubit();
            if (state is AuthError) {
              emit(
                  ToDosDataError(jsonDecode(value.body)['message'].toString()));
            } else {
              await todoDataEditCubit(toDoID: toDoID);
            }
          } else {
            emit(ToDosDataError(jsonDecode(value.body)['message'].toString()));
          }
        } else {
          emit(ToDosDataError(value.statusCode));
        }
      });
    } catch (error) {
      emit(ToDosDataError(error.toString()));
    }
  }

  Future todoDataDeleteCubit({required toDoID}) async {
    emit(ToDosDataLoading());
    try {
      await toDosRepo.toDosDeleteRepo(toDoID: toDoID).then((value) async {
        if (value != null) {
          if (value.statusCode == 200) {
            toDosDataList.removeWhere((element) => element.sId == toDoID);
            emit(ToDosDataDelete());
          } else if (value.statusCode == 401) {
            await AuthCubit().refreshTokenCubit();
            if (state is AuthError) {
              emit(
                  ToDosDataError(jsonDecode(value.body)['message'].toString()));
            } else {
              await todoDataDeleteCubit(toDoID: toDoID);
            }
          } else {
            emit(ToDosDataError(jsonDecode(value.body)['message'].toString()));
          }
        } else {
          emit(ToDosDataError(value.statusCode));
        }
      });
    } catch (error) {
      emit(ToDosDataError(error.toString()));
    }
  }

  Future todoDataUploadCubit() async {
    emit(ToDosDataLoading());
    try {
      await toDosRepo.toDosUploadImageRepo().then((value) async {
        if (value != null) {
          if (value.statusCode == 200) {
            emit(ToDosDataUploadImage());
          } else if (value.statusCode == 401) {
            await AuthCubit().refreshTokenCubit();
            if (state is AuthError) {
              emit(
                  ToDosDataError(jsonDecode(value.body)['message'].toString()));
            } else {
              await todoDataUploadCubit();
            }
          } else {
            emit(ToDosDataError(jsonDecode(value.body)['message'].toString()));
          }
        } else {
          emit(ToDosDataError(value.statusCode));
        }
      });
    } catch (error) {
      emit(ToDosDataError(error.toString()));
    }
  }
}
