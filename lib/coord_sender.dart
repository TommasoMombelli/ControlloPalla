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
  //Connessione tramite socket server
  TcpSocketConnection socketConnection =
      TcpSocketConnection(DataManager().getIp(), DataManager().getPort());
  //Coordinate del tocco
  Coord coord = Coord(x: 0, y: 0);
  //Flags per mostrare il cursore e iniziare il gioco
  bool showCursor = false;
  bool start = false;

  @override
  void initState() {
    super.initState();
    //Connessione
    startConnection();
  }

  @override
  void dispose() {
    //Invio del messagio "close" per chiudere la connessione
    socketConnection.sendMessage("close");
    //Disconnessione
    socketConnection.disconnect();
    //Reset dell'ip per permettere una nuova connessione
    DataManager().resetIp();
    super.dispose();
  }

  //Funzione per ricevere i messaggi dal server
  void messageReceived(String msg) {
    //In caso di vittoria viene mostrato un popup
    if (msg == "winner") {
      showWinnerPopup();
    }
    //Messaggio necessario per iniziare ad inviare le coordinate
    //per evitare che vengano inviate prima che il pc sia pronto
    if (msg == "start") {
      //Aspetta che la telecamera del pc si apra
      Future.delayed(const Duration(milliseconds: 4000), () {
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
    //Invio delle dimensioni dello schermo
    double width = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    Coord dimensions = Coord(x: width, y: totalHeight);
    socketConnection.sendMessage(dimensions.toJson().toString());
  }

  //Popup per la vittoria
  void showWinnerPopup() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Hai vinto!!",
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
                      offset: Offset(0, 3),
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

  //Widget per l'attesa dell'inizio dell'invio dati
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

  //Widget per inviare le coordinate tramite socket
  Widget coordDetector() {
    return GestureDetector(
      //Gestione del cursore
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
      //Invio delle coordinate
      onPanUpdate: (details) {
        setState(() {
          coord =
              Coord(x: details.localPosition.dx, y: details.localPosition.dy);
        });
        //Invio delle coordinate tramite socket
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
                //Freccia per tornare indietro
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
                //Testo per spiegare il funzionamento
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.5,
                  child: Text(
                    "Muovere il dito per controllare la pallina",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                //Cursore
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
