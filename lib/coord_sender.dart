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
  //Variabili
  //Connessione tramite socket server
  TcpSocketConnection socketConnection =
      TcpSocketConnection(DataManager().getIp(), DataManager().getPort());
  //Coordinate del tocco
  Coord coord = Coord(x: 0, y: 0);

  @override
  void initState() {
    super.initState();

    startConnection();
  }

  void messageReceived(String msg) {
    print(msg);
  }

  //Funzione per iniziare la connessione e inviare il primo messaggio di inizializzazione
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
        //invio delle coordinate tramite socket
        String message = "${coord.toJson().toString()};";
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
