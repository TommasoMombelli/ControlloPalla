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
  bool start = false;

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
      showWinnerPopup();
    }
    if (msg == "start") {
      //aspetta che la telecamera si apra
      Future.delayed(const Duration(milliseconds: 5000), () {
        setState(() {
          start = true;
        });
      });
    }
  }

  //Funzione per iniziare la connessione e inviare il primo messaggio di inizializzazione
  void startConnection() async {
    socketConnection.enableConsolePrint(true);
    await socketConnection.connect(5000, messageReceived, attempts: 3);
    socketConnection
        .sendMessage(DataManager().getDimension().toJson().toString());
  }

  void showWinnerPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Hai vinto",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(15),
                child:
                    Text('OK', style: Theme.of(context).textTheme.displaySmall),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return start ? coordDetector() : waitStart();
  }

  Widget waitStart() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget coordDetector() {
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
                      //showWinnerPopup();
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
