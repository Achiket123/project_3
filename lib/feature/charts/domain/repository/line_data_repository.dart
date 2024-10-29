import 'package:fpdart/fpdart.dart';
import 'package:project_3/feature/charts/domain/entity/line_data_entity.dart';
import 'package:project_3/globals/error_handling/error.dart';

abstract class LineDataRepository {
  Future<Either<AppError, List<LineDataEntity>>> getLineData(String params);
}

