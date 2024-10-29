import 'dart:convert';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:project_3/feature/charts/data/model/line_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:project_3/globals/constants/strings.dart';
import 'package:project_3/globals/error_handling/error.dart';
import 'package:project_3/globals/error_handling/failure.dart';

abstract class LineDataSource {
  Future<Either<AppError, List<LineDataModel>>> getLineData(String params);
  
}

class LineDataSourceImpl extends LineDataSource {
  @override
  Future<Either<AppError, List<LineDataModel>>> getLineData(
      String params) async {
    try {
      log("${API.earningscalendar}?ticker=$params");
      final response =
          await http.get(Uri.parse("${API.earningscalendar}?ticker=$params"));
      final data = jsonDecode(response.body);
      log(data.toString(), name: "Data");
      final lineData =
          data.map<LineDataModel>((e) => LineDataModel.fromJson(e)).toList();
      return Right(lineData);
    } catch (e) {
      log(e.toString(), name: "Error");
      return Left(AppError(ServerFailure(e.toString())));
    }
  }
  
 
}
