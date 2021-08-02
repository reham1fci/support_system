import 'dart:io';

import 'package:flutter/material.dart';
import 'package:support_system/ApiConnections/httpRequest.dart';
import 'package:support_system/Screens/splash.dart';
import 'package:support_system/app_localizations.dart';
import 'package:support_system/my_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
bool isLoading=true;
final _key = UniqueKey();
class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  bool _isLoadingPage = false ;
  bool appStatus  =false ;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    getAppStatues();
  }

  @override
  Widget build(BuildContext context) {
    return
    appStatus?Splash():
     Scaffold(
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl:'http://aljazeerasoft.com/' ,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center( child: CircularProgressIndicator(),)
              : Stack(),
        ],
      ),
    );

   /* _isLoadingPage?
    WebView(
      initialUrl: 'http://aljazeerasoft.com/',
      gestureNavigationEnabled: true,
      javascriptMode: JavascriptMode.unrestricted,
onPageFinished:(url) {
        setState(() {
          _isLoadingPage  = true  ;

        });
} ,

    ):
        new Container(
          color:  MyColors.grey,
          width: double.infinity,
          height: double.infinity,
          child:
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [

          Image.asset('images/logo.jpeg' ),
          //Login(sharedPrefs),
          new Text( AppLocalizations.of(context).translate("app_name"),
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0 ,
                color: MyColors.blue
            ),),
            CircularProgressIndicator(),
        ],),)
    ;*/
  }
  void getAppStatues (){
    Api api  = new Api()  ;
    api .getAppStatues(onResponse: (String msg){
      if(msg=="on"){
        setState(() {
          appStatus = true  ;

        });
      }
      else{
        setState(() {
          appStatus = true ;

        });
      }
    }) ;
  }
}