import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ibanshareapp/constants.dart';
import 'package:ibanshareapp/faq_page.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'iban_mainscreen.dart';

const String url = 'https://openiban.com/validate/';

bool isProgress = true;

const spinkit = SpinKitFadingCircle(
  color: kPrimaryAppColor,
  size: 96.0,
);

class IbanResultPage extends StatefulWidget {
  IbanResultPage({this.ibanNo});
  final ibanNo;

  @override
  _IbanResultPageState createState() => _IbanResultPageState();
}

class _IbanResultPageState extends State<IbanResultPage> {
  String isIbanVerified;
  String ibanNumarasi;
  String bankCode;
  String bankName;
  String bankZIP;
  String bankCity;
  String bankBIC;
  String ibanMessage;

  @override
  void initState() {
    super.initState();
    getIbanData(widget.ibanNo);
  }

  void getIbanNow(dynamic ibanData) {
    setState(() {
      if (ibanData != null) {
        isIbanVerified =
            ibanData['valid'] ? getMessage(true) : getMessage(false);
        ibanNumarasi = ibanData['iban'];
        bankCode = ibanData['bankData']['bankCode'] != null
            ? ibanData['bankData']['bankCode']
            : "";
        bankName = ibanData['bankData']['name'] != null
            ? ibanData['bankData']['name']
            : "";
        bankZIP = ibanData['bankData']['zip'] != null
            ? ibanData['bankData']['zip']
            : "";
        bankCity = ibanData['bankData']['city'] != null
            ? ibanData['bankData']['city']
            : "";
        bankBIC = ibanData['bankData']['bic'] != null
            ? ibanData['bankData']['bic']
            : "";
        isProgress = false;
      } else {
        isIbanVerified = 'A problem has occurred. Please try again later!';
        ibanNumarasi =
            'Cannot parse as IBAN: IBAN length invalid or IBAN number is incorrect!.';
        bankCode = "";
        bankName = "";
        bankZIP = "";
        bankCity = "";
        bankBIC = "";
      }
    });
  }

  Future getIbanData(String ibanNo) async {
    try {
      http.Response response =
          await http.get("$url$ibanNo?getBIC=true&validateBankCode=true");

      if (response.statusCode == 200) {
        dynamic decodedData = jsonDecode(response.body);
        return getIbanNow(decodedData);
      } else {
        showErrorMessage(
            "There is a problem with the request. Please check your network connection and try later.",
            3);
      }
    } catch (e) {
      Dialogs.showLoadingDialog(context, _thisScaffoldKey);
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(context, MaterialPageRoute(builder: (context) {
                return IbansScreen();
              })));
    }
  }

  String getMessage(bool isIbanValid) {
    if (isIbanValid == true) {
      return 'IBAN number is VALID!';
    } else if (isIbanValid == false) {
      return 'IBAN number is INVALID.\nIBAN length invalid or number is incorrect!';
    } else {
      return 'A problem has occurred. Please try again later!';
    }
  }

  static final GlobalKey<ScaffoldState> _thisScaffoldKey =
      GlobalKey<ScaffoldState>();

  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _thisScaffoldKey,
        body: Container(
          height: 640.0,
          color: kPrimaryAppColor,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 32.0,
                        color: kPrimaryIconColor,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FaqPage();
                        }));
                      },
                      child: Icon(
                        Icons.help,
                        size: 32.0,
                        color: kPrimaryIconColor,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    color: kPrimaryBackgroundColor,
                    padding: EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "$isIbanVerified",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Container(
                            child: Text(
                              "$ibanNumarasi",
                              textAlign: TextAlign.center,
                              style: kAppBarTextStyle,
                            ),
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: kPrimaryAppColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "Bank Name: $bankName",
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "Bank Code: $bankCode",
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "Bank ZIP: $bankZIP",
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "Bank City: $bankCity",
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "Bank BIC: $bankBIC",
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 64.0,
                          ),
                          isProgress ? spinkit : Text(' '),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final RenderBox box = context.findRenderObject();
            Share.share(
                "Iban No: $ibanNumarasi\nBank Name: $bankName\nBank Code: $bankCode\nBank ZIP: $bankZIP\nBank City: $bankCity\nBank BIC: $bankBIC\n",
                subject: 'Hi, here is the IBAN number and details!',
                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
          },
          child: Icon(
            Icons.share,
            size: 36.0,
          ),
          foregroundColor: kPrimaryIconColor,
          backgroundColor: kPrimaryAppColor,
          elevation: 2.0,
          mini: false,
        ),
        bottomNavigationBar: Container(
          color: kPrimaryBackgroundColor,
          child: BottomAppBar(
            color: kPrimaryAppColor,
            shape: CircularNotchedRectangle(),
            notchMargin: 4,
            child: Container(
              height: 50.0,
            ),
          ),
        ),
        floatingActionButtonLocation: _fabLocation,
      ),
    );
  }
}
