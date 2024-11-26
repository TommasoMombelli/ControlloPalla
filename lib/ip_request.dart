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
  void initState() {
    super.initState();
    //L'ip viene resettato per permettere (se necessario) una connessione con un dispositivo diverso
    DataManager().resetIp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            //Scanner per codici QR
            MobileScanner(
              onDetect: (barcodes) {
                //Memorizzazione dell'ip letto
                DataManager()
                    .setIp(barcodes.barcodes.first.displayValue?.trim() ?? '');
                //Evita di aprire la pagina di invio coordinate più di una volta
                if (!DataManager().getIsIpSet()) {
                  Navigator.pushNamed(context, '/coord_sender');
                  setState(() {
                    DataManager().setIsIpSet(true);
                  });
                }
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Inquadra il QR code per connettere il dispositivo',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            //Freccia per tornare indietro
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
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
                  ],
                ),
              ],
            ),
            //Riquadro per inquadrare il codice QR
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
              child: CustomPaint(
                painter: BorderPainter(
                    color: Theme.of(context).colorScheme.onSurface),
                child: Container(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Classe per disegnare il riquadro per inquadrare il codice QR
class BorderPainter extends CustomPainter {
  BorderPainter({required this.color});

  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height;
    double sw = size.width;
    double cornerSide = sh * 0.1;

    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
