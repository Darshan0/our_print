import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class VoucherScanQrPage extends StatefulWidget {
  @override
  VoucherScanQrPageState createState() {
    return VoucherScanQrPageState();
  }
}

class VoucherScanQrPageState extends State<VoucherScanQrPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController _controller;
  Barcode _result;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [_getScannerPreview(), _getScannerOverlay()],
        ),
      ),
    );
  }

  Widget _getScannerPreview() {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _result = scanData;
      });
    });
  }

  Widget _getScannerOverlay() {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          top: 80,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _scanQrCodeString,
              style: TextStyle(
                fontSize: 40,
                color: Color(0xFF53905F),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 40),
              child: Center(
                child: SizedBox(
                  height: 300.0,
                  width: 300.0,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 2.0)),
                  ),
                ),
              ),
            ),
            Text(
              _scanQrCodeDescriptionString,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF53905F),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Constants

final String _scanQrCodeString = "Scan the QR code";
final String _scanQrCodeDescriptionString =
    "Make sure the QR code is in the middle of the box";
