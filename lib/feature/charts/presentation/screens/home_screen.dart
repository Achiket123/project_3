import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_3/feature/charts/domain/usecase/line_data_usecase.dart';
import 'package:project_3/feature/charts/domain/usecase/transcript_data_usecase.dart';
import 'package:project_3/feature/charts/presentation/bloc/line_chart_bloc/line_chart_bloc_bloc.dart';
import 'package:project_3/feature/charts/presentation/bloc/transcript_data_blov/transcript_data_bloc_bloc.dart';
import 'package:project_3/globals/constants/debouncer.dart';
import 'package:project_3/globals/constants/strings.dart';
import 'package:project_3/globals/widgets/show_snack_bar.dart';

class HomeScreen extends StatefulWidget with Strings {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMetric = 'Revenue';
  String selectedTicker = 'META';
  final Debouncer debouncer =
      Debouncer(duration: const Duration(milliseconds: 500));
  @override
  void initState() {
    super.initState();
    context.read<LineChartBlocBloc>().add(GetLineData(LineDataParams('META')));
    context.read<TranscriptDataBlocBloc>().add(
        GetTranscriptData(transcriptParams: TranscriptParams('META', 2024, 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: DropdownButton<String>(
            value: selectedTicker, // You'll need to make this a state variable
            dropdownColor: Colors.white,
            style: const TextStyle(color: Colors.black),
            items: [
              'META',
              'AAPL',
              'GOOGL',
              'MSFT',
              'AMZN',
              'NVDA',
              'TSLA',
            ]
                .map((String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                context
                    .read<LineChartBlocBloc>()
                    .add(GetLineData(LineDataParams(newValue)));
                context.read<TranscriptDataBlocBloc>().add(GetTranscriptData(
                    transcriptParams: TranscriptParams(newValue, 2024, 1)));
                setState(() {
                  selectedTicker = newValue;
                });
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                BlocConsumer<LineChartBlocBloc, LineChartBlocState>(
                  listener: (context, state) {
                    if (state is LineChartBlocError) {
                      showErrorSnackBar(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    if (state is LineChartBlocLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is LineChartBlocLoaded) {
                      state.lineData
                          .sort((a, b) => a.pricedate!.compareTo(b.pricedate!));
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
                            children: [
                              DropdownButton<String>(
                                value: selectedMetric,
                                items: ['Revenue', 'EPS']
                                    .map((String value) =>
                                        DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        ))
                                    .toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedMetric = newValue!;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 400,
                                child: selectedMetric == 'Revenue'
                                    ? revenueChart(state)
                                    : epsChart(state),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Legend for Revenue
                                  if (selectedMetric == 'Revenue') ...[
                                    Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade600,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text('Actual Revenue'),
                                        const SizedBox(width: 16),
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade600,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text('Estimated Revenue'),
                                      ],
                                    ),
                                  ],
                                  // Legend for EPS
                                  if (selectedMetric == 'EPS') ...[
                                    Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade600,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text('Actual EPS'),
                                        const SizedBox(width: 16),
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade600,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text('Estimated EPS'),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return const Text("Error");
                  },
                ),
                BlocConsumer<TranscriptDataBlocBloc, TranscriptDataBlocState>(
                  listener: (context, state) {
                    if (state is TranscriptDataBlocError) {
                      showErrorSnackBar(context, state.appError);
                    }
                  },
                  builder: (context, state) {
                    if (state is TranscriptDataBlocLoading) {
                      return const Center(child: Text("Loading..."));
                    }
                    if (state is TranscriptDataBlocLoaded) {
                      final List<String> transcript = state
                          .transcriptDataModel.transcript
                          .split('\n')
                          .where((line) => line.trim().isNotEmpty)
                          .toList();

                      return ExpansionTile(
                        title: Text(transcript.sublist(0, 1).join('\n')),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Earnings Call Transcript',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  children: transcript.map((line) {
                                    bool isSpeakerLabel =
                                        RegExp(r'^[A-Z][a-z]+ [A-Z][a-z]+:')
                                            .hasMatch(line.trim());
                                    return TextSpan(
                                      text:
                                          '$line\n\n', // Added extra newline for readability
                                      style: TextStyle(
                                        height:
                                            1.5, // Added line height for readability
                                        fontWeight: isSpeakerLabel
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return const Text("Error");
                  },
                )
              ],
            ),
          ),
        ));
  }

  LineChart epsChart(LineChartBlocLoaded state) {
    return LineChart(LineChartData(
        minX: 0,
        minY: 0,
        maxX: 4,
        maxY: (state.lineData
                .map((data) => data.actualEps!.toDouble())
                .reduce((a, b) => a > b ? a : b) *
            1.2),
        clipData: const FlClipData.all(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            axisNameWidget: const Text('EPS',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text('\$${value.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: const Text('Quarter',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 1.0:
                    return const Text('Q1',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87));
                  case 2.0:
                    return const Text('Q2',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87));
                  case 3.0:
                    return const Text('Q3',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87));
                  case 4.0:
                    return const Text('Q4',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87));
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 1,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.8,
              dashArray: [5, 5],
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.8,
              dashArray: [5, 5],
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black54, width: 1.5),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            curveSmoothness: 0.25,
            color: Colors.green.shade600,
            barWidth: 3.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Colors.green.shade600,
                  strokeWidth: 2.5,
                  strokeColor: Colors.white,
                );
              },
            ),
            spots: state.lineData
                .map((data) => FlSpot(
                      (DateTime.parse(data.pricedate!).month / 3)
                          .ceil()
                          .toDouble(),
                      data.actualEps!.toDouble(),
                    ))
                .toList()
                .toSet()
                .toList(),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade600.withOpacity(0.2),
                  Colors.green.shade600.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          LineChartBarData(
            isCurved: true,
            curveSmoothness: 0.25,
            color: Colors.orange.shade600,
            barWidth: 3.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Colors.orange.shade600,
                  strokeWidth: 2.5,
                  strokeColor: Colors.white,
                );
              },
            ),
            spots: state.lineData
                .map((data) => FlSpot(
                      (DateTime.parse(data.pricedate!).month / 3)
                          .ceil()
                          .toDouble(),
                      data.estimatedEps!.toDouble(),
                    ))
                .toList()
                .toSet()
                .toList(),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.orange.shade600.withOpacity(0.2),
                  Colors.orange.shade600.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ]));
  }

