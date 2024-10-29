part of 'transcript_data_bloc_bloc.dart';

@immutable
sealed class TranscriptDataBlocEvent {}

class GetTranscriptData extends TranscriptDataBlocEvent {
  final TranscriptParams transcriptParams;
  GetTranscriptData( {required this.transcriptParams});
}
