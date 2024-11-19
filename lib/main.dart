import 'dart:ui';
import 'package:flutter/services.dart';

import 'package:controllo_palla/coord.dart';
import 'package:controllo_palla/coord_sender.dart';
import 'package:controllo_palla/data_manager.dart';
import 'package:controllo_palla/ip_request.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final Color white = const Color.fromRGBO(245, 245, 245, 1);
  final Color black = const Color.fromRGBO(51, 51, 51, 1);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controllo elemento puntiforme',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.cyan.shade500,
            surface: white,
            onSurface: black,
            primary: Colors.cyan.shade500,
            primaryContainer: Colors.cyan.shade500),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.lora(color: white, fontSize: 30),
          titleMedium: GoogleFonts.lora(color: white, fontSize: 20),
          displaySmall: GoogleFonts.lora(color: white, fontSize: 15),
          displayMedium: GoogleFonts.lora(color: white, fontSize: 20),
          bodyMedium: GoogleFonts.lora(color: black, fontSize: 15),
          bodyLarge: GoogleFonts.lora(color: black, fontSize: 25),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Controllo elemento puntiforme'),
      routes: {
        '/ip_request': (context) => const IpRequest(),
        '/coord_sender': (context) => const CoordSender(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    //Ottenimento delle dimensioni dello schermo
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize / view.devicePixelRatio;

    double width = size.width;
    double height = size.height;
    double bottompadding = view.padding.bottom / view.devicePixelRatio;
    double toppadding = view.padding.top / view.devicePixelRatio;
    //Memorizzazione delle dimensioni dello schermo
    DataManager()
        .setDimension(Coord(x: width, y: height + bottompadding + toppadding));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        title:
            Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/ip_request');
            //Navigator.pushNamed(context, '/coord_sender');
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
            child: Text('Inizia connessione',
                style: Theme.of(context).textTheme.displaySmall),
          ),
        ),
      ),
    );
  }
}
