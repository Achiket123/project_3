import 'package:project_3/globals/error_handling/failure.dart';
class AppError implements Exception {
  final Failure failure;
  AppError(this.failure);
}

