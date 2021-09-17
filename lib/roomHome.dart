import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_watcher/file_picker_button.dart';
import 'package:movie_watcher/videoPlayer.dart';
import 'package:video_player/video_player.dart';

class RoomHome extends StatefulWidget {
  RoomHome({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _RoomHomeState createState() => _RoomHomeState();
}

class _RoomHomeState extends State<RoomHome> {
  late final Stream<DocumentSnapshot> _participantStream;
  @override
  void initState() {
    _participantStream = FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.id)
        .snapshots();
    ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: _participantStream,
                    builder: (ctxt, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError)
                        return Text("Something went wrong");
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Text("Loading...");
                      if (snapshot.hasData) {
                        // snapshot.data.data();
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return ListView.separated(
                          itemBuilder: (_, index) {
                            // return Text(snapshot.data!
                            //     .get(FieldPath(['members', index.toString()])));
                            return Text(data['members'][index]['name']);
                          },
                          // itemCount: snapshot.data!.get('members').length,
                          itemCount: data['members'].length,
                          separatorBuilder: (_, index) {
                            return Divider();
                          },
                        );
                      }
                      return Container();
                    }),
              ),
              FilePickerButton(),
            ],
          ),
        ),
      ),
    );
  }
}
