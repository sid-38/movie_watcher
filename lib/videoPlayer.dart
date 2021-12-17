// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:movie_watcher/file_picker_button.dart';
import 'package:movie_watcher/models/idModel.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  String path;
  VideoApp({Key? key, required this.path}) : super(key: key);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController? _controller;
  late Stream _documentStream;
  bool isPlaying = false;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(Provider.of<IdModel>(context, listen: false).id)
        .snapshots()
        .listen((event) {
      // print(event.get("play"));
      bool localIsPlaying = event.get("play");
      setState(() {
        isPlaying = localIsPlaying;
      });
      localIsPlaying ? _controller!.play() : _controller!.pause();
    });
    if (widget.path != "") {
      _controller = VideoPlayerController.file(File(widget.path))
        ..initialize().then((_) {
          setState(() {});
        });
    }

    super.initState();
  }
  // String? _path;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: null,
            builder: (context, snapshot) {
              return Center(
                child: _controller != null && _controller!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                    : Container(
                        // child: FilePickerButton(
                        //   updateFilePath: updateVideoPath,
                        // ),
                        ),
              );
            }),
        floatingActionButton: (_controller != null)
            ? FloatingActionButton(
                onPressed: () {
                  DocumentReference room = FirebaseFirestore.instance
                      .collection('rooms')
                      .doc(Provider.of<IdModel>(context, listen: false).id);
                  bool? remotePlayValue;
                  room.get().then((docSnapshot) {
                    remotePlayValue = docSnapshot.get("play");

                    if (remotePlayValue != null) {
                      if (remotePlayValue == true)
                        room.update({'play': false}).then((value) {
                          print("Remote play updated to false");
                        });
                      if (remotePlayValue == false)
                        room.update({'play': true}).then((value) {
                          print("Remote play updated to true");
                        });
                    }
                  });

                  // setState(() {
                  //   _controller!.value.isPlaying
                  //       ? _controller!.pause()
                  //       : _controller!.play();
                  // });
                },
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}
