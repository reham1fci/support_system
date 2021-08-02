/*
 *
 *  Created by Eng. Reham Mokhtar on 05/02/20 06:07 م
 *   Copyright (c) 2020 . All rights reserved.
 *   Last modified 05/02/20 06:07 م
 *
 */
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_system/ApiConnections/httpRequest.dart';
import 'package:support_system/Model/client.dart';
import 'package:support_system/Screens/Requests.dart';
import 'package:support_system/Screens/addUser.dart';
import 'package:support_system/Screens/changePassword.dart';
import 'package:support_system/Screens/login.dart';
import '../app_localizations.dart';
import '../my_colors.dart';
import 'package:pie_chart/pie_chart.dart';

class MainScreen  extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MainState();
  }

}
class MainState  extends State <MainScreen>{
  bool appBarVisible  = true ;
  bool newUserVisible  = true ;
  String userName   = "";
  String userJob   = "";
  String userBranch   = "";
  int closed  =0  ;
  int cancel  = 0  ;
  int received  =  0  ;
  int active  = 0 ;
  Api api = new Api() ;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData() ;

  }
  Client clientLocalData ;
  SharedPreferences sharedPrefs ;
  Future <void> getUserData() async{
     sharedPrefs = await SharedPreferences.getInstance();
    clientLocalData = Client.fromJson(json.decode( sharedPrefs.getString("user") )) ;
    api.getAppStatics(clientId: clientLocalData.clientId , onResponse:(var s){
      setState(() {
        closed  = s['closed'] ;
        active  = s['active'] ;
        cancel  = s['cancel'] ;
        received  = s['recived'] ;
      });

    } ) ;
    setState(() {
      userName  = clientLocalData.lName ;
      userJob  = clientLocalData.job ;
       if(clientLocalData.clientBranchId != 0 ){
      userBranch  = clientLocalData.clientBranchName ;

       }
      if(clientLocalData.userType==2) {
       newUserVisible = false ;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new Scaffold(
        appBar: appBarVisible ? AppBar(
          title: new Text(AppLocalizations.of(context).translate("app_name")),
          backgroundColor: MyColors.blue ,) : null ,
           backgroundColor: MyColors.grey ,
      body:  new ListView(
        children: <Widget>[
         userData()  ,
          requestsChartCard() ,
          menu() ,
        ],
      ),
    ) ;
    }
    Padding userData(){
    return  new Padding(padding:  EdgeInsets.all(0.0) , child:
      new Container(
      color: MyColors.blue,
    /*  elevation: 30.0,
      //RoundedRectangleBorder, BeveledRectangleBorder, StadiumBorder
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(10.0)),
      ),*/
    padding: EdgeInsets.all(8.0),
      child:  new Column( children: <Widget>[
       new CircleAvatar(
        // backgroundImage: NetworkImage('https://via.placeholder.com/150'),
      child: ClipOval(
      child: Image.asset('images/logo.jpeg', fit: BoxFit.contain , height: 200, width: 200, )),
         backgroundColor:MyColors.grey ,  minRadius: 60, maxRadius: 60,)  ,
      new Padding(padding:  EdgeInsets.only(bottom: 8 , top: 8) ,
          child:   new Column(  children: <Widget>[
            new Text(userName, style: new TextStyle(color: Colors.white,fontSize: 20),) ,
            new Text(userJob, style: new TextStyle(color: Colors.white,fontSize: 15),) ,
            new Text(userBranch, style: new TextStyle(color: Colors.white,fontSize: 15),) ,

          ],)

      )],),
      )) ;

    }
    Padding requestsChartCard(){
      return  new Padding(padding:  EdgeInsets.all(5.0) , child:
      new Card(
          color: Theme.of(context).cardColor,
      elevation: 30.0,
      //RoundedRectangleBorder, BeveledRectangleBorder, StadiumBorder
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(10.0)),
      ),
      child:pieChart()));
    }
    PieChart pieChart()
    {
      Map<String, double> dataMap = new Map();
      dataMap.putIfAbsent(" closed ", () => closed.toDouble());
      dataMap.putIfAbsent(" received", () => received.toDouble());
      dataMap.putIfAbsent(" canceled" , () => cancel.toDouble());
      dataMap.putIfAbsent(" active", () => active.toDouble());

      List<Color> colorList = [
        Colors.orange,
        Colors.greenAccent,
        Colors.yellow,
        Colors.blue,
      ];

     return PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 16.0,
        chartRadius: MediaQuery.of(context).size.width / 2.7,
        showChartValuesInPercentage: false,
        showChartValues: true,
        showChartValuesOutside: false,
        chartValueBackgroundColor: Colors.grey[200],
        colorList: colorList,
        showLegends: true,
        legendPosition: LegendPosition.right,
        decimalPlaces: 1,
        showChartValueLabel: true,
        initialAngle: 0,
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey[900].withOpacity(0.9),
        ),
        chartType: ChartType.disc,
      ) ;
    }
     void onPressChangePass()
     {
       setState(() {
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => ChangePassword()),
         );
       });
     }
  void onPressAddUser()
  {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterNewUser()),
      );
    });
  }
  void onPressRequests()
  {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Requests()),
      );
    });
  }
  void onPressLogout()
  {
    setState(() {
    // delete user data shared
      sharedPrefs.clear() ;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login(sharedPrefs)),
      );
    });
  }
     Padding menu(){
       return  new Padding(padding:  EdgeInsets.all(5.0) , child:
       new Card(
           color: Theme.of(context).cardColor,
           elevation: 30.0,
           //RoundedRectangleBorder, BeveledRectangleBorder, StadiumBorder
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.vertical(
                 bottom: Radius.circular(10.0),
                 top: Radius.circular(10.0)),
           ),
           child: new Column( children: <Widget>[
             new Padding(padding: EdgeInsets.all(16.0) , child :
             new Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   new Center(child :  new FlatButton(onPressed: onPressRequests, child:  new Column(children: <Widget>[
                     new Image.asset('images/request.png' ,width: 40, height: 40) ,
                     new Text(AppLocalizations.of(context).translate("requests"))
                   ],))),

                   new Center(child :
                   new FlatButton(onPressed: onPressChangePass, child:  new Column(children: <Widget>[
                     new Image.asset('images/password.png' ,width: 40, height: 40 ) ,
                     new Text(AppLocalizations.of(context).translate("change_pass"))
                   ],))
                   ),
                 ]  ))
             ,
             new Padding(padding: EdgeInsets.all(16.0) , child :
             new Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   new FlatButton(onPressed: onPressLogout, child:  new Column(children: <Widget>[
                     new Image.asset('images/logout.png' ,width: 40, height: 40) ,
                     new Text(AppLocalizations.of(context).translate("logout") )
                   ],)),
                   newUserVisible ?   new FlatButton(onPressed:
               onPressAddUser,
                   child:  new Column(
                     children: <Widget>[
                 new Image.asset('images/user.png'  ,width: 40, height: 40) ,
                 new Text(AppLocalizations.of(context).translate("add_user"))

               ],)
               ): new FlatButton(onPressed: null, child: null) ,
           ]  ))
             , ],)
          ));
     }

  }

