// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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

  double? sliderValInTransition;
  // int? previousPositionInMilliSeconds;
  int? previousPositionTimeStamp;

  @override
  void initState() {
    var doc = FirebaseFirestore.instance
        .collection('rooms')
        .doc(Provider.of<IdModel>(context, listen: false).roomId);

    doc.snapshots(includeMetadataChanges: true).listen((event) {
      print("PENDING WRITES : " + event.metadata.hasPendingWrites.toString());
      if (!event.metadata.hasPendingWrites) {
        print(event.metadata.hashCode);
        var remoteData = event.data();
        // bool localIsPlaying = event.get("play");
        bool? isPlaying = remoteData!['play'];
        int? positionInMilliSeconds = remoteData['position'];
        int? positionTimeStamp = remoteData['positionTimeStamp'];
        if (positionInMilliSeconds != null &&
            positionTimeStamp != previousPositionTimeStamp) {
          // print("HELLOOOO");
          // doc.update({'position': FieldValue.delete()});z
          _controller!.seekTo(Duration(milliseconds: positionInMilliSeconds));
          setState(() {
            previousPositionTimeStamp = positionTimeStamp;
          });
        }
        if (isPlaying != null)
          isPlaying ? _controller!.play() : _controller!.pause();
      }
    });
    if (widget.path != "") {
      _controller = VideoPlayerController.file(File(widget.path))
        ..initialize().then((_) {
          setState(() {});
        });
    }

    super.initState();
  }

  Future<void> updatePosition(int positionInMilliSeconds) {
    DocumentReference room = FirebaseFirestore.instance
        .collection('rooms')
        .doc(Provider.of<IdModel>(context, listen: false).roomId);
    return room.update({
      'position': positionInMilliSeconds,
      'positionTimeStamp': DateTime.now().millisecondsSinceEpoch
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _controller != null && _controller!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                    : Container(),
              ),
            ),
            Container(
              child: ValueListenableBuilder(
                valueListenable: _controller!,
                builder: (context, VideoPlayerValue value, child) {
                  // print(value.position);
                  // print(value.duration);
                  double sliderVal = 0.0;
                  if (value.position.inMilliseconds != 0 &&
                      value.position.inMilliseconds != 0)
                    sliderVal = value.position.inMilliseconds /
                        value.duration.inMilliseconds;
                  // print(sliderVal);
                  return Column(
                    children: [
                      Slider(
                          value: sliderValInTransition ?? sliderVal,
                          onChanged: (value) {
                            setState(() {
                              sliderValInTransition = value;
                            });
                          },
                          onChangeEnd: (time) {
                            updatePosition((_controller!
                                            .value.duration.inMilliseconds *
                                        time)
                                    .round())
                                .then((_) {
                              setState(() {
                                sliderValInTransition = null;
                              });
                            });
                            print(time);
                            // _controller!
                            //     .seekTo(_controller!.value.duration * time);
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              _controller!.position.then((value) {
                                if (value != null)
                                  updatePosition(value.inMilliseconds - 10000);
                                // _controller!.seekTo(
                                //     Duration(seconds: value.inSeconds - 10));
                              });
                            },
                            icon: Icon(Icons.arrow_left),
                          ),
                          IconButton(
                            onPressed: () {
                              DocumentReference room = FirebaseFirestore
                                  .instance
                                  .collection('rooms')
                                  .doc(Provider.of<IdModel>(context,
                                          listen: false)
                                      .roomId);
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
                            },
                            icon: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _controller!.position.then((value) {
                                if (value != null)
                                  updatePosition(value.inMilliseconds + 10000);
                                // _controller!.seekTo(
                                //     Duration(seconds: value.inSeconds + 10));
                              });
                            },
                            icon: Icon(Icons.arrow_right),
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     var doc = FirebaseFirestore.instance
                          //         .collection('rooms')
                          //         .doc(Provider.of<IdModel>(context,
                          //                 listen: false)
                          //             .roomId);
                          //     doc.update({'position': FieldValue.delete()});
                          //   },
                          //   icon: Icon(Icons.ac_unit),
                          // )
                        ],
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );

    // @override
    // void dispose() {
    //   super.dispose();
    //   _controller!.dispose();
    // }
  }
}
