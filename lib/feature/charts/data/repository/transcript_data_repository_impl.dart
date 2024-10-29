import 'package:fpdart/fpdart.dart';
import 'package:project_3/feature/charts/data/datasource/transcript_data_source.dart';
import 'package:project_3/feature/charts/data/model/transcript_data_model.dart';
import 'package:project_3/feature/charts/domain/repository/transcript_data_repository.dart';
import 'package:project_3/feature/charts/domain/usecase/transcript_data_usecase.dart';
import 'package:project_3/globals/error_handling/error.dart';

class TranscriptDataRepositoryImpl extends TranscriptDataRepository {
  final TranscriptDataSource dataSource;
  TranscriptDataRepositoryImpl({required this.dataSource});
  @override
  Future<Either<AppError, TranscriptDataModel>> getTranscript(TranscriptParams transcriptParams) async => dataSource.getTranscript(transcriptParams);
}
