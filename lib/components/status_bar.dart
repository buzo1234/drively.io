import 'package:drively/utility/app_colors.dart';
import 'package:flutter/material.dart';

class CompStatus extends StatefulWidget {
  final String data;
  final double status;
  const CompStatus({super.key, required this.data, required this.status});

  @override
  State<CompStatus> createState() => _CompStatusState();
}

class _CompStatusState extends State<CompStatus> {
  double val = 0.0;
  double _value = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    val = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        Slider(
          min: 0,
          max: 100,
          value: widget.status,
          onChanged: (value) {
            setState(() {
              _value = value;
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
          '${widget.status.round()}%',
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
