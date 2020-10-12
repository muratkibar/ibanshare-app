import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:hive/hive.dart';
import 'package:ibanshareapp/iban_no_request.dart';
import 'faq_page.dart';
import 'iban_model.dart';
import 'package:share/share.dart';
import 'constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'main.dart';

class IbansScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IbansScreenState();
}

enum IbanFilter { ALL, BOOKMARKS, OTHERS }

class _IbansScreenState extends State<IbansScreen> {
  Box<IbanModel> ibanBox;

  final TextEditingController ibanNoController = TextEditingController();
  final TextEditingController ibanIsimController = TextEditingController();
  final TextEditingController ibanNoUpdateController = TextEditingController();
  final TextEditingController ibanIsimUpdateController =
      TextEditingController();

  IbanFilter filter = IbanFilter.ALL;

  @override
  void initState() {
    super.initState();
    ibanBox = Hive.box<IbanModel>(ibanBoxName);
  }

  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyText2;
    final List<Widget> aboutBoxChildren = <Widget>[
      SizedBox(height: 24),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: textStyle,
                text: 'IBANshare is an application for everyone who'
                    ' ensures that IBAN (bank identification) numbers'
                    ' in multiple banks or financial institutions are'
                    ' stored securely in the phone and shared when needed.'),
            TextSpan(
                style: textStyle.copyWith(color: Theme.of(context).accentColor),
                text: ' http://ibanshare.com'),
          ],
        ),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kPrimaryAppColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.info,
            color: kPrimaryIconColor,
            size: 32.0,
          ),
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationIcon: Image.asset(
                'images/ibanshare_icon.png',
                width: 64.0,
                height: 64.0,
              ),
              applicationName: 'IBANshare',
              applicationVersion: 'June 2020',
              applicationLegalese: '© 2020 IBANshare.com',
              children: aboutBoxChildren,
            );
          },
        ),
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: kPrimaryAppColor,
        title: kPrimaryAppName,
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.filter_list,
                  color: kPrimaryIconColor,
                  size: 32.0,
                ),
                onSelected: (value) {
                  if (value.compareTo("All IBANs") == 0) {
                    setState(() {
                      filter = IbanFilter.ALL;
                    });
                  } else if (value.compareTo("Bookmarks") == 0) {
                    setState(() {
                      filter = IbanFilter.BOOKMARKS;
                    });
                  } else {
                    setState(() {
                      filter = IbanFilter.OTHERS;
                    });
                  }
                },
                itemBuilder: (BuildContext context) {
                  return ["All IBANs", "Bookmarks", "Other IBANs"]
                      .map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.chevron_right,
                              size: 24.0, color: kPrimaryIconColor),
                          SizedBox(width: 16.0),
                          Text(option),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FaqPage();
                  }));
                },
                child: Icon(
                  Icons.help,
                  size: 32.0,
                  color: kPrimaryIconColor,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.only(left: 4.0, right: 4.0),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ValueListenableBuilder(
                    valueListenable: ibanBox.listenable(),
                    builder: (context, Box<IbanModel> ibans, _) {
                      List<int> keys = ibans.keys.cast<int>().toList();
                      if (filter == IbanFilter.ALL) {
                        keys = ibans.keys.cast<int>().toList();
                      } else if (filter == IbanFilter.BOOKMARKS) {
                        keys = ibans.keys
                            .cast<int>()
                            .where((key) => ibans.get(key).isIbanBenim)
                            .toList();
                      } else {
                        keys = ibans.keys
                            .cast<int>()
                            .where((key) => !ibans.get(key).isIbanBenim)
                            .toList();
                      }
                      return Container(
                        height: 1000.0,
                        color: kPrimaryBackgroundColor,
                        child: ListView.separated(
                          reverse: false,
                          itemCount: keys.length,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            final int key = keys[index];
                            final IbanModel iban = ibans.get(key);
                            return ListTile(
                              onLongPress: () {
                                Clipboard.setData(
                                        new ClipboardData(text: iban.ibanNo))
                                    .then((_) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          "IBAN number copied to clipboard!"), duration: Duration(seconds: 2),));
                                });
                              },
                              isThreeLine: true,
                              leading: Container(
                                child: GestureDetector(
                                  onTap: () {
                                    IbanModel addIban = IbanModel(
                                      ibanNo: iban.ibanNo,
                                      ibanIsim: iban.ibanIsim,
                                      isIbanBenim:
                                          iban.isIbanBenim ? false : true,
                                    );
                                    ibanBox.put(key, addIban);

                                    iban.isIbanBenim
                                        ? _scaffoldKey.currentState
                                            .showSnackBar(
                                            showErrorMessage(
                                                'Bookmark cancelled!', 2),
                                          )
                                        : _scaffoldKey.currentState
                                            .showSnackBar(
                                            showErrorMessage('Bookmarked!', 2),
                                          );
                                  },
                                  child: Icon(
                                    iban.isIbanBenim
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: iban.isIbanBenim
                                        ? kPrimaryAppColor
                                        : kPrimaryIconColor,
                                    size: 36.0,
                                  ),
                                ),
                              ),
                              title: Container(
                                child: Text(
                                  iban.ibanNo,
                                  style: kIbanFieldTextStyle,
                                ),
                              ),
                              subtitle: Container(
                                child: Text(iban.ibanIsim,
                                    style: kNameFieldTextStyle),
                              ),
                              trailing: SafeArea(
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Container(
                                    width: 128.0,
                                    //height: 128.0,
                                    child: Wrap(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Tooltip(
                                              message:
                                                  "Share IBAN number with your friends.",
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.share,
                                                  size: 48.0,
                                                  color: kPrimaryIconColor,
                                                ),
                                                onPressed: () {
                                                  final RenderBox box = context
                                                      .findRenderObject();
                                                  Share.share(iban.ibanNo,
                                                      subject:
                                                          'Hi, here is the IBAN information!',
                                                      sharePositionOrigin:
                                                          box.localToGlobal(
                                                                  Offset.zero) &
                                                              box.size);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Tooltip(
                                              message:
                                                  "Delete IBAN permanently.\nRemember!\nThis action cannot be undone.",
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  size: 48.0,
                                                  color: kPrimaryIconColor,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    child: Dialog(
                                                      elevation: 2,
                                                      shape:
                                                          new RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            16.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Wrap(
                                                              //mainAxisAlignment: MainAxisAlignment.center,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 44.0,
                                                                    color:
                                                                        kPrimaryIconColor),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 16.0),
                                                            Text(
                                                              'IBAN will be deleted permanently.',
                                                              style:
                                                                  kDialogFieldTextStyle,
                                                            ),
                                                            SizedBox(
                                                              height: 8.0,
                                                            ),
                                                            FlatButton(
                                                              onPressed: () {
                                                                ibanBox
                                                                    .deleteAt(
                                                                        index);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              color:
                                                                  kPrimaryAppColor,
                                                              child: Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                    color:
                                                                        kPrimaryTextWhite),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Tooltip(
                                              message:
                                                  "You may update IBAN.\nJust enter an updated information and hit 'Update'.",
                                              child: IconButton(
                                                  icon: Icon(
                                                    Icons.edit,
                                                    size: 48.0,
                                                    color: kPrimaryIconColor,
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      child: Dialog(
                                                        elevation: 2,
                                                        shape:
                                                            new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  4.0),
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              TextField(
                                                                style:
                                                                    kDialogFieldTextStyle,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      iban.ibanNo,
                                                                ),
                                                                controller:
                                                                    ibanNoUpdateController,
                                                                maxLength: 26,
                                                              ),
                                                              TextField(
                                                                style:
                                                                    kDialogFieldTextStyle,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      iban.ibanIsim,
                                                                ),
                                                                controller:
                                                                    ibanIsimUpdateController,
                                                                maxLength: 25,
                                                              ),
                                                              FlatButton(
                                                                onPressed: () {
                                                                  //TodoModel getKey = ibanBox.getAt(index);

                                                                  String
                                                                      ibanNo =
                                                                      ibanNoUpdateController
                                                                          .text;

                                                                  String
                                                                      ibanIsim =
                                                                      ibanIsimUpdateController
                                                                          .text;

                                                                  if (ibanNo
                                                                          .isEmpty &&
                                                                      ibanIsim
                                                                          .isEmpty) {
                                                                    _scaffoldKey
                                                                        .currentState
                                                                        .showSnackBar(
                                                                      showErrorMessage(
                                                                          'Please update any field!',
                                                                          2),
                                                                    );
                                                                  } else {
                                                                    if (ibanNo
                                                                        .isEmpty) {
                                                                      ibanNoUpdateController
                                                                              .text =
                                                                          iban.ibanNo;
                                                                      ibanNo =
                                                                          ibanNoUpdateController
                                                                              .text;
                                                                    } else if (ibanIsim
                                                                        .isEmpty) {
                                                                      ibanIsimUpdateController
                                                                              .text =
                                                                          iban.ibanIsim;
                                                                      ibanIsim =
                                                                          ibanIsimUpdateController
                                                                              .text;
                                                                    }

                                                                    IbanModel ibanUpdate = IbanModel(
                                                                        ibanNo:
                                                                            ibanNo,
                                                                        ibanIsim:
                                                                            ibanIsim,
                                                                        isIbanBenim: iban.isIbanBenim
                                                                            ? true
                                                                            : false);
                                                                    ibanBox.put(
                                                                        key,
                                                                        ibanUpdate);
                                                                  }

                                                                  ibanNoUpdateController
                                                                      .clear();
                                                                  ibanIsimUpdateController
                                                                      .clear();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                color:
                                                                    kPrimaryAppColor,
                                                                child: Text(
                                                                  'Update',
                                                                  style: TextStyle(
                                                                      color:
                                                                          kPrimaryTextWhite),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Tooltip(
                                              message:
                                                  "You may verify IBAN number and if exists you get IBAN's details.\nRemember!\nIBAN number must be started with country code.\nOtherwise, IBAN will not be verified.",
                                              child: IconButton(
                                                  icon: Icon(
                                                    Icons.verified_user,
                                                    size: 48.0,
                                                    color: kPrimaryIconColor,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return IbanResultPage(
                                                          ibanNo: iban.ibanNo);
                                                    }));
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, index) => Divider(),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            child: Dialog(
              elevation: 2,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(4.0),
              ),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      style: kDialogFieldTextStyle,
                      decoration: InputDecoration(
                        hintText: "Please enter an IBAN...",
                      ),
                      controller: ibanNoController,
                      maxLength: 26,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      style: kDialogFieldTextStyle,
                      decoration: InputDecoration(
                        hintText: "Please enter a description...",
                      ),
                      controller: ibanIsimController,
                      maxLength: 25,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    FlatButton(
                      onPressed: () {
                        final String ibanNo = ibanNoController.text;
                        final String ibanIsim = ibanIsimController.text;

                        if (ibanNo.isNotEmpty && ibanIsim.isNotEmpty) {
                          IbanModel iban = IbanModel(
                              ibanNo: ibanNo,
                              ibanIsim: ibanIsim,
                              isIbanBenim: false);
                          ibanBox.add(iban);
                        } else {
                          _scaffoldKey.currentState.showSnackBar(
                            showErrorMessage('Please fill both fields!', 2),
                          );
                        }
                        ibanNoController.clear();
                        ibanIsimController.clear();
                        Navigator.pop(context);
                      },
                      color: kPrimaryAppColor,
                      child: Text(
                        'Add New',
                        style: TextStyle(color: kPrimaryTextWhite),
                      ),
                    ),
                    Text("(Please do not forget to begin with a country code while adding IBAN number.)", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12.0, fontFamily: 'AvertaRegular'),),
                  ],
                ),
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
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
    );
  }
}
