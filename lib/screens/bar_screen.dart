import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  double x = 100.0;
  double y = 10.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: 200.0,
        child: LineChart(
          LineChartData(
            minX: 0.0,
            maxX: 100.0,
            minY: 0.0,
            maxY: 10.0,
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0.0, 0.3),
                  const FlSpot(10.0, 1.0),
                  const FlSpot(20.0, 3.0),
                  const FlSpot(30.0, 0.0),
                  const FlSpot(40.0, 5.0),
                  FlSpot(x, y),
                ],
              )
            ],
            // read about it in the LineChartData section
          ),
          swapAnimationDuration: const Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear, // Optional
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          x = 10.0;
          y = 8.0;
        });
      }),
    );
  }
}
