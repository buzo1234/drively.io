import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drively/models/user_shared_ref.dart';
import 'package:drively/screens/add_numbers.dart';
import 'package:drively/screens/login_phone.dart';
import 'package:drively/screens/switch_to_drive.dart';
import 'package:drively/services/shared_refs.dart';
import 'package:drively/services/user_crud.dart';
import 'package:drively/utility/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  UserLocalSave user;

  HomeScreen({required this.user, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> collectionReference = UserCrud.readUsers();
  var collection = FirebaseFirestore.instance.collection('groups');
  SharedPref sharedPref = SharedPref();
  late TextEditingController _textEditingController;
  List<Map<String, dynamic>?> grpData = [];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void getData(List itemDetails) async {
    List<Map<String, dynamic>?> grp = [];
    for (String doc in itemDetails) {
      var docSnapshot = await collection.doc(doc).get();
      Map<String, dynamic>? data = docSnapshot.data();

      grp.add(data);
    }

    setState(() {
      grpData = grp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.MainBackGroundColor,
        title: const Text('drively.io'),
        actions: [
          IconButton(
              onPressed: () {
                if (grpData.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SwitchDrive(
                            grpdata: grpData,
                          )));
                } else {}
              },
              icon: const Icon(Icons.swipe_vertical_sharp)),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: AppColors.SubBackGroundColor,
                          title: const Text(
                            'Add Group',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: TextField(
                            controller: _textEditingController,
                            decoration: const InputDecoration(
                                hintText: 'Enter group Name',
                                hintStyle: TextStyle(color: Colors.white)),
                            style: const TextStyle(color: Colors.white),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Submit'),
                              onPressed: () {
                                String input = _textEditingController.text;
                                Navigator.pop(context);
                                setState(() {
                                  _textEditingController.text = '';
                                });
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddNumbers(
                                          grpName: input,
                                        )));
                              },
                            ),
                          ],
                        ));
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                sharedPref.remove("user");
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => (const LoginWithPhone()),
                    ),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user.phone)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final DocumentSnapshot document = snapshot.data!;

            final Map<String, dynamic> documentData =
                document.data() as Map<String, dynamic>;

            if (documentData['groups'] == null ||
                documentData['groups'].length == 0) {
              return Container(
                color: AppColors.MainBackGroundColor,
                child: const Center(
                    child: Text(
                  'Not part of any group',
                  style: TextStyle(color: Colors.white, fontSize: 23.0),
                )),
              );
            }

            final List itemDetailList = (documentData['groups'])
                .map((itemDetail) => itemDetail)
                .toList();

            getData(itemDetailList);

            return Container(
              color: AppColors.MainBackGroundColor,
              child: ListView.builder(
                  itemCount: grpData.length,
                  itemBuilder: (BuildContext context, int index) {
                    //getData(itemDetailList);
                    return Container(
                      decoration: BoxDecoration(
                          color: AppColors.SubBackGroundColor,
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15.0),
                      padding: const EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: Column(children: [
                        Text(
                          grpData[index]!['name'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          color: AppColors.ButtonBackGroundColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            children: [
                              for (var users in grpData[index]!["users"])
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        users['name'],
                                        style: TextStyle(
                                            color: users["role"] == "driving"
                                                ? Colors.blue
                                                : Colors.white,
                                            fontSize: 20.0),
                                      ),
                                      Text(
                                        users['phone'],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      )
                                    ])
                            ],
                          ),
                        )
                      ]),
                    );
                  }),
            );
          }),
    );
  }
}
