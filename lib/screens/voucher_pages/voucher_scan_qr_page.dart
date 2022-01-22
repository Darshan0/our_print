import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ourprint/model/voucher_model/qrcode_model.dart';
import 'package:ourprint/my_html_viewer.dart';
import 'package:ourprint/repository/voucher_repo.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'coins_addition.dart';

class VoucherScanQrPage extends StatefulWidget {
  @override
  VoucherScanQrPageState createState() {
    return VoucherScanQrPageState();
  }
}

class VoucherScanQrPageState extends State<VoucherScanQrPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController _controller;
  String _result;
  List<QrCodeModel> _qrCodes;

  @override
  void initState() {
    _getAllValidQrCodes();
    super.initState();
  }

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
      _validateScannedQrCode(scanData.code);
      print(scanData.code);
    });
  }

  Widget _getScannerOverlay() {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          top: 30,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF53905F),
                    size: 40,
                  ),
                ),
                _controller != null
                    ? GestureDetector(
                        onTap: () {
                          _controller.resumeCamera();
                        },
                        child: Icon(
                          Icons.refresh,
                          color: Color(0xFF53905F),
                          size: 40,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
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
            _getBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _getBottomSection() {
    return _qrCodes != null
        ? Text(
            _scanQrCodeDescriptionString,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF53905F),
            ),
          )
        : Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text(
                  _qrCodeLoadingString,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF53905F),
                  ),
                )
              ],
            ),
          );
  }

  void _redeemVoucherDialog(String qrCode) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Confirmation",
      desc: "Are you sure you want to redeem this code?",
      closeFunction: () {
        Navigator.of(context).pop();
        _controller.resumeCamera();
      },
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {

            final response = {
              "id": 21,
              "code": "ENMZ0MJXMY",
              "generated_date": "2021-11-27T09:22:26.253077Z",
              "value": 123.0,
              "validity": "2021-11-27T03:05:00Z",
              "company": "digiigo",
              "count": 123445.0,
              "image":
                  "https://ourprint.s3.amazonaws.com/multimedia/20210909_225545_0000_2Jqt31i.png",
              "redirection_url": "www.google.com",
              "is_active": true
            };

            //final Map response = await VoucherRepo.scanQrCode(qrCode);
            if (!response.containsKey("error")) {
              if (response.containsKey("image")) {
                if (response["image"] != "") {
                  double coinValueDouble = response["value"];
                  int coinValue = coinValueDouble.toInt();
                  Navigator.of(context).pop();
                  _showImageOrUrl(
                    response["image"],
                    true,
                    coinValue,
                  );
                }
              }
              if (response.containsKey("redirection_url")) {
                if (response["redirection_url"] != "") {
                  double coinValueDouble = response["value"];
                  int coinValue = coinValueDouble.toInt();
                  Navigator.of(context).pop();
                  _showImageOrUrl(
                    response["redirection_url"],
                    false,
                    coinValue,
                  );
                }
              }
            } else {
              Navigator.of(context).pop();
              Alert(
                context: context,
                title: 'Something went wrong !',
                desc: 'QR code already scanned or claimed.',
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Color.fromRGBO(83, 144, 95, 1.0),
                  ),
                ],
              ).show();
            }
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  void _showImageOrUrl(String url, bool isImage, int coinValue) {
    isImage != true
        ? showDialog(
            barrierDismissible: false,
            context: context,
            builder: (builder) {
              return Container(
                padding: const EdgeInsets.all(20.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        WebView(
                          initialUrl: url,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ArgonTimerButton(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.45,
                            initialTimer: 5,
                            onTap: (startTimer, btnState) {
                              if (btnState == ButtonState.Idle) {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return CoinsAddition(
                                      coinValue: coinValue,
                                    );
                                  }),
                                );
                              }
                            },
                            child: Text(
                              "Claim coins",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            loader: (timeLeft) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                margin: EdgeInsets.all(5),
                                alignment: Alignment.center,
                                width: 40,
                                height: 40,
                                child: Text(
                                  "$timeLeft",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            },
                            borderRadius: 20.0,
                            color: Color(0xFF53905F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : showDialog(
            barrierDismissible: false,
            context: context,
            builder: (builder) {
              return Container(
                padding: const EdgeInsets.all(20.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Center(
                          child: Image.network(
                            url,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ArgonTimerButton(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.45,
                            initialTimer: 5,
                            onTap: (startTimer, btnState) {
                              if (btnState == ButtonState.Idle) {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return CoinsAddition(
                                      coinValue: coinValue,
                                    );
                                  }),
                                );
                              }
                            },
                            child: Text(
                              "Claim coins",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                            loader: (timeLeft) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                margin: EdgeInsets.all(5),
                                alignment: Alignment.center,
                                width: 40,
                                height: 40,
                                child: Text(
                                  "$timeLeft",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            },
                            borderRadius: 20.0,
                            color: Color(0xFF53905F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  void _getAllValidQrCodes() async {
    final qrCodes = await VoucherRepo.getQrCodes();
    setState(() {
      _qrCodes = qrCodes;
    });
  }

  void _validateScannedQrCode(String code) {
    _qrCodes.forEach((element) {
      if (element.code == code) {
        _controller.pauseCamera();
        _redeemVoucherDialog(code);
      }
    });
  }
}

// Constants

final String _scanQrCodeString = "Scan the QR code";
final String _scanQrCodeDescriptionString =
    "Make sure the QR code is in the middle of the box";
final String _qrCodeLoadingString =
    "Please wait while we fetch the QR codes details.";



// {
// id: 21,
// code: "ENMZ0MJXMY",
// generated_date: "2021-11-27T09:22:26.253077Z",
//  value: 123.0,
//       validity: "2021-11-27T03:05:00Z",
//         company: "digiigo",
//        count: 123445.0,
//        image: "https://ourprint.s3.amazonaws.com/multimedia/20210909_225545_0000_2Jqt31i.png",
//        redirection_url: "",
//         is_active: true
//  } 
// final response = {
            //   "id": 21,
            //   "code": "ENMZ0MJXMY",
            //   "generated_date": "2021-11-27T09:22:26.253077Z",
            //   "value": 123.0,
            //   "validity": "2021-11-27T03:05:00Z",
            //   "company": "digiigo",
            //   "count": 123445.0,
            //   "image":
            //       "https://ourprint.s3.amazonaws.com/multimedia/20210909_225545_0000_2Jqt31i.png",
            //   "redirection_url": "",
            //   "is_active": true
            // };

            // final response = {
            //   "id": 21,
            //   "code": "ENMZ0MJXMY",
            //   "generated_date": "2021-11-27T09:22:26.253077Z",
            //   "value": 123.0,
            //   "validity": "2021-11-27T03:05:00Z",
            //   "company": "digiigo",
            //   "count": 123445.0,
            //   "image": "",
            //   "redirection_url": "https://pub.dev/",
            //   "is_active": true
            // };