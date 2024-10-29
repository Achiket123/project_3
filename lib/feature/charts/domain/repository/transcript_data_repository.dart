import 'package:fpdart/fpdart.dart';
import 'package:project_3/feature/charts/data/model/transcript_data_model.dart';
import 'package:project_3/feature/charts/domain/usecase/transcript_data_usecase.dart';
import 'package:project_3/globals/error_handling/error.dart';

abstract class TranscriptDataRepository {
  Future<Either<AppError, TranscriptDataModel>> getTranscript(
      TranscriptParams transcriptParams);
}
