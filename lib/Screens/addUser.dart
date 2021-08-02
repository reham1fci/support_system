import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_system/ApiConnections/httpRequest.dart';
import 'package:support_system/Model/Branch.dart';
import 'package:support_system/Model/client.dart';
import 'package:support_system/Screens/Requests.dart';
import 'package:support_system/Screens/login.dart';
import '../app_localizations.dart';
import '../my_colors.dart';
 class RegisterNewUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  new RegistrationState();
  }


 }
class RegistrationState extends State<RegisterNewUser>{
  TextEditingController enName = new TextEditingController()  ;
  TextEditingController arName   = new TextEditingController()  ;
  TextEditingController job   = new TextEditingController()  ;
  TextEditingController userName   = new TextEditingController()  ;
  TextEditingController email   = new TextEditingController()  ;
  TextEditingController phone   = new TextEditingController()  ;
  TextEditingController password   = new TextEditingController()  ;
   String  enNameError , arNameError , jobError  , userNameError  ,
       emailError  , phoneError , passwordError = null  ;

  List <Branch> branchesList = new  List() ;
  List <String> branchNameList = new  List() ;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // setData() ;
    selectBranch = "فرع الموظف" ;
     getBranches() ;
  }
  Client clientLocalData ;
   Future <void> getBranches() async{
     Api api  = new Api()  ;
     SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      clientLocalData = Client.fromJson(json.decode( sharedPrefs.getString("user") )) ;
     api. getClientBranches(clientLocalData.clientId.toString() , onGetBranches ) ;
   }

     void onGetBranches (var branchList ){
        setState(() {
          for(int i  =  0 ; i <branchList.length ; i++){
            Branch    branch =      Branch.fromJson(branchList[i])  ;
            branchesList.add( branch) ;
            branchNameList.add(branch.branchName) ;

          }

        });

     }
 bool errorMsgVisible  =  false  ;
 String errorMsg  =  ""  ;
  @override
  Widget build(BuildContext context) {
 //   selectBranch   =  AppLocalizations.of(context).translate("branch") ;
    // TODO: implement build
    return    new Scaffold(
        appBar: new AppBar(
          title: new Text(AppLocalizations.of(context).translate("add_user")),
          backgroundColor: MyColors.blue ,
        ) ,
      backgroundColor: MyColors.grey ,
      body:
    SingleChildScrollView( child:
      new Container(

        child: new Column(

          mainAxisSize: MainAxisSize.max,  // hight vertical
          // vertical
          children: <Widget>[
          createTextField(enName  , "english_name"  ,  'images/english_icon.png' , enNameError , TextInputType.text  , false) ,
          createTextField(arName  , "arabic_name"   ,  'images/arabic_icon.png' , arNameError , TextInputType.text  , false) ,
          createTextField(job     , "job_description", 'images/job_icon.png' , jobError , TextInputType.text  , false) ,
          createTextField(userName, "user_name"     ,  'images/user_icon.png' , userNameError , null , false) ,
          createTextField(email   , "email",           'images/email_icon.png'  , emailError ,TextInputType.emailAddress , false) ,
          createTextField(phone   , "phone",           'images/phone_icon.png'  , phoneError , TextInputType.phone , false) ,
          createTextField(password, "password",        'images/pass_icon.png'  , passwordError , TextInputType.visiblePassword ,true) ,
            createDropDownList(),
        new Padding(padding:new EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0) ,child:
             new Align(alignment: Alignment.topLeft,child:new Text(errorMsg ,style:  new TextStyle(color: Colors.red , fontSize: 12),) ,)  ),
            createRegisterBtn() ,
        ],) ,
      )
      ),

    );
  }
  void onRegisterBtnCLick (){
    setState(() {
      enNameError= null ;
      arNameError= null ;
      jobError= null ;
      userNameError= null ;
      emailError= null ;
      phoneError= null ;
      passwordError = null  ;
       errorMsg  = "" ;
       if(validate()) {
         Api api  = new Api()  ;
         api.addNewUser(password: password.text , job: job.text  ,clientId: clientLocalData.clientId  , clientBranch:   selectBranchId, branchId: clientLocalData.ourBranchId  ,email: email.text ,
             phone:  phone.text , userAName: arName.text , userEName:enName.text  ,userName: userName.text   , onAddUserResponse: (String response ){
           if(response == "success") {
             print("insertDone") ;
              onRequestAddedWindow(AppLocalizations.of(context).translate("user_done_added")) ;
           }
            else{
             onRequestAddedWindow(AppLocalizations.of(context).translate("error")) ;
           }
             }  ) ;

       }
        else {
          print("error") ;
       }
    });
  }
  Future<void> onRequestAddedWindow(String message ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
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
                if(message == AppLocalizations.of(context).translate("user_done_added")) {
                  Navigator.of(context).pop();

                }
              },
            ),
          ],
        );
      },
    );
  }

