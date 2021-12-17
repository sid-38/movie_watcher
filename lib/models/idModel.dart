import 'package:flutter/material.dart';

class IdModel extends ChangeNotifier {
  String _id = "";

  String get id => _id;

  void changeId(String id) {
    _id = id;
    notifyListeners();
  }

  void removeId() {
    _id = "";
    notifyListeners();
  }
}
