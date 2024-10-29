import 'package:fpdart/fpdart.dart';
import 'package:project_3/globals/error_handling/error.dart';

abstract class Usecase<T, R> {
  Future<Either<AppError, R>> call(T params);
}

