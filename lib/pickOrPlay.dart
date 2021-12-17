import 'dart:io';
import 'package:flutter/material.dart';
import 'package:movie_watcher/file_picker_button.dart';
import 'package:movie_watcher/videoPlayer.dart';

class PickOrPlay extends StatefulWidget {
  PickOrPlay({Key? key}) : super(key: key);

  @override
  State<PickOrPlay> createState() => _PickOrPlayState();
}

class _PickOrPlayState extends State<PickOrPlay> {
  String path = "";

  void updateVideoPath(String filePath) {
    setState(() {
      path = filePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (path == "")
          ? FilePickerButton(updateFilePath: updateVideoPath)
          : VideoApp(
              path: path,
            ),
    );
  }
}
