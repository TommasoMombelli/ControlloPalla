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

  @override
  void initState() {
    super.initState();
    startConnection();
  }

  void messageReceived(String msg) {
    print(msg);
  }

  void startConnection() async {
    socketConnection.enableConsolePrint(true);
    await socketConnection.connect(5000, messageReceived, attempts: 3);
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
        body: Center(
            child: Column(
          children: [
            Text(coord.toString()),
            Text(DataManager().getIp()),
          ],
        )),
      ),
    );
  }
}
