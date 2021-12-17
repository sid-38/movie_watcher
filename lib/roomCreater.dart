import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_watcher/models/idModel.dart';
import 'package:movie_watcher/name_enter.dart';
import 'package:movie_watcher/roomHome.dart';
import 'package:movie_watcher/utils/randomGen.dart';
import 'package:provider/provider.dart';

class RoomCreater extends StatelessWidget {
  const RoomCreater({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference rooms = FirebaseFirestore.instance.collection('rooms');
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Center(
        child: ElevatedButton(
          child: Text("Create Room"),
          onPressed: () {
            String id = getRandomString(6);
            String? name;
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctxt) {
                  return NameEnter(onNext: (String _name) {
                    name = _name;
                  });
                }).then((value) {
              print(name);
              rooms.doc(id).set({
                'creator': FirebaseAuth.instance.currentUser!.uid.toString(),
                "play": false,
                'members': [
                  {
                    'uid': FirebaseAuth.instance.currentUser!.uid.toString(),
                    'name': name
                  }
                ]
              }).then((value) {
                print("Room Created");
                Provider.of<IdModel>(context, listen: false).changeId(id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctxt) => ChangeNotifierProvider(
                      create: (ctxt) =>
                          Provider.of<IdModel>(context, listen: false),
                      child: RoomHome(),
                    ),
                  ),
                );
              }).catchError((error) => print("Error $error"));
            });
          },
        ),
      )),
    );
  }
}
