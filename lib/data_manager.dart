import 'package:controllo_palla/coord.dart';

class DataManager {
  DataManager._privateConstructor();

  static final DataManager _instance = DataManager._privateConstructor();

  factory DataManager() {
    return _instance;
  }

  //Variabili
  String _ip = '';
  int _port = 5000;
  bool _isIpSet = false;
  Coord _dimension = Coord(x: 0, y: 0);

  void setIp(String newIp) {
    _ip = newIp;
  }

  String getIp() {
    return _ip;
  }

  void setPort(int newPort) {
    _port = newPort;
  }

  int getPort() {
    return _port;
  }

  void resetIp() {
    _ip = '';
    _isIpSet = false;
  }

  void setIsIpSet(bool isIpSet) {
    _isIpSet = isIpSet;
  }

  bool getIsIpSet() {
    return _isIpSet;
  }

  void setDimension(Coord newDimension) {
    _dimension = newDimension;
  }

  Coord getDimension() {
    return _dimension;
  }
}
