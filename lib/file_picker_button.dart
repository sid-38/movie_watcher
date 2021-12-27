import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:movie_watcher/models/idModel.dart';
import 'package:provider/provider.dart';

class FilePickerButton extends StatelessWidget {
  FilePickerButton({Key? key, required this.updateFilePath}) : super(key: key);
  Function updateFilePath;

  void setFileStatus(BuildContext context, bool status) {
    String _uid = Provider.of<IdModel>(context, listen: false).uId;
    String _roomId = Provider.of<IdModel>(context, listen: false).roomId;
    DocumentReference _roomDoc =
        FirebaseFirestore.instance.collection('rooms').doc(_roomId);
    String path = "members." + _uid + ".isFileChosen";
    print(path);
    _roomDoc.update({path: true});
    // _roomDoc.update({
    //   'members': {
    //     _uid: {'isFileChosen': false}
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
          if (fileResult != null) {
            String? fileName = fileResult.files.single.path;
            print(fileName);
            setFileStatus(context, true);
            updateFilePath(fileName);
          }
        },
        child: Text("Select Files"));
  }
}
