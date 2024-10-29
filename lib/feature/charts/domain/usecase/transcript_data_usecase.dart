import 'package:fpdart/fpdart.dart';
import 'package:project_3/feature/charts/data/model/transcript_data_model.dart';
import 'package:project_3/feature/charts/domain/repository/transcript_data_repository.dart';
import 'package:project_3/globals/error_handling/error.dart';
import 'package:project_3/globals/usecases/usecase.dart';

class TranscriptDataUsecase
    extends Usecase<TranscriptParams, TranscriptDataModel> {
  final TranscriptDataRepository dataSource;
  TranscriptDataUsecase(this.dataSource);
  @override
  Future<Either<AppError, TranscriptDataModel>> call(
          TranscriptParams params) async =>
      dataSource.getTranscript(params);
}

class TranscriptParams {
  final String ticker;
  final int year;
  final int quarter;
  TranscriptParams(this.ticker, this.year, this.quarter);
}
