import 'package:project_3/feature/charts/data/datasource/line_data_source.dart';
import 'package:project_3/feature/charts/data/datasource/transcript_data_source.dart';
import 'package:project_3/feature/charts/data/repository/line_data_repository_impl.dart';
import 'package:project_3/feature/charts/data/repository/transcript_data_repository_impl.dart';
import 'package:project_3/feature/charts/domain/repository/line_data_repository.dart';
import 'package:project_3/feature/charts/domain/repository/transcript_data_repository.dart';
import 'package:project_3/feature/charts/domain/usecase/line_data_usecase.dart';
import 'package:project_3/feature/charts/domain/usecase/transcript_data_usecase.dart';
import 'package:project_3/feature/charts/presentation/bloc/line_chart_bloc/line_chart_bloc_bloc.dart';
import 'package:project_3/feature/charts/presentation/bloc/transcript_data_blov/transcript_data_bloc_bloc.dart';
import 'package:project_3/main.dart';

void initializeServiceLocator() {
  // initialize data source
  locator.registerLazySingleton<LineDataSource>(() => LineDataSourceImpl());
  locator.registerLazySingleton<TranscriptDataSource>(
      () => TranscriptDataSourceImpl());

  // initialize repository
  locator.registerLazySingleton<LineDataRepository>(
      () => LineDataRepositoryImpl(remoteDataSource: locator()));
  locator.registerLazySingleton<TranscriptDataRepository>(
      () => TranscriptDataRepositoryImpl(dataSource: locator()));

  // initialize usecase
  locator
      .registerLazySingleton<LineDataUsecase>(() => LineDataUsecase(locator()));
  locator.registerLazySingleton<TranscriptDataUsecase>(
      () => TranscriptDataUsecase(locator()));

  // initialize bloc
  locator.registerLazySingleton<LineChartBlocBloc>(
      () => LineChartBlocBloc(lineDataUsecase: locator()));
  locator.registerLazySingleton<TranscriptDataBlocBloc>(
      () => TranscriptDataBlocBloc(transcriptDataUsecase: locator()));
}
