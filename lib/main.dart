import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:project_3/feature/charts/presentation/bloc/line_chart_bloc/line_chart_bloc_bloc.dart';
import 'package:project_3/feature/charts/presentation/bloc/transcript_data_blov/transcript_data_bloc_bloc.dart';
import 'package:project_3/feature/charts/presentation/screens/home_screen.dart';
import 'package:project_3/service.g.dart';

final GetIt locator = GetIt.instance;
void main() {
  initializeServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<LineChartBlocBloc>()),
        BlocProvider(create: (context) => locator<TranscriptDataBlocBloc>()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: HomeScreen(),
      ),
    );
  }
}
