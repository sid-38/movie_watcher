import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerButton extends StatelessWidget {
  FilePickerButton({Key? key}) : super(key: key);
  String? path;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
          if (fileResult != null) {
            path = fileResult.files.single.path;
          }
        },
        child: Text("Select Files"));
  }
}
