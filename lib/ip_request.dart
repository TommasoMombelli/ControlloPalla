import 'package:controllo_palla/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class IpRequest extends StatefulWidget {
  const IpRequest({super.key});

  @override
  State<IpRequest> createState() => _IpRequestState();
}

class _IpRequestState extends State<IpRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter IP Address'),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: MobileScanner(
            onDetect: (barcodes) {
              DataManager()
                  .setIp(barcodes.barcodes.first.displayValue?.trim() ?? '');
              if (!DataManager().getIsIpSet()) {
                Navigator.pushNamed(context, '/coord_sender');
                setState(() {
                  DataManager().setIsIpSet(true);
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
