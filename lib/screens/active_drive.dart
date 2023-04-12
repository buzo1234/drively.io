import 'package:drively/components/car_condition.dart';
import 'package:drively/utility/app_colors.dart';
import 'package:flutter/material.dart';

class ActiveDrive extends StatefulWidget {
  List<Map<String, dynamic>?> groups;
  ActiveDrive({required this.groups, super.key});

  @override
  State<ActiveDrive> createState() => _ActiveDriveState();
}

class _ActiveDriveState extends State<ActiveDrive> {
  @override
  Widget build(BuildContext context) {
    print(widget.groups.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Data"),
        backgroundColor: AppColors.MainBackGroundColor,
        elevation: 0.0,
      ),
      body: CarCondition(grpData: widget.groups),
    );
  }
}
