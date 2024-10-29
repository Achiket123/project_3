import 'package:fpdart/fpdart.dart';
import 'package:project_3/feature/charts/data/datasource/line_data_source.dart';
import 'package:project_3/feature/charts/data/model/line_data_model.dart';
import 'package:project_3/feature/charts/domain/repository/line_data_repository.dart';
import 'package:project_3/globals/error_handling/error.dart';

class LineDataRepositoryImpl extends LineDataRepository {
  final LineDataSource remoteDataSource;
  LineDataRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<AppError, List<LineDataModel>>> getLineData(String params) async => remoteDataSource.getLineData(params);
}