String selectBranch   ;
  int selectBranchId  =  0  ;
  void onSelectBranch(String branch){
    setState(() {
       selectBranch = branch ;
       int index =   branchNameList.indexOf(branch)  ;
         selectBranchId   = branchesList [index] .branchID  ;
        print(selectBranch) ;
    });
   }
  Padding createDropDownList(){
  // selectBranch =  "test2" ;
   return
   new Padding(padding:new EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0) ,child:
   new DropdownButton<String>(

     isExpanded: true,
      items: branchNameList.map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),

    onChanged: onSelectBranch,
     hint:  Row(
       children: <Widget>[
         Padding(
           padding: EdgeInsets.symmetric(horizontal: 12.0),
           child: Icon(Icons.ac_unit, color: MyColors.semoni,),
         ),
        new Text(
              selectBranch)       ],
     ),
     iconEnabledColor: MyColors.semoni,
    )) ;
  }
  Padding createRegisterBtn (){
    return  new Padding(padding: EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0),child:
    new Align(alignment: Alignment.bottomCenter,child:
    new Container(
      decoration:  new BoxDecoration(color:MyColors.semoni
          , borderRadius:  const BorderRadius.all(
            const Radius.circular(8.0),)
      ),
      width  :   double.infinity,
      child  :   new FlatButton(
        onPressed: onRegisterBtnCLick ,
        child: new Text(AppLocalizations.of(context).translate("add_user") , style: new TextStyle(color: Colors.white),),
      ) ,
    ) ));
  }
  Padding createTextField (TextEditingController controller , String hint  , String iconName  , String error_message , TextInputType inputType , bool visible){
    return new Padding(padding:new EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0) ,child:
    new TextField(controller:  controller,
         keyboardType:  inputType ,
        obscureText: visible,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).translate(hint) ,
          fillColor: Colors.white,
          filled: false ,
          errorText:error_message,
          prefixIcon:Image.asset(iconName) ,
        )


    )
    ) ;

  }
   bool validate  (){
    bool validate  = true  ;
    if(enName.text.isEmpty) {
      enNameError = AppLocalizations.of(context).translate("enter")+ " " +AppLocalizations.of(context).translate("english_name") ;
      validate = false ;
    }
    if(arName.text.isEmpty){
      arNameError  = AppLocalizations.of(context).translate("enter")+ " " + AppLocalizations.of(context).translate("arabic_name") ;
      validate = false ;
    }
      if(job.text.isEmpty)
      { jobError  =  AppLocalizations.of(context).translate("enter")+ " " +AppLocalizations.of(context).translate("job_description") ;
      validate = false ;
      }
      if(userName.text.isEmpty||!validateUserName(userName.text))
        {
          userNameError  = AppLocalizations.of(context).translate("enter")+ " " + AppLocalizations.of(context).translate("user_name") ;
          validate = false ;
        }
      if(email.text.isEmpty){
        emailError  = AppLocalizations.of(context).translate("enter")+ " " + AppLocalizations.of(context).translate("email") ;
        validate = false ;
      }
      if(phone.text.isEmpty) {
        phoneError  = AppLocalizations.of(context).translate("enter")+ " " + AppLocalizations.of(context).translate("phone") ;
        validate = false ;}
      if(password.text.isEmpty)
      {passwordError  =AppLocalizations.of(context).translate("enter")+ " " +  AppLocalizations.of(context).translate("password") ;
      validate = false ;
      }
 if(selectBranchId == 0 ) {
        errorMsgVisible  = true;
        errorMsg  = " " + AppLocalizations.of(context).translate("enter")+ " " +selectBranch ;
        validate = false ; }
      return validate  ;
    }

  bool validateUserName(String  value ) {
    RegExp pattern = new RegExp(r'^[a-zA-Z0-9]+$');
     if(pattern.hasMatch(value)) {
       return true  ;
     }
      else{
        return false  ;
     }
     }
  }
