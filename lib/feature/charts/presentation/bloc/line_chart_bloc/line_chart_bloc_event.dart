part of 'line_chart_bloc_bloc.dart';

@immutable
sealed class LineChartBlocEvent {}

class GetLineData extends LineChartBlocEvent {
  final LineDataParams ticker;
  GetLineData(this.ticker, );
}
