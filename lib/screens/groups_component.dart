import 'package:drively/components/call_group.dart';
import 'package:drively/utility/app_colors.dart';
import 'package:flutter/material.dart';

class CallGroups extends StatefulWidget {
  const CallGroups({super.key});

  @override
  State<CallGroups> createState() => _CallGroupsState();
}

class _CallGroupsState extends State<CallGroups> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.MainBackGroundColor,
      ),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            'Call Groups',
            style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Container(
            child: Column(
              children: const [
                CallGroup(
                  grpName: 'Family & Friends',
                ),
                CallGroup(
                  grpName: 'Service Group',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
