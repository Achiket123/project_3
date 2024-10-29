import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_3/feature/charts/data/model/transcript_data_model.dart';
import 'package:project_3/feature/charts/domain/usecase/transcript_data_usecase.dart';
import 'package:project_3/globals/error_handling/error.dart';

part 'transcript_data_bloc_event.dart';
part 'transcript_data_bloc_state.dart';

class TranscriptDataBlocBloc
    extends Bloc<TranscriptDataBlocEvent, TranscriptDataBlocState> {
  final TranscriptDataUsecase _transcriptDataUsecase;
  TranscriptDataBlocBloc({required TranscriptDataUsecase transcriptDataUsecase})
      : _transcriptDataUsecase = transcriptDataUsecase,
        super(TranscriptDataBlocInitial()) {
    on<TranscriptDataBlocEvent>((event, emit) {
      emit(TranscriptDataBlocLoading());
    });
    on<GetTranscriptData>((event, emit) async {
      final result = await _transcriptDataUsecase(event.transcriptParams);
      result.fold((l) => emit(TranscriptDataBlocError(appError: l)),
          (r) => emit(TranscriptDataBlocLoaded(transcriptDataModel: r)));
    });
  }
}
