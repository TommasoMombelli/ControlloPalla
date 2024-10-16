import 'dart:ui';

import 'package:controllo_palla/coord.dart';
import 'package:controllo_palla/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class CoordSender extends StatefulWidget {
  const CoordSender({super.key});

  @override
  State<CoordSender> createState() => _CoordSenderState();
}

class _CoordSenderState extends State<CoordSender> {
  TcpSocketConnection socketConnection =
      TcpSocketConnection(DataManager().getIp(), DataManager().getPort());
  Coord coord = Coord(x: 0, y: 0);
  String message = '';
  bool dimensionSet = false;

  @override
  void initState() {
    super.initState();
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

    // Dimensions in physical pixels (px)
    Size size = view.physicalSize / view.devicePixelRatio;

    double width = size.width;
    double height = size.height;
    double bottompadding = view.padding.bottom / view.devicePixelRatio;
    double toppadding = view.padding.top / view.devicePixelRatio;
    DataManager()
        .setDimension(Coord(x: width, y: height + bottompadding + toppadding));
    startConnection();
  }

  void messageReceived(String msg) {
    print(msg);
  }

  void startConnection() async {
    socketConnection.enableConsolePrint(true);
    await socketConnection.connect(5000, messageReceived, attempts: 3);
    socketConnection
        .sendMessage(DataManager().getDimension().toJson().toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          coord =
              Coord(x: details.localPosition.dx, y: details.localPosition.dy);
        });
        message = "${coord.toJson().toString()};";
        socketConnection.sendMessage(message);
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(coord.toString()),
                Text(DataManager().getIp()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
