import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drively/services/user_crud.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _GroupCollection = _firestore.collection('groups');

class GroupCrud {
//CRUD method here
//create
  static Future<Response> addGroup(
      {required String name, required List<Map<String, dynamic>> users}) async {
    Response response = Response();
    DocumentReference documentReferencer = _GroupCollection.doc();

    Map<String, dynamic> data = <String, dynamic>{"name": name, "users": users};

    final result = await documentReferencer.set(data).whenComplete(() async {
      for (var user in users) {
        await UserCrud.updateUserGroup(
            group: documentReferencer.id, phone: user['phone']);
      }
      response.code = 200;
      response.message = "Sucessfully added the group";
    }).catchError((e) {
      print(e);
      response.code = 500;
      response.message = e;
    });

    return response;
  }

//read
  static Stream<QuerySnapshot> readGroups({required String grpid}) {
    CollectionReference notesItemCollection = _GroupCollection;

    return notesItemCollection.snapshots();
  }

//reading all users

}
