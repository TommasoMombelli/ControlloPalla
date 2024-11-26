import 'package:flutter/services.dart';

import 'package:controllo_palla/coord_sender.dart';
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
      title: 'Controllo remoto di una pallina',
      //Tema dell'applicazione
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
          displaySmall: GoogleFonts.lora(color: white, fontSize: 17),
          displayMedium: GoogleFonts.lora(color: white, fontSize: 20),
          bodySmall: GoogleFonts.lora(color: black, fontSize: 16),
          bodyMedium: GoogleFonts.lora(color: black, fontSize: 22),
          bodyLarge: GoogleFonts.lora(color: black, fontSize: 25),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Controllo remoto di una pallina'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
              ),
              child: Text(
                'Connettere il dispositivo alla\nstessa rete wi-fi del computer',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            //Pulsante per iniziare la connessione
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.4),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/ip_request');
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
                  child: Text('Inizia connessione',
                      style: Theme.of(context).textTheme.displaySmall),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
