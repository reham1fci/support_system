import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_system/ApiConnections/httpRequest.dart';
import 'package:support_system/Model/Alert.dart';
import 'package:support_system/Model/client.dart';
import 'package:support_system/Model/request.dart';
import 'package:support_system/Screens/MainScreen.dart';
import 'package:support_system/Screens/Requests.dart';
import 'package:support_system/Screens/addUser.dart';
import 'package:support_system/Screens/changePassword.dart';
import 'package:http/http.dart'  as http ;
import 'dart:async';
import 'dart:convert' show json;
import '../app_localizations.dart';
import '../my_colors.dart';
import 'package:json_annotation/json_annotation.dart';
class Login extends StatefulWidget {

  SharedPreferences sharedPrefs ;
  Login(this.sharedPrefs ,{Key key}): super(key: key);//add also

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return new LoginState();
  }
}

class LoginState extends State<Login> {
   String nameError , passError ;
   SharedPreferences sharedPrefs ;
 /* void checkLogin ()async {
    sharedPrefs = await SharedPreferences.getInstance();
      if(  sharedPrefs.containsKey("user")) {
     Client   c = Client.fromJson(json.decode( sharedPrefs.getString("user") )) ;
     if (c.firstLogin == true) {
       Navigator.pushReplacement( context,     MaterialPageRoute(builder: (context) => ChangePassword())) ;
       /*   Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePassword()));*/
     }
     else {
       Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => MainScreen())) ;

       /*  Navigator.push(
              context,
            MaterialPageRoute(builder: (context) => MainScreen()));
            //  MaterialPageRoute(builder: (context) => RegisterNewUser()));*/
     }
    }
    //sharedPrefs.commit() ;
  }*/
  SharedPreferences sh ;
  @override
  void initState() {
    // TODO: implement initState
   // checkLogin() ;
    super.initState();
     sh = widget.sharedPrefs ;

  }
   void saveUserData (Client c )async {
    sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString("user", json.encode( c.toJson()) );
    //sharedPrefs.commit() ;
   }

      void onLogin (Client  c  ) {
    setState(() {


        print(c.toString()); //
        saveUserData(c);
loading = false ;
        if (c.firstLogin == true) {
          Navigator.pushReplacement( context,     MaterialPageRoute(builder: (context) => ChangePassword())) ;
       /*   Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePassword()));*/
        }
        else {
          Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => MainScreen())) ;

        /*  Navigator.push(
              context,
            MaterialPageRoute(builder: (context) => MainScreen()));
            //  MaterialPageRoute(builder: (context) => RegisterNewUser()));*/
        }
    });
      }

  Future<void> onError(String message ) async {
     setState(() {
       loading = false ;
     });
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error Login'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  bool loginValidation (String name  , String password){
    bool validate  = true  ;
    nameError  = null  ; passError   = null;
    if(name.isEmpty) {
      nameError  = " enter name " ;
      validate = false  ;
    }
    if(password.isEmpty){
      passError  = " enter password " ;
      validate = false  ;

    }
     return validate ;

  }
  TextEditingController clientNumEd  = new TextEditingController()  ;
  TextEditingController passwordEd   = new TextEditingController()  ;
  CircleAvatar logoImage  =    CircleAvatar(child: Image.asset('images/logo.jpeg', fit: BoxFit.contain , height: 100, width: 100, ),backgroundColor: Colors.white,  minRadius: 30,
    maxRadius: 60,);
  void onLoginBtnCLick (){
    setState(() {
     bool isValidate =   loginValidation(clientNumEd.text ,passwordEd.text )  ;
      if(isValidate){
        loading = true  ;
        Api a = new Api()   ;
        a.login(name:clientNumEd.text  , password: passwordEd.text   ,  onLogin: onLogin , onError:onError ) ;
     //  login(clientNumEd.text  ,passwordEd.text )  ;
      }
    });
  }
    bool loading = false ;
  @override
  Widget build(BuildContext context) {

//print(sh.toString()) ;
if(sh.containsKey("user")) {
  Client   c = Client.fromJson(json.decode( sh.getString("user") )) ;
  print(c.toString()) ;
  if(c.firstLogin) {
  return ChangePassword() ;
}
else{ return MainScreen() ;}
}
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(AppLocalizations.of(context).translate("login")),
          backgroundColor: MyColors.blue,
    ),
        backgroundColor: MyColors.grey,
     //   resizeToAvoidBottomInset: false,
        body:
       new Container(
         height: double.infinity,
        child:new Column(
          children: <Widget>[
            new Expanded(child:
                Align(alignment: Alignment.center , child:
               SingleChildScrollView(
             //   mainAxisSize: MainAxisSize.max,  // hight vertical
              //  mainAxisAlignment: MainAxisAlignment.center, // vertical
             child: Column(
                children: <Widget>[
                  loading? new Center(
                    child: CircularProgressIndicator(),
                  ):SizedBox(),
                  new Padding(padding:new EdgeInsets.all(30.0) ,child:
                  new Center(child: Image.asset('images/logo.jpeg', fit: BoxFit.contain , ),))  ,
                  new Padding(padding:new EdgeInsets.only(bottom: 8.0 , left: 30.0  , right: 30.0 , top: 8.0) ,
                    child:  new TextField(controller:  clientNumEd,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).translate("user_name") ,
                          fillColor: Colors.white,
                          filled: false,
                           errorText: nameError,
                          prefixIcon:Image.asset('images/user_icon.png') ,
                        )
                    ),)
                  ,
                  new Padding(padding:new EdgeInsets.only(bottom: 8.0 , left: 30.0  , right: 30.0 , top: 8.0) ,
                      child:
                      new TextField(controller:  passwordEd,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).translate("password"),
                            fillColor: Colors.white,
                            filled: false,
                             errorText: passError,
                            prefixIcon:Image.asset('images/pass_icon.png') ,
                          ) ,) ),
                   new Padding (padding: EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0),child:new Container(
                     decoration:  new BoxDecoration(color:MyColors.semoni
                         , borderRadius:  const BorderRadius.all(
                           const Radius.circular(8.0),)
                     ),
                     width  :   double.infinity,
                     child  :   new FlatButton(
                       onPressed: onLoginBtnCLick ,
                       child: new Text(AppLocalizations.of(context).translate("login") , style: new TextStyle(color: Colors.white),),
                     ) ,
                   ) )
                  
                ],
              )),
            )),

          ],
        ),
    )





    ) ;
  }

}

