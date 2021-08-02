
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:support_system/Model/client.dart';
import 'package:support_system/Screens/MainScreen.dart';
import 'package:support_system/Screens/WebView.dart';
import 'package:support_system/Screens/addUser.dart';
import 'package:support_system/Screens/changePassword.dart';
import 'package:support_system/Screens/login.dart';
import 'package:support_system/my_colors.dart';
import '../app_localizations.dart';
import 'Requests.dart';
import 'addRequest.dart';
class Splash extends StatefulWidget {
  @override
  _MySplashState createState() => new _MySplashState();
}

class _MySplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin() ;
  }
   SharedPreferences sharedPrefs ;
   void checkLogin ()async {
     SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
     setState(() {
      this .sharedPrefs = sharedPrefs ;
      print("shared0") ;
    });
     //sharedPrefs.commit() ;
   }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        backgroundColor: MyColors.grey,
        seconds: 8,
        navigateAfterSeconds: Login(sharedPrefs),
        title: new Text( AppLocalizations.of(context).translate("app_name"),
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0 ,
               color: MyColors.blue
          ),),
      //  image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
         image: Image.asset('images/logo.jpeg' ),
        photoSize: 150.0,
        styleTextUnderTheLoader: new TextStyle(),
       // onClick: ()=>print("Flu tter Egypt"),
        loaderColor: MyColors.semoni
    );
  }
}

