import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_watcher/file_picker_button.dart';
import 'package:movie_watcher/models/idModel.dart';
import 'package:movie_watcher/pickOrPlay.dart';
import 'package:movie_watcher/videoPlayer.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class RoomHome extends StatefulWidget {
  RoomHome({Key? key}) : super(key: key);
  @override
  _RoomHomeState createState() => _RoomHomeState();
}

class _RoomHomeState extends State<RoomHome> {
  late final Stream<DocumentSnapshot> _participantStream;
  String _roomId = "";
  String _videoPath = "";

  void updateVideoPath(String filePath) {
    setState(() {
      _videoPath = filePath;
    });
  }

  @override
  void initState() {
    _roomId = Provider.of<IdModel>(context, listen: false).roomId;
    _participantStream =
        FirebaseFirestore.instance.collection('rooms').doc(_roomId).snapshots();
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
              Text("Room ID - " + _roomId),
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
                        print(data);
                        var userList = [];
                        data['members']
                            .forEach((uid, userData) => userList.add(userData));
                        print(userList);
                        return ListView.separated(
                          itemBuilder: (_, index) {
                            // return Text(snapshot.data!
                            //     .get(FieldPath(['members', index.toString()])));
                            return Text(userList[index]['name']);
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
              // FilePickerButton(),
              FilePickerButton(updateFilePath: updateVideoPath),
              ElevatedButton(
                child: Text("Start Movie"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctxt) => ChangeNotifierProvider(
                        create: (ctxt) =>
                            Provider.of<IdModel>(context, listen: false),
                        child: VideoApp(
                          path: _videoPath,
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
