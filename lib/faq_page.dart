import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:expandable/expandable.dart';

class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: kPrimaryAppColor,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  Text("IBANshare FAQ", style: kAppBarTextStyle,),
                ],
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0),
                    width: double.infinity,
                    color: kPrimaryBackgroundColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ExpandablePanel(
                            header: Text("How to add an IBAN?", style: TextStyle(color: kPrimaryAppColor, fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            expanded: Text("You may just click the floating add icon button at the bottom of the main page. When clicked, then a form including text fields will be popped up. You then submit IBAN number and a given description.\n", softWrap: true, ),
                          ),
                          ExpandablePanel(
                            header: Text("How to update an IBAN?", style: TextStyle(color: kPrimaryAppColor, fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            expanded: Text("You may just click the edit icon on main page. When text fields form pops up, then type updated details into any field, finally click update button.\n\nREMEMBER:\nYou may enter updated detail into any fields whichever you want to update either IBAN number or description field.\n", softWrap: true, ),
                          ),
                          ExpandablePanel(
                            header: Text("How to share IBAN details?", style: TextStyle(color: kPrimaryAppColor, fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            expanded: Text("You have two options in order to share IBANs. You may share only the number of IBAN. To do so, you can just click the share icon on the main page. If you'd like to share all details for an IBAN, you do the check for the IBAN first, then click the share button in the opening page.\n", softWrap: true, ),
                          ),
                          ExpandablePanel(
                            header: Text("How to delete an IBAN?", style: TextStyle(color: kPrimaryAppColor, fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            expanded: Text("You may just click the delete icon on main page. When approval message pops up, then click delete button.\n\nREMEMBER:\nThe deletion process of a record cannot be undone. If you deleted a record unintentionally, you need to submit new entry again.\n", softWrap: true, ),
                          ),
                          ExpandablePanel(
                            header: Text("How to bookmark an IBAN?", style: TextStyle(color: kPrimaryAppColor, fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            expanded: Text("You may just click the bookmark icon on main page. When clicked, then IBAN will be added to your bookmarks. You may filter bookmarked or other IBANs by clicking filter icon at top right of main page.\n", softWrap: true, ),
                          ),
                          ExpandablePanel(
                            header: Text("Which countries supported?", style: TextStyle(color: kPrimaryAppColor, fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            expanded: Text("We currently validate Bank codes for the following countries:\n\nBelgium\nGermany\nNetherlands\nLuxembourgh\nSwitzerland\nAustria\nLeichtenstein\n\nMore is coming...\n", softWrap: true, ),
                          ),
                          ExpandablePanel(
                            header: Text("How does it work IBAN validation?", style: TextStyle(color: kPrimaryAppColor, fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            expanded: Text("Validation currently works by checking validity of the IBAN checksum and the length restriction for country specific IBAN numbers. A list of country specific BIC checks can be found above. If the validation result is valid, the IBAN is technically OK for the specific country.\n\nREMEMBER:\nEven technically valid IBANs might still contain a crafted bank code or account number.\n", softWrap: true, ),
                          ),
                          ExpandablePanel(
                            header: Text("What is privacy policy?", style: TextStyle(color: kPrimaryAppColor, fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            expanded: Text("No personal data is stored. No request logs are written. Everything works in memory.\n", softWrap: true, ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


