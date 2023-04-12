import 'package:flutter/material.dart';

class DriverAccident extends StatefulWidget {
  const DriverAccident({super.key});

  @override
  State<DriverAccident> createState() => _DriverAccidentState();
}

class _DriverAccidentState extends State<DriverAccident> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: const Text("ACCI"),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
