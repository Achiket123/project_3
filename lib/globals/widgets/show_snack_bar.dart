import 'package:flutter/material.dart';
import 'package:project_3/globals/error_handling/error.dart';

showErrorSnackBar(BuildContext context, AppError error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.failure.message)));
}
