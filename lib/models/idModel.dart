import 'package:flutter/material.dart';

class IdModel extends ChangeNotifier {
  String _roomId = "";
  String _uId = "";

  String get roomId => _roomId;
  String get uId => _uId;

  void changeRoomId(String rooomId) {
    _roomId = rooomId;
    notifyListeners();
  }

  void changeUId(String uId) {
    _uId = uId;
    notifyListeners();
  }

  void removeRoomId() {
    _roomId = "";
    notifyListeners();
  }

  void removeUId() {
    _uId = "";
    notifyListeners();
  }
}
