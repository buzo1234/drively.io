import 'package:drively/utility/app_colors.dart';
import 'package:flutter/material.dart';

class CallGroup extends StatefulWidget {


  const CallGroup({super.key, required this.grpName});

  final String grpName;

  @override
  State<CallGroup> createState() => _CallGroupState();
}

class _CallGroupState extends State<CallGroup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: AppColors.SubBackGroundColor,
          borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        children: [
          Text(
            widget.grpName,
            style: TextStyle(color: AppColors.whiteColor, fontSize: 17.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Karan",
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "+91 9860060265",
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              const SizedBox(
                height: 13.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Karan",
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "+91 9860060265",
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              const SizedBox(
                height: 13.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Karan",
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "+91 9860060265",
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              const SizedBox(
                height: 13.0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