  LineChart revenueChart(LineChartBlocLoaded state) {
    return LineChart(LineChartData(
        lineTouchData: LineTouchData(
          enabled: false,
          touchCallback: (touchInput, touchResponse) {
            if (touchResponse?.lineBarSpots != null &&
                touchResponse!.lineBarSpots!.isNotEmpty) {
              final tappedSpot = touchResponse.lineBarSpots![0].spotIndex;
              log(tappedSpot.toString());
              log(state.lineData.toString());
              final date =
                  DateTime.parse(state.lineData[tappedSpot].pricedate!);

              final quarter = ((date.month - 1) / 3).floor() + 1;
              // log(quarter.toString());
              debouncer.run(() {
                context.read<TranscriptDataBlocBloc>().add(GetTranscriptData(
                    transcriptParams:
                        TranscriptParams(selectedTicker, date.year, quarter)));
              });
            }
          },
        ),
        minX: 0,
        minY: 0,
        maxX: 4,
        maxY: (state.lineData
                .map((data) => data.actualRevenue!.toDouble() / 1000000000)
                .reduce((a, b) => a > b ? a : b) *
            1.2),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 15,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color.fromARGB(255, 167, 49, 49).withOpacity(0.2),
              strokeWidth: 0.8,
              dashArray: [5, 5],
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color.fromARGB(255, 116, 83, 83).withOpacity(0.2),
              strokeWidth: 0.8,
              dashArray: [5, 5],
            );
          },
        ),
        clipData: const FlClipData.all(),
        backgroundColor: Colors.white,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            axisNameWidget: const Text('Revenue (Billions)',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              interval: 15,
              getTitlesWidget: (value, meta) {
                return Text('\$${value.toInt()}B',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: const Text('Quarter',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                switch (value) {
                  case 1.0:
                    return const Text('Q1',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87));
                  case 2.0:
                    return const Text('Q2',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87));
                  case 3.0:
                    return const Text('Q3',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87));
                  case 4.0:
                    return const Text('Q4',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87));
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            curveSmoothness: 0.25,
            color: Colors.blue.shade600,
            barWidth: 3.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Colors.blue.shade600,
                  strokeWidth: 2.5,
                  strokeColor: Colors.white,
                );
              },
            ),
            spots: state.lineData
                .map((data) => FlSpot(
                      (DateTime.parse(data.pricedate!).month / 3)
                          .ceil()
                          .toDouble(),
                      data.actualRevenue!.toDouble() / 1000000000,
                    ))
                .toList()
                .toSet()
                .toList(),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade600.withOpacity(0.2),
                  Colors.blue.shade600.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          LineChartBarData(
            isCurved: true,
            curveSmoothness: 0.25,
            color: Colors.red.shade600,
            barWidth: 3.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Colors.red.shade600,
                  strokeWidth: 2.5,
                  strokeColor: Colors.white,
                );
              },
            ),
            spots: state.lineData
                .map((data) => FlSpot(
                      (DateTime.parse(data.pricedate!).month / 3)
                          .ceil()
                          .toDouble(),
                      data.estimatedRevenue!.toDouble() / 1000000000,
                    ))
                .toList()
                .toSet()
                .toList(),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade600.withOpacity(0.2),
                  Colors.red.shade600.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ]));
  }
}
