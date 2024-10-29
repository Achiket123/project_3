import 'package:fpdart/fpdart.dart';

import 'package:project_3/feature/charts/domain/entity/line_data_entity.dart';
import 'package:project_3/feature/charts/domain/repository/line_data_repository.dart';
import 'package:project_3/globals/error_handling/error.dart';
import 'package:project_3/globals/usecases/usecase.dart';

class LineDataUsecase extends Usecase<LineDataParams, List<LineDataEntity>> {
  final LineDataRepository repository;
  LineDataUsecase(this.repository);
  @override
  Future<Either<AppError, List<LineDataEntity>>> call(LineDataParams params) async => repository.getLineData(params.ticker);
}

class LineDataParams {
  final String ticker;
  LineDataParams(this.ticker);
}
