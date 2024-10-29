// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_3/feature/charts/domain/entity/line_data_entity.dart';
import 'package:project_3/feature/charts/domain/usecase/line_data_usecase.dart';
import 'package:project_3/globals/error_handling/error.dart';

part 'line_chart_bloc_event.dart';
part 'line_chart_bloc_state.dart';

class LineChartBlocBloc extends Bloc<LineChartBlocEvent, LineChartBlocState> {
  late LineDataUsecase _lineDataUsecase;
  LineChartBlocBloc({required LineDataUsecase lineDataUsecase})
      : super(LineChartBlocInitial()) {
    _lineDataUsecase = lineDataUsecase;
    on<LineChartBlocEvent>((event, emit) {
      emit(LineChartBlocLoading());
    });
    on<GetLineData>((event, emit) async {
      final result = await _lineDataUsecase.call((event.ticker));
      result.fold((l) => emit(LineChartBlocError(l)),
          (r) => emit(LineChartBlocLoaded(r)));
    });
  }
}
