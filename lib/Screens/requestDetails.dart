import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_system/ApiConnections/httpRequest.dart';
import 'package:support_system/Model/Images.dart';
import 'package:support_system/Model/client.dart';
import 'package:support_system/Model/request.dart';
import 'package:support_system/Screens/ImageView.dart';
import 'package:support_system/Screens/RatingDialog.dart';
import '../app_localizations.dart';
import '../my_colors.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'CancelComplete.dart';
class RequestDetails extends StatefulWidget {
  Request request   ;

  RequestDetails(this.request ,{Key key}): super(key: key);//add also

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  new RequestDetailsState();
  }
}
  class RequestDetailsState extends  State<RequestDetails>{
    Api api;
    SharedPreferences  sharedPrefs ;
    Client client  ;
    String supportName =""  ;  String supportPhone  =  ""  ;
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
     request  = widget.request ;
     api  = new Api()  ;
api.getImages(reqID: request.reqNum ,onResponse: (images){
  setState(() {
    imagesList  = images  ;
  });

}) ;

  }
    Future <void> getUserData() async{
      sharedPrefs = await SharedPreferences.getInstance();
      client = Client.fromJson(json.decode( sharedPrefs.getString("user") )) ;
      setState(() {
        supportName  = client.responseEmpNm ;
        supportPhone  = client.responseEmpPhone ;
      });

    }
  Request request  =  new Request();

  bool rateBtnVisibilty =true ;
   @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new Scaffold(
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("request_details")),
        backgroundColor: MyColors.blue ,
      ) ,
      backgroundColor: MyColors.grey ,
      body:
     // SingleChildScrollView( child:
      new Container(
         padding: EdgeInsets.all(16.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[


            // request number
            new Text(AppLocalizations.of(context).translate("request_number")  , style: new TextStyle(color:  Colors.black)) ,
            new Text(request.reqNum.toString(), style: new TextStyle(color: MyColors.greyDark),) ,
            Divider(
                color: Colors.black
            ),
            // Statues
            new Text(AppLocalizations.of(context).translate("request_statues") , style: new TextStyle(color: Colors.black)) ,
            new Text(request.statues, style: new TextStyle(color: MyColors.greyDark),) ,
            Divider(
                color: Colors.black
            ),
            new Text(AppLocalizations.of(context).translate("request_date") , style: new TextStyle(color: Colors.black)) ,
            new Text(request.date + " - " +request.time, style: new TextStyle(color: MyColors.greyDark),) ,
            Divider(
                color: Colors.black
            ),
            new Text(AppLocalizations.of(context).translate("req_description") , style: new TextStyle(color:  Colors.black)) ,
            new Text(request.reqDisc, style: new TextStyle(color: MyColors.greyDark),) ,
            Divider(
                color: Colors.black
            ),
            new Text(AppLocalizations.of(context).translate("request_system") , style: new TextStyle(color:  Colors.black)) ,
            new Text(request.systemName, style: new TextStyle(color: MyColors.greyDark),) ,
            Divider(
                color: Colors.black
            ),
            new Text(AppLocalizations.of(context).translate("request_type") , style: new TextStyle(color:  Colors.black)) ,
            new Text(request.requestTypeName, style: new TextStyle(color: MyColors.greyDark),) ,
            Divider(
                color: Colors.black
            ),
            new Text(AppLocalizations.of(context).translate("eng_name") , style: new TextStyle(color:  Colors.black)) ,
            new Text(supportName, style: new TextStyle(color: MyColors.greyDark),) ,
            Divider(
                color: Colors.black
            ),
            new Text(AppLocalizations.of(context).translate("eng_phone") , style: new TextStyle(color:  Colors.black)) ,
            new Text(supportPhone, style: new TextStyle(color: MyColors.greyDark),) ,
            Divider(
                color: Colors.black
            ),
            new Text(AppLocalizations.of(context).translate("reply") , style: new TextStyle(color:  Colors.black)) ,
            new Text("", style: new TextStyle(color: MyColors.greyDark),) ,
            Divider(
                color: Colors.black
            ),
            new Text(AppLocalizations.of(context).translate("images_attachment") , style: new TextStyle(color:  Colors.black)) ,
            //  reqNumStates() ,
           //  reqDateTime  () ,
           //  requestDisc  () ,
           //  displayService  () ,
           //  displaySystem  () ,
          //   displayEng  () ,
            // new Padding(padding: EdgeInsets.only(bottom: 20.0) ,
             //    child : replay  ()) ,

            imageListView() ,
          // request.isRated ? SizedBox():addRateBtn() ,
             request.statuesID  == cancel ?cancelRequest():SizedBox(),
             request.statuesID  == complete ?closeRequest():SizedBox(),
          ],) ,
   //   )
      ),

    );
  }
   void onAddRateClick() {
     setState(() {
       showDialog(
           context: context,
           builder: (_) {
             return RatingDialog(request.reqNum);
           });     });
   }
    int cancel = 1;
    int complete = 3;


   Padding addRateBtn() {
     return new Padding(
         padding:
         EdgeInsets.only(bottom: 8.0, left: 40.0, right: 40.0, top: 8.0),
         child: Align(
             alignment: Alignment.bottomCenter,
             child: new Container(
               decoration: new BoxDecoration(
                   color: MyColors.semoni,
                   borderRadius: const BorderRadius.all(
                     const Radius.circular(8.0),
                   )),
               width: double.infinity,
               child: new FlatButton(
                 onPressed: onAddRateClick,
                 child: new Text(
                   AppLocalizations.of(context).translate("add_rate_Btn") ,
                   style: new TextStyle(color: Colors.white),
                 ),
               ),
             ))
     )
     ;
   }
   void cancelRequestClick (){
     setState(() {
       api.cancelReq(reqID: request.reqNum ,onResponse: (msg){
  // dialog done Cancel
      if(msg == "success") {
    showAlert(msg) ;
  }
} );
     });
   }
    Future<void> showAlert(String message ) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
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
                    Navigator.of(context).pop("done");
                },
              ),
            ],
          );
        },
      );
    }
   Padding  cancelRequest() {
     return new Padding(
         padding:
         EdgeInsets.only(bottom: 8.0, left: 40.0, right: 40.0, top: 8.0),
         child: Align(
             alignment: Alignment.bottomCenter,
             child: new Container(
               decoration: new BoxDecoration(
                   color: MyColors.semoni,
                   borderRadius: const BorderRadius.all(
                     const Radius.circular(8.0),
                   )),
               width: double.infinity,
               child: new FlatButton(
                 onPressed: cancelRequestClick,
                 child: new Text(
                   AppLocalizations.of(context).translate("cancel_request") ,
                   style: new TextStyle(color: Colors.white),
                 ),
               ),
             ))
     )
     ;
   }
   void cancelClose(){
     setState(() {
       showDialog(
           context: context,
           builder: (_) {
             return CancelComplete(request.reqNum);
           });
     });
   }

   Widget closeRequest () {
     return
      // new Padding(padding: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0, top: 8.0),
         //child:
     new Container(
         width: double.infinity,
         child:new Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,

           children: <Widget>[
         Align(
             alignment: Alignment.bottomLeft,
             child: new Container(
               decoration: new BoxDecoration(
                   color: MyColors.semoni,
                   borderRadius: const BorderRadius.all(
                     const Radius.circular(8.0),
                   )),
             //  width: double.infinity,
               child: new FlatButton(
                 onPressed: cancelClose,
                 child: new Text(
                   AppLocalizations.of(context).translate("cancel_close") ,
                   style: new TextStyle(color: Colors.white),
                 ),
               ),
             )) ,
           Align(
               alignment: Alignment.bottomRight,
               child: new Container(
                 decoration: new BoxDecoration(
                     color: MyColors.semoni,
                     borderRadius: const BorderRadius.all(
                       const Radius.circular(8.0),
                     )),
               //  width: double.infinity,
                 child: new FlatButton(
                   onPressed: onAddRateClick,
                   child: new Text(
                     AppLocalizations.of(context).translate("confirm_close") ,
                     style: new TextStyle(color: Colors.white),
                   ),
                 ),
               ))
     ],)
   //  ))
     ) ;

   }
   Widget reqNumStates (){
     return  new Row(
   mainAxisAlignment: MainAxisAlignment.spaceBetween,

  children: <Widget>[
     new Align(child: new Text(request.statues) ,alignment: Alignment.centerLeft,),
     new Align(child: new Text("#"+request.reqNum.toString()) ,alignment: Alignment.centerRight,),
   ],mainAxisSize: MainAxisSize.max,) ;
  }

   Padding reqDateTime  (){
     return  Padding(
       padding:  EdgeInsets.all(8.0),
       child:
        new Row(
       //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: <Widget>[
         new  RichText(
           softWrap: true,
           // textAlign: TextAlign.justify,
           text:
           TextSpan(
             children: [WidgetSpan(
               child: Icon(Icons.date_range, size: 14),
             ),
               TextSpan(
                 text: request.date,
                 style: TextStyle(color: Colors.grey),
               ),
             ],
           ),
         ) ,
         new Padding(padding: EdgeInsets.only(left: 10.0 , right: 10.0)  ,  child  :new RichText(
           softWrap: true,
           // textAlign: TextAlign.justify,
           text: TextSpan(
             children: [
               /*  WidgetSpan(
                        child: Icon(Icons.access_time, size: 14),
                      ),*/
               TextSpan(
                 text: request.time,
                 style: TextStyle(color: Colors.grey),
               ) ,
             ],
           ),
         )) ,
       ],
     ) );
   }
  Padding requestDisc  () {
   return  Padding(
   padding:  EdgeInsets.all(8.0),
   child:
    new Row(children: <Widget>[
       new Text(AppLocalizations.of(context).translate("req_description") , style: new TextStyle(color: MyColors.semoni ),) ,
       new Text(request.reqDisc , maxLines: 4,) ,
    ],) );

    }
   Padding displaySystem  ()
  {
    return  Padding(
        padding:  EdgeInsets.all(8.0),
    child:
      new Row(children: <Widget>[
        new Text(AppLocalizations.of(context).translate("system") , style: new TextStyle(color: MyColors.semoni ),) ,
        new Text(request.systemName , ) ,
      ],));

  }
   Padding displayService  ()
  {
   return Padding(
        padding:  EdgeInsets.all(8.0),
    child:
      new Row(children: <Widget>[
        new Text(AppLocalizations.of(context).translate("service")   , style: new TextStyle(color: MyColors.semoni ),) ,
        new Text(request.requestTypeName , ) ,
      ],) );

  }
   Padding displayEng  ()
  {
    return Padding(
        padding:  EdgeInsets.all(8.0),
    child:
      new Row(children: <Widget>[
        new Text(AppLocalizations.of(context).translate("engineer")     , style: new TextStyle(color: MyColors.semoni ),) ,
        new Text(request.reqEngineer , ) ,
      ],));

  }
   Padding replay  ()
  {
    return Padding(
        padding:  EdgeInsets.all(8.0),
    child:
      new Row(children: <Widget>[
        new Text(AppLocalizations.of(context).translate("reply")    , style: new TextStyle(color: MyColors.semoni ),) ,
        new Text(" not replay yet  " , ) ,
      ],));

  }
  List<Images> imagesList = new List<Images>();
  Flexible imageListView() {
    return new Flexible(
      child: new ListView.builder(

          shrinkWrap: true,
        //  physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: imagesList.length,
          itemBuilder: (context, index) {
            return
              GestureDetector(
                onTap:(){
                  showDialog(
                      context: context,
                      builder: (_) {
                        return ImageView( imagesList[index].url);
                      });
              // String name  =  list[index].  name ;
              //  print(name )  ;
            } ,
            child:  Image.network(Api.baseUrl  +  imagesList[index].url , width: 200,));
          }) ,

      fit: FlexFit.loose,
    );
  }






}