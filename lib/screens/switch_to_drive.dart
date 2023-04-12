import 'package:drively/screens/active_drive.dart';
import 'package:drively/utility/app_colors.dart';
import 'package:flutter/material.dart';

class SwitchDrive extends StatefulWidget {
  List<Map<String, dynamic>?> grpdata;
  SwitchDrive({required this.grpdata, super.key});

  @override
  State<SwitchDrive> createState() => _SwitchDriveState();
}

class _SwitchDriveState extends State<SwitchDrive> {
  List<Map<String, dynamic>> checkVal = [];

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < widget.grpdata.length; i++) {
      checkVal.add({widget.grpdata[i]!['name']: false});
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Groups"),
        backgroundColor: AppColors.MainBackGroundColor,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.MainBackGroundColor),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: [
          Column(
            children: [
              for (var i = 0; i < widget.grpdata.length; i++)
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.grpdata[i]!['name'],
                        style: const TextStyle(
                            color: Colors.white, fontSize: 23.0),
                      ),
                      Checkbox(
                          side: const BorderSide(color: Colors.white),
                          autofocus: true,
                          focusColor: Colors.white,
                          value: checkVal[i][widget.grpdata[i]!['name']],
                          onChanged: (bool? value) {
                            setState(() {
                              checkVal[i][widget.grpdata[i]!['name']] =
                                  !checkVal[i][widget.grpdata[i]!['name']];
                            });
                          })
                    ])
            ],
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            List<Map<String, dynamic>?> finalList = [];
            for (var i = 0; i < widget.grpdata.length; i++) {
              if (checkVal[i][widget.grpdata[i]!['name']] == true) {
                finalList.add(widget.grpdata[i]);
              }
            }

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ActiveDrive(groups: finalList)));
          },
          label: const Text(
            "Drive!",
            style: TextStyle(fontSize: 25.0),
          )),
    );
  }
}
