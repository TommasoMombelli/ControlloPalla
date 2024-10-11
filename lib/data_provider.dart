import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  String ip = '';

  void setIp(String newIp) {
    ip = newIp;
    notifyListeners();
  }

  String getIp() {
    return ip;
  }
}
