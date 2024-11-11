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
  bool showCursor = false;

  @override
  void initState() {
    super.initState();

    startConnection();
  }

  @override
  void dispose() {
    socketConnection.sendMessage("close");
    socketConnection.disconnect();
    DataManager().resetIp();
    super.dispose();
  }

  void messageReceived(String msg) {
    if (msg == "winner") {
      //socketConnection.disconnect();
      Navigator.of(context).pop();
    }
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
      onPanStart: (details) {
        setState(() {
          showCursor = true;
        });
      },
      onPanEnd: (details) {
        setState(() {
          showCursor = false;
        });
      },
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                showCursor
                    ? Positioned(
                        left: coord.x - 20,
                        top: coord.y - 20,
                        child: Icon(
                          Icons.circle_outlined,
                          shadows: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 0),
                            ),
                          ],
                          color: Colors.grey.withOpacity(0.2),
                          size: 35,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
