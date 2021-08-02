import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_system/ApiConnections/httpRequest.dart';
import 'package:support_system/Model/client.dart';
import 'package:support_system/Model/request.dart';
import 'package:support_system/Screens/addRequest.dart';
import 'package:support_system/Screens/requestDetails.dart';
import '../app_localizations.dart';
import '../my_colors.dart';
 class Requests extends StatefulWidget  {
   @override
   RequestState createState() => RequestState();

 }
  class  RequestState extends  State<Requests> with WidgetsBindingObserver{
    AppLifecycleState state;
    @override
    void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
      state = appLifecycleState;
      print(state);
      print(":::::::");
    }
    List <Request> requestList   = new    List <Request> () ;
    Client clientLocalData ;

    Future <void> getRequests() async{
      Api api  = new Api()  ;
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      clientLocalData = Client.fromJson(json.decode( sharedPrefs.getString("user") )) ;
     api.getRequests(clientLocalData.clientId, clientLocalData.parentId, onGetRequest)  ;
    }
     void onGetRequest  ( List <Request> requests)
     {
       setState(() {
         loading = false;
         requestList = requests ;
       });
     }
      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequests() ;
    WidgetsBinding.instance.addObserver(this) ;
      }
    @override
    void dispose() {
      super.dispose();

      print('dispose: $this');

      WidgetsBinding.instance.removeObserver(this);
    }
    Widget noThingView(){
      return new Container(child:
      new Center(
        child:  new Column( children: <Widget>[
        //  Image.asset('images/nothing.png', fit: BoxFit.contain),
          Text (AppLocalizations.of(context).translate("no_requests"))
        ], mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,),
      ) , height: double.infinity, ) ;
    }

   @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
     print ("change")  ;
  }
    bool loading = true ;
    Color  backgroundReq  = Colors.white ;

    @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("requests")),
    backgroundColor: MyColors.blue,
    ),
    backgroundColor: MyColors.grey,
     floatingActionButton: new FloatingActionButton(onPressed: onAddRequestClick , backgroundColor: MyColors.semoni,  child: Icon(Icons.add),
     ),
    body: loading? new Center(
      child: CircularProgressIndicator(),
    ): getView() ,
    );
  }
  Widget getView(){
      if(requestList.length>0){
      return new ListView.builder(
        itemBuilder: (context  , index ){
          return listCard( index) ;
        } ,itemCount:  requestList.length , ) ; }
      else{
    return    noThingView()  ;
      }
  }
  Color getBackgroundColor(Request req ){
        if(req.statuesID == 1 ) {
          backgroundReq  = Colors.blue ;
        return  backgroundReq  ;
        }
      else  if(req.statuesID == 2 ) {
              backgroundReq  = Colors.greenAccent  ;
              return  backgroundReq  ;

        }
      else  if(req.statuesID == 3 ) {
              backgroundReq  = Colors.orange ;
              return  backgroundReq  ;

        }
      else  if(req.statuesID == 4) {
            backgroundReq  = Colors.green ;
          return  backgroundReq  ;

        }
     else   if(req.statuesID ==  5) {
            backgroundReq  = Colors.red ;
          return  backgroundReq  ;

        }
      else  if(req.statuesID == 6 ) {
            backgroundReq  = Colors.yellow ;
          return  backgroundReq  ;

        }
      else{
          return  backgroundReq  ;

        }





  }
  GestureDetector  listCard  ( int index) {
      Request requestItem  = requestList[index] ;
      getBackgroundColor(requestItem ) ;
   return  GestureDetector(
         onTap:(){
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => RequestDetails(requestItem)),
           );
          // String name  =  list[index].  name ;
         //  print(name )  ;
         } ,
         child : new Padding(padding: EdgeInsets.only(top: 8.0  , bottom:  8.0  , right: 16.0 , left:  16.0 )  ,
          child :   new Card(

          child:new Container(
           // color: backgroundReq,
          //  padding:  new EdgeInsets.all(8.0),
            child:  new Column(

              children: <Widget>[
            new Container(
              padding:  new EdgeInsets.all(8.0),

              child:
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: <Widget>[
                new Align(child: new Text(requestItem.statues) ,alignment: Alignment.centerLeft,),
                new Align(child: new Text("#"+requestItem.reqNum.toString()) ,alignment: Alignment.centerRight,),

              ],mainAxisSize: MainAxisSize.max,) , color: backgroundReq,)  ,
  new Padding(padding: EdgeInsets.all(16.0)  , child: new Text(requestItem.reqDisc) ,) ,
new Container(
    padding:  new EdgeInsets.all(8.0),

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
                        text: requestItem.date,
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
                        text: requestItem.time,
                        style: TextStyle(color: Colors.grey),
                      ) ,
                    ],
                  ),
                )) ,
              ],
                ) )  ,
            ],),
          ) ,

           color: Theme.of(context).cardColor,
           //RoundedRectangleBorder, BeveledRectangleBorder, StadiumBorder
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.vertical(
                 bottom: Radius.circular(10.0),
                 top: Radius.circular(10.0)),
           ),

         ) ));
   }
    void onAddRequestClick (){
       setState(() {
         Navigator.push(
           context,
           MaterialPageRoute<String>(builder: (context) => AddRequest()),

         ).then((String value) {
            if (value  == "done") {
              getRequests() ;
            }
           print(value);
         });

       });
    }


  }