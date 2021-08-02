import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:support_system/Model/client.dart';
import 'package:support_system/Screens/MainScreen.dart';
import 'package:support_system/Screens/addUser.dart';
import 'package:support_system/Screens/changePassword.dart';
import 'package:support_system/Screens/login.dart';
import 'package:support_system/my_colors.dart';
import '../app_localizations.dart';
import 'Requests.dart';
import 'addRequest.dart';
class TestScreen extends StatefulWidget {
  @override
  _testState createState() => new _testState();
}

class _testState extends State<TestScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("login")),
    backgroundColor: MyColors.blue,
    ),
    backgroundColor: MyColors.grey,
    body: new Container(child: new Column(
      children: [
    new Center(child: Image.asset('images/logo.jpeg', fit: BoxFit.contain , ),)  ,
    new Center(child: Text( AppLocalizations.of(context).translate("app_name"),) ) ,
        new Center(
          child: CircularProgressIndicator(),
        )

    ],),),
    );
    //   resizeToAvoidBottomInset: false,
  }


}