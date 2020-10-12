import 'package:http/http.dart' as http;
import 'dart:convert';

const String url = 'https://openiban.com/validate/';

class IbanChecker {

 Future getIbanData(String ibanNo) async {

    http.Response response = await http.get("$url$ibanNo?getBIC=true&validateBankCode=true");

    if (response.statusCode == 200) {
      String decodedData = jsonDecode(response.body);
      return jsonDecode(decodedData);
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }

 String getMessage(bool isIbanValid) {
   if (isIbanValid == true) {
     return 'VALID! This IBAN number is correct.';
   } else if (isIbanValid == false) {
     return 'INVALID! This IBAN number is incorrect. Make sure typed correctly!';
   } else {
     return 'A problem has occurred. Please try again later!';
   }
 }


}

