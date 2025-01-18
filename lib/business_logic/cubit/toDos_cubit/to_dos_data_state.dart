part of 'to_dos_data_cubit.dart';

@immutable
sealed class ToDosDataState {}

final class ToDosDataInitial extends ToDosDataState {}

final class ToDosDataList extends ToDosDataState {}

final class ToDosDataCreate extends ToDosDataState {}

final class ToDosDataEdit extends ToDosDataState {}

final class ToDosDataDelete extends ToDosDataState {}

final class ToDosDataUploadImage extends ToDosDataState {}

final class ToDosDataLoading extends ToDosDataState {}

final class ToDosDataError extends ToDosDataState {
  late final String errorMessage;
  ToDosDataError(this.errorMessage);
}

final class ToDosStatusChossedButton extends ToDosDataState {}

final class ToDosDataEmpty extends ToDosDataState {}

final class ToDosDataRefresher extends ToDosDataState {}

final class ToDosDataInfiniteScroll extends ToDosDataState {}

final class ToDoDataQrScan extends ToDosDataState {}
