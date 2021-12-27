import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movie_watcher/models/idModel.dart';
import 'package:movie_watcher/name_enter.dart';
import 'package:movie_watcher/roomHome.dart';
import 'package:provider/provider.dart';

class RoomJoiner extends StatelessWidget {
  RoomJoiner({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  String _roomId = "";
  @override
  Widget build(BuildContext context) {
    CollectionReference rooms = FirebaseFirestore.instance.collection('rooms');
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            child: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter the Room Code",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter some text';
                  return null;
                },
                onChanged: (value) {
                  _roomId = value;
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
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
                  rooms.doc(_roomId).update({
                    'members.' +
                        FirebaseAuth.instance.currentUser!.uid.toString(): {
                      'uid': FirebaseAuth.instance.currentUser!.uid.toString(),
                      'name': name,
                      'isFileChosen': false
                    }
                  }).then((value) {
                    print("Room Created");
                    Provider.of<IdModel>(context, listen: false)
                        .changeRoomId(_roomId);
                    Provider.of<IdModel>(context, listen: false).changeUId(
                        FirebaseAuth.instance.currentUser!.uid.toString());
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
              }
            },
            icon: Icon(Icons.arrow_right),
          )
        ],
      ),
    );
  }
}
