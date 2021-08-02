/*
 *
 *  Created by Eng. Reham Mokhtar on 7/6/20 3:36 PM
 *   Copyright (c) 2020 . All rights reserved.
 *   Last modified 7/6/20 3:35 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:support_system/ApiConnections/httpRequest.dart';
import 'package:support_system/app_localizations.dart';
import 'package:support_system/my_colors.dart';

class CancelComplete extends StatefulWidget {
  int requestID   ;

  CancelComplete(this.requestID ,{Key key}): super(key: key);//add also

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _state();
  }
}
class _state extends State<CancelComplete> {
  int reqID ;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    reqID  = widget.requestID ;
    api = new Api();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  createCancelDialog();
  }
  TextEditingController noteEd = new TextEditingController();

  Dialog createCancelDialog (){


    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 200.0,
        width: 300.0,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            createTextField(noteEd)   ,
            createDoneBtn(),

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
  Widget createDoneBtn () {
    return
      new Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
      child:
      new Container(
          width: double.infinity,
          child:new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              Align(
                  alignment: Alignment.bottomLeft,
                  child: new Container(
                    decoration: new BoxDecoration(
                        color: MyColors.greyDark,
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(8.0),
                        )),
                    //  width: double.infinity,
                    child: new FlatButton(
                      onPressed: onDoneClick,
                      child: new Text(
                        AppLocalizations.of(context).translate("ok") ,
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  )) ,
              Align(
                  alignment: Alignment.bottomRight,
                  child: new Container(
                    decoration: new BoxDecoration(
                        color: MyColors.greyDark,
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(8.0),
                        )),
                    //  width: double.infinity,
                    child: new FlatButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: new Text(
                        AppLocalizations.of(context).translate("cancel") ,
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  ))
            ],)
        //  ))
      ) );
  }
  Api api ;
  String error_message  = null;
  void onDoneClick(){
    setState(() {
      error_message  = null ;
      String noteTxt  =  noteEd.text.toString() ;
      if(noteTxt.isEmpty) {
error_message  =   AppLocalizations.of(context).translate("enter") +  " " +AppLocalizations.of(context).translate("note") ;
      }
      else{
api.cancelClose(reqID: reqID ,note: noteTxt , onResponse:(msg){
  // dialog done Cancel
  if(msg == "success") {
    showAlert(msg) ;
  }
}  ) ;}
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
                Navigator.of(context).pop();
               Navigator.of(context).pop("done");
              },
            ),
          ],
        );
      },
    );
  }

  Padding createTextField(TextEditingController controller)
  {
    return new Padding(
        padding:
        new EdgeInsets.only(bottom: 8.0, left: 10.0, right: 10.0,),
        child: new TextField(
          controller: controller,
          decoration: InputDecoration(
            //hintText: AppLocalizations.of(context).translate(hint),
            hintText: AppLocalizations.of(context).translate("note"),
            fillColor: Colors.white,
            filled: false,
             errorText: error_message,
          ),
        ));
  }

}