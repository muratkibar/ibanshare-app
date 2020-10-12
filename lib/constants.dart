import 'package:flutter/material.dart';

SnackBar showErrorMessage(String errorMessage, int errorDurationTime) {
  return SnackBar(
    content: Text(errorMessage),
    duration: Duration(seconds: errorDurationTime),
  );
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: kPrimaryAppColor,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please check the connection settings....",
                          style: kNameFieldTextStyle,
                        )
                      ]),
                    ),
                  ]));
        });
  }
}

const kPrimaryAppName = Text(
  'IBANshare',
  style: TextStyle(
    color: Color(0xFF212121),
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'AvertaBold',
    letterSpacing: 1.0,
  ),
);
const kPrimaryAppColor = Color(0xFFffc903);
const kAppBarTextStyle = TextStyle(
  color: Color(0xFF212121),
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'AvertaBold',
  letterSpacing: 1.0,
);

const kIbanFieldTextStyle = TextStyle(
  fontWeight: FontWeight.normal,
  fontFamily: 'AvertaRegular',
  fontSize: 14.0,
  color: Color(0xFF212121),
);
const kNameFieldTextStyle = TextStyle(
  fontWeight: FontWeight.normal,
  fontFamily: 'AvertaBold',
  fontSize: 14.0,
  color: Colors.black,
);
const kDialogFieldTextStyle = TextStyle(
  fontWeight: FontWeight.normal,
  fontFamily: 'AvertaRegular',
  fontSize: 16.0,
  color: Colors.black,
);

const kPrimaryIconColor = Color(0xFF525252);
const kPrimaryTextWhite = Colors.white;
const kPrimaryBackgroundColor = Colors.white;
const kListTileBackgroundColor = Colors.white;
