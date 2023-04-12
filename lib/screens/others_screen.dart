import 'package:drively/services/shared_refs.dart';
import 'package:flutter/material.dart';

class OthersScreen extends StatelessWidget {
  OthersScreen({super.key});

  SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        const Text('Others screen'),
        ElevatedButton(
            onPressed: () {
              sharedPref.remove("user");
            },
            child: const Text('Logout'))
      ]),
    );
  }
}
