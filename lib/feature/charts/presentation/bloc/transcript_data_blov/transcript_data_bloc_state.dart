part of 'transcript_data_bloc_bloc.dart';

@immutable
sealed class TranscriptDataBlocState {}

final class TranscriptDataBlocInitial extends TranscriptDataBlocState {}

final class TranscriptDataBlocLoading extends TranscriptDataBlocState {}

final class TranscriptDataBlocLoaded extends TranscriptDataBlocState {
  final TranscriptDataModel transcriptDataModel;
  TranscriptDataBlocLoaded({required this.transcriptDataModel});
}

final class TranscriptDataBlocError extends TranscriptDataBlocState {
  final AppError appError;
  TranscriptDataBlocError({required this.appError});
}
