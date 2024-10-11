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

  @override
  void initState() {
    super.initState();
    startConnection();
  }

  void messageReceived(String msg) {
    print(msg);
  }

  void startConnection() async {
    socketConnection.enableConsolePrint(
        true); //use this to see in the console what's happening
    // if(await socketConnection.canConnect(5000, attempts: 3)){   //check if it's possible to connect to the endpoint
    await socketConnection.connect(5000, messageReceived, attempts: 3);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          coord =
              Coord(x: details.localPosition.dx, y: details.localPosition.dy);
        });
        socketConnection.sendMessage(coord.toJson().toString());
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
