import 'dart:convert';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:project_3/feature/charts/data/model/transcript_data_model.dart';
import 'package:project_3/feature/charts/domain/usecase/transcript_data_usecase.dart';
import 'package:project_3/globals/constants/strings.dart';
import 'package:project_3/globals/error_handling/error.dart';
import 'package:http/http.dart' as http;
import 'package:project_3/globals/error_handling/failure.dart';

abstract class TranscriptDataSource {
  Future<Either<AppError, TranscriptDataModel>> getTranscript(
      TranscriptParams transcriptParams);
}

class TranscriptDataSourceImpl extends TranscriptDataSource {
  @override
  Future<Either<AppError, TranscriptDataModel>> getTranscript(
      TranscriptParams transcriptParams) async {
    try {
      final data = await http.get(Uri.parse(
          "${API.earningscalltranscripts}?ticker=${transcriptParams.ticker}&year=${transcriptParams.year}&quarter=${transcriptParams.quarter}"));
      final bodyData = jsonDecode(data.body);
      if (bodyData.runtimeType == [].runtimeType) {
        return Right(TranscriptDataModel(transcript: "Not Yet happend"));
      }
      final transcriptData = TranscriptDataModel.fromJson(bodyData);
      return Right(transcriptData);
    } catch (e) {
      log(e.toString());
      return Left(AppError(ServerFailure(e.toString())));
    }
  }
}
