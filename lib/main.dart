import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:hive/hive.dart';
import 'package:ibanshareapp/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'iban_mainscreen.dart';
import 'iban_model.dart';

const String ibanBoxName = "iban";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(IbanModelAdapter());
  await Hive.openBox<IbanModel>(ibanBoxName,
      compactionStrategy: (entries, deletedEntries) {
    return deletedEntries > 50;
  });

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    SystemChrome.setPreferredOrientations(
//        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IBANshare',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.push(context, MaterialPageRoute(builder: (context) {
              return IbansScreen();
            })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: kPrimaryAppColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return IbansScreen();
                            }));
                          },
                          child: Image.asset(
                            "images/ibanshare_icon.png",
                            height: 128.0,
                            width: 128.0,
                          )),
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      Text(
                        "IBANshare",
                        style: kAppBarTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 8.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Loading...",
                      style: kAppBarTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
