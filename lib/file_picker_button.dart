import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerButton extends StatelessWidget {
  FilePickerButton({Key? key, required this.updateFilePath}) : super(key: key);
  Function updateFilePath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
          if (fileResult != null) {
            String? fileName = fileResult.files.single.path;
            print(fileName);
            updateFilePath(fileName);
          }
        },
        child: Text("Select Files"));
  }
}
