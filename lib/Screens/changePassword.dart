/*
 * *
 *  * Created byEng. Reham Mokhtar on 03/02/20 12:18 م
 *  * Copyright (c) 2020 . All rights reserved.
 *  * Last modified 03/02/20 12:18 م
 *
 */

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_system/ApiConnections/httpRequest.dart';
import 'package:support_system/Model/client.dart';
import 'package:support_system/Screens/Requests.dart';
import 'package:support_system/Screens/login.dart';
import '../app_localizations.dart';
import '../my_colors.dart';
import 'addUser.dart';
import 'package:http/http.dart'  as http ;
import 'dart:async';
import 'dart:convert' show json;

 class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new StatePassword();
  }

 }
class StatePassword   extends State<ChangePassword>{
  TextEditingController oldPassword       = new TextEditingController()  ;
  TextEditingController newPassword       = new TextEditingController()  ;
  TextEditingController confirmPassword   = new TextEditingController()  ;
  String passErr , newPassErr , confPassErr  ;
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
    });
    //sharedPrefs.commit() ;
  }
  bool loading = false ;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("change_pass")),
        backgroundColor: MyColors.blue ,
      ) ,
      backgroundColor: MyColors.grey ,
      body:
      SingleChildScrollView( child:
      new Container(
        child: new Column(
          children: <Widget>[
               new Padding(padding:new EdgeInsets.all(30.0) ,child:
                new Center(child: Image.asset('images/logo.jpeg', fit: BoxFit.contain , ),))  ,
              createTextField(oldPassword,     "old_pass" ,        'images/pass_icon.png' , passErr) ,
              createTextField(newPassword,     "new_pass" ,        'images/pass_icon.png' , newPassErr ) ,
              createTextField(confirmPassword, "confirm_pass",        'images/pass_icon.png'  , confPassErr) ,
              createChangeBtn() ,
            loading? new Center(
              child: CircularProgressIndicator(),
            ):SizedBox(),

          ],) ,
      )
      ),

    );
  }
        /*restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      Client c = json.decode( sharedPrefs.getString("user") ) ;
      //TODO: More restoring of settings would go here...
    });
  }*/

  Future changePass(String oldPass , String newPass)async{
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
     print (sharedPrefs.getString("user")) ;
    setState(() {
      loading= true ;
      Client clientLocalData = Client.fromJson(json.decode( sharedPrefs.getString("user") )) ;
    String url  = Api.baseUrl+"Client/clintchangepass";
     print(url) ;
  Client client = new Client.changePass(clientLocalData.clientsUID, oldPass) ;
    http.post(url , body  :  client.changePassMap(newPass)  ,).then((http.Response response) {
      print(response.statusCode) ;
      print(response.body)  ;

      setState(() {
        if(response.statusCode == 200) {
          var jsonObj = json.decode(response.body);
          var  resultObj  = jsonObj  ['result']  ;

          String  msg  = resultObj['message']  ;
          print(msg)  ;
          if(msg  == "success") {
            loading = false ;
           doneAlert() ;
          }
          else {
            loading = false ;

            showAlert("incorrect old pass ") ;
            print ("incorrect login " ) ;
            // toast login in correct
          }
        }
        else {
          showAlert("connection error") ;
          print ("connection error ") ;
          //return null ;
        }
     });
    }
    );
    });
  }
  Future<void> showAlert(String message ) async {
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
  Future<void> doneAlert( ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('thanks'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("password changed Successuffly"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
              onPressed: () {
                sharedPrefs.clear() ;
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login(sharedPrefs)));              },
            ),
          ],
        );
      },
    );
  }
  bool changePassValidation (String pass  , String newPass , String conPass){
    bool validate  = true  ;
    passErr  = null  ; newPassErr   = null; confPassErr = null  ; 
    if(pass.isEmpty) {
      passErr  = " enter password " ;
      validate = false  ;
    }
    if(newPass.isEmpty){
      newPassErr  = " enter  new password " ;
      validate = false  ;

    }if(conPass.isEmpty){
      confPassErr  = " enter  confirm password " ;
      validate = false  ;

    }
     else  if(newPass != conPass){
      confPassErr  = " confirm password not match with password  " ;
      validate = false  ;

    }
    return validate ;

  }
  void onChangePassBtnCLick (){
    setState(() {
    bool isValidate    = changePassValidation(oldPassword.text, newPassword.text, confirmPassword.text) ;
     if (isValidate){
       changePass(oldPassword.text, newPassword.text) ;
     }
    });
  }

  Padding createChangeBtn (){
   return  new Padding(padding: EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0),child:new Container(
      decoration:  new BoxDecoration(color:MyColors.semoni
          , borderRadius:  const BorderRadius.all(
            const Radius.circular(8.0),)
      ),
      width  :   double.infinity,
      child  :   new FlatButton(
        onPressed: onChangePassBtnCLick ,
        child: new Text(AppLocalizations.of(context).translate("change_pass") , style: new TextStyle(color: Colors.white),),
      ) ,
    ) );
  }
  Padding createTextField (TextEditingController controller , String hint  , String iconName , String errorMsg ){
    return new Padding(padding:new EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0) ,child:
    new TextField(
          controller:  controller,
          decoration: InputDecoration(
          hintText: AppLocalizations.of(context).translate(hint) ,
          fillColor: Colors.white,
          filled: false,errorText:  errorMsg,
          prefixIcon:Image.asset(iconName) ,
        )
    )
    );
  }
}
