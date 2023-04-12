import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drively/models/user.dart';
import 'package:drively/services/group_crud.dart';
import 'package:drively/utility/app_colors.dart';
import 'package:flutter/material.dart';

class AddNumbers extends StatefulWidget {
  String grpName;
  AddNumbers({required this.grpName, super.key});

  @override
  State<AddNumbers> createState() => _AddNumbersState();
}

class _AddNumbersState extends State<AddNumbers> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  List<UserInfoSave> pList = [];
  List<Map<String, dynamic>> userPhones = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  if (pList.isNotEmpty) {
                    for (UserInfoSave user in pList) {
                      setState(() {
                        userPhones.add({
                          "name": user.name,
                          "phone": user.phone!,
                          "role": user.role,
                          "token": user.tokens.last
                        });
                      });
                    }
                    var response = await GroupCrud.addGroup(
                        name: widget.grpName, users: userPhones);
                    print(response.message);
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check))
          ],
          backgroundColor: AppColors.MainBackGroundColor,
          elevation: 0,
          title: Text(
            widget.grpName,
          ),
          shape: Border(
              bottom:
                  BorderSide(color: AppColors.SubBackGroundColor, width: 3)),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return Container(
              decoration: BoxDecoration(color: AppColors.MainBackGroundColor),
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        color: AppColors.SubBackGroundColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _searchController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "Search...",
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Members',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                  SizedBox(
                    width: double.infinity,
                    /* margin: const EdgeInsets.symmetric(vertical: 13.0), */
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (UserInfoSave user in pList)
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                child:
                                    Stack(clipBehavior: Clip.none, children: [
                                  Positioned(
                                    child: CircleAvatar(
                                      radius: 40.0,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              user.name?[0] as String,
                                              style: const TextStyle(
                                                  fontSize: 30.0),
                                            ),
                                            Text(
                                              user.phone as String,
                                              style: const TextStyle(
                                                  fontSize: 10.0),
                                            )
                                          ]),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -10.0,
                                    right: -6.0,
                                    child: Container(
                                        padding: const EdgeInsets.all(2.0),
                                        decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100.0))),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              pList.removeWhere((element) =>
                                                  element.phone == user.phone);
                                            });
                                          },
                                        )),
                                  )
                                ]),
                              ),
                            ]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot<Object?> document =
                            snapshot.data!.docs[index];

                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        if (_searchText.isNotEmpty &&
                            data['name']
                                .toString()
                                .toLowerCase()
                                .contains(_searchText.toLowerCase())) {
                          return ListTile(
                            tileColor: AppColors.SubBackGroundColor,
                            textColor: Colors.white,
                            title: Text(data['name']),
                            subtitle: Text(data['phone']),
                            onTap: () => {
                              if (pList.every((element) =>
                                  element.phone != data['phone'] as String))
                                {
                                  
                                  setState(() {
                                    pList.add(UserInfoSave(data['name'],
                                        data['phone'], "idle", data['token']));
                                  })
                                }
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
