import 'dart:async';
import 'dart:math';

import 'package:drively/utility/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineStatus extends StatefulWidget {
  final String data;
  final double status;
  const LineStatus({super.key, required this.data, required this.status});

  @override
  State<LineStatus> createState() => _LineStatusState();
}

class _LineStatusState extends State<LineStatus> {
  double val = 0.0;
  double value2 = 0.0;
  int count = 10;

  List<FlSpot> spots = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    count = 10;
    // Generate initial data
    for (int i = 0; i < 10; i++) {
      spots.add(FlSpot(i.toDouble(), _getRandomValue(value2.round())));
    }

    // Update data every second

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print('val is : ${value2.round()}');
      setState(() {
        spots.removeAt(0);
        spots.add(FlSpot(count + 1, _getRandomValue(value2.round())));
        count = count + 1;
      });
    });
  }

  double _getRandomValue(int val) {
    return Random().nextInt(2 * val + 1).toDouble() - (val);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.SubBackGroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(15.0))),
      margin: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          widget.data,
          style: TextStyle(fontSize: 20.0, color: AppColors.whiteColor),
        ),
        const SizedBox(
          height: 20.0,
        ),
        SizedBox(
          width: 600,
          height: 100,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: Colors.blue,
                  barWidth: 2,
                  dotData: FlDotData(show: true),
                ),
              ],
              minY: -100,
              maxY: 100,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: (value, meta) => const Text('HII'),
                    showTitles: false,
                  ),
                ),
              ),
            ),
          ),
        ),
        Slider(
          min: 0,
          max: 100,
          value: value2,
          onChanged: (value) {
            setState(() {
              value2 = value;
            });
          },
        ),
        /* LinearProgressIndicator(
          value: val,
        ), */
        const SizedBox(
          height: 10.0,
        ),
        Text(
          '${value2.round()}%',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        /* Text(
          '${(val * 100).round()}%',
          style: TextStyle(color: AppColors.whiteColor),
        ), */
      ]),
    );
  }
}
