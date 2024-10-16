import 'dart:ui';

import 'package:controllo_palla/coord.dart';
import 'package:controllo_palla/coord_sender.dart';
import 'package:controllo_palla/data_manager.dart';
import 'package:controllo_palla/ip_request.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
    /*DataManager().setDimension(Coord(
        x: MediaQuery.of(context).size.width,
        y: MediaQuery.of(context).size.height));*/
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/ip_request');
            //Navigator.pushNamed(context, '/coord_sender');
          },
          child: const Text('Go to Coord Detect'),
        ),
      ),
    );
  }
}
