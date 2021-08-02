import 'dart:convert';

import 'package:flutter/material.dart'  ;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:support_system/ApiConnections/httpRequest.dart';
import 'package:support_system/Model/client.dart';
import '../my_colors.dart';
import '../app_localizations.dart';
import 'package:intl/intl.dart';


class RatingDialog extends StatefulWidget {
  int requestID   ;

  RatingDialog(this.requestID ,{Key key}): super(key: key);//add also

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  new DialogState();
  }



}

 class DialogState   extends State<RatingDialog> {
   Client clientLocalData ;
   String currentDate   ;
   String currentTime ;
   int req_id ;
   void getDataTime  () {
     var now = new DateTime.now();
     var formatter = new DateFormat('dd/MM/yyyy');
     var timeFormat =  new DateFormat( 'hh:mm aaa')  ;
     currentDate = formatter.format(now);
     currentTime = timeFormat.format(now);
     // print(formatted);
     //print(time);
   }


   Future <void> getData() async{
     SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
     clientLocalData = Client.fromJson(json.decode( sharedPrefs.getString("user") )) ;
req_id  = widget.requestID ;

     }
     @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getData() ;

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  createCommentDialog () ;
  }

  var ratingEng = 0.0;
  var ratingService = 0.0;
  var ratingResponse = 0.0;
   Dialog createCommentDialog (){


      Dialog errorDialog = Dialog(
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
       child: Container(
         height: 400.0,
         width: 300.0,

         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Padding(
               padding:  EdgeInsets.all(15.0),
               child:   new Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                    new Text(AppLocalizations.of(context).translate("rate_service")  )  ,
                   starBarService(),
                 ],
               )
             ),
             Padding(
               padding: EdgeInsets.all(15.0),
               child:   new Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   new Text(AppLocalizations.of(context).translate("rate_engineer") )  ,

                   starBarEng(),

                 ],
               )
             ),
             Padding(
               padding: EdgeInsets.all(15.0),
               child:   new Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,

                 children: <Widget>[
                   new Text(AppLocalizations.of(context).translate("rate_response"))  ,
                   starBarResponse(),

                 ],
               )
             ),
             createTextField(commentEd)   ,
             addRateBtn(),

             /*  FlatButton(onPressed: (){
             Navigator.of(context).pop();
           },
               child: Text('Got It!', style: TextStyle(color: Colors.purple, fontSize: 18.0),))*/
           ],
         ),
       ),
     );
  //   showDialog(context: context, builder: (BuildContext context) => errorDialog);
   return errorDialog ;

   }
  TextEditingController commentEd = new TextEditingController();

  Padding createTextField(TextEditingController controller)
      {
    return new Padding(
        padding:
        new EdgeInsets.only(bottom: 8.0, left: 40.0, right: 40.0, top: 8.0),
        child: new TextField(
          controller: controller,
          decoration: InputDecoration(
            //hintText: AppLocalizations.of(context).translate(hint),
            hintText: AppLocalizations.of(context).translate("comment"),
            fillColor: Colors.white,
            filled: false,
          //  errorText: error_message,
          ),
        ));
  }
  void onAddRateClick() {
getDataTime() ;
      print("RESPONSE" + ratingResponse.toInt().toString()) ;
      print("service" + ratingService.toInt().toString()) ;
      print("enginner" + ratingEng.toInt().toString()) ;
      Api api  = new Api()  ;
    api.addRequestRate(
  clientID: clientLocalData.clientId ,
  date: currentDate ,
  parentID: clientLocalData.parentId ,
  rateEng: ratingEng.toInt(),
  ratResponse: ratingResponse.toInt(),
  rateService: ratingService.toInt(),
  onResponse: (response){
    setState(() {
      if (response == "success"){
        Navigator.of(context).pop();

        //_showToast(AppLocalizations.of(context).translate("rate_done")  , MyColors.colorPrimary) ;
        onRequestAddedWindow(AppLocalizations.of(context).translate("rate_done") ) ;

      }
      else{
        Navigator.of(context).pop();

        // _showToast(AppLocalizations.of(context).translate("error")  , Colors.red) ;
       onRequestAddedWindow(AppLocalizations.of(context).translate("error") ) ;

      }
    });


  },
  reqDesc: commentEd.text ,
  reqID: req_id ,
  time: currentTime



) ;

   //});
  }


  Padding addRateBtn() {
    return new Padding(
        padding:
        EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0, top: 8.0),
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
                  AppLocalizations.of(context).translate("send") ,
                  style: new TextStyle(color: Colors.white),
                ),
              ),
            ))
    )
    ;
  }

  SmoothStarRating starBarEng(){

    return  SmoothStarRating(
        starCount: 5,
        rating: ratingEng,
        size: 24.0,
        color: MyColors.semoni,
        borderColor: MyColors.semoni,
        spacing:0.0 ,
        onRatingChanged: (v) {
          setState(() {
            ratingEng = v;

          });
        }
    ) ;
  }
  SmoothStarRating starBarService(){

    return  SmoothStarRating(
        starCount: 5,
        rating: ratingService,
        size: 24.0,
        color: MyColors.semoni,
        borderColor: MyColors.semoni,
        spacing:0.0 ,
        onRatingChanged: (v) {
          setState(() {
            ratingService = v;

          });
        }
    ) ;
  }

  SmoothStarRating starBarResponse(){

    return  SmoothStarRating(
        starCount: 5,
        rating: ratingResponse,
        size: 24.0,
        color: MyColors.semoni,
        borderColor: MyColors.semoni,
        spacing:0.0 ,
        onRatingChanged: (v) {
          setState(() {
            ratingResponse = v;

          });
        }
    ) ;
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
                    if(message  == AppLocalizations.of(context).translate("rate_done") ) {

                      Navigator.of(context).pop();
                      Navigator.of(context).pop("done");

                    }


               },
             ),
           ],
         );
       },
     );
   }
 }