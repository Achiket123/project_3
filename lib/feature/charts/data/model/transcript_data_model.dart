import 'package:project_3/feature/charts/domain/entity/transcript_data_entity.dart';

class TranscriptDataModel extends TranscriptDataEntity {
  TranscriptDataModel({required super.transcript});
  factory TranscriptDataModel.fromJson(Map<String, dynamic> json) {
   return TranscriptDataModel(transcript: json["transcript"]);
  }
}
