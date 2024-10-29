part of 'line_chart_bloc_bloc.dart';

@immutable
sealed class LineChartBlocState {}

final class LineChartBlocInitial extends LineChartBlocState {}

final class LineChartBlocLoading extends LineChartBlocState {}

final class LineChartBlocLoaded extends LineChartBlocState {
  final List<LineDataEntity> lineData;
  LineChartBlocLoaded(this.lineData);
}

final class LineChartBlocError extends LineChartBlocState {
  final AppError error;
  LineChartBlocError(this.error);
}
