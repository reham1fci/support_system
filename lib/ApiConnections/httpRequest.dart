/*
 *
 *  Created by Eng. Reham Mokhtar on 03/02/20 12:19 م
 *   Copyright (c) 2020 . All rights reserved.
 *   Last modified 30/01/20 02:21 م
 *
 */

import 'package:http/http.dart'  as http ;
import 'package:support_system/Model/Branch.dart';
import 'package:support_system/Model/Images.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'package:support_system/Model/client.dart';
import 'package:support_system/Model/request.dart';
import 'package:support_system/Screens/login.dart';
class Api  {
   static final String  baseUrl  = "https://maxcrm.org/"  ;
  Future <Client> login({String name , String password , Function  onLogin  , Function onError}  )async{
    String url  = baseUrl+"Client/userlogin";
    Client client = new Client(name, password)  ;
    http.post(url ,body  : client.loginMap() ,) .then((http.Response response) {
      print(response.statusCode);
    if(response.statusCode == 200) {
      print(response.body) ;
      var jsonObj = json.decode(response.body);
      var  resultObj  = jsonObj  ['result']  ;
      var  userObj  = resultObj  ['user']  ;


      print("login") ;

    print(jsonObj) ;
     String  msg  = userObj  ['message']  ;
     print(msg)  ;
      if(msg  == "found") {
          Client c = Client.fromJson(userObj) ;
          onLogin(c)  ;
          return c ;
      }
       else
         {
          onError(msg);
           return null  ;
      }
    }
     else {
      onError("connection error ") ;
      return null ;
    }
    }
    );

  }

  Future getClientBranches  (String clientId  , Function getBranches )async {
    String url  = baseUrl+"Client/lslclintbranchs";
    var map = new Map<String, dynamic>();
    map["ClientID"] = clientId;
     http.post(url  ,body: map ).then((http.Response response) {
       print(response.statusCode) ;

       if(response.statusCode == 200) {
        var obj = json.decode(response.body);
      //  print(branchList) ;
       var result = obj['result'] ;  //array with key
       var branchList = result['branchs'] ;  //array with key
        getBranches(branchList)  ;
      /*  for(int i  =  0 ; i <branchList.length ; i++){
          Branch    branch =      Branch.fromJson(branchList[i])  ;
          branches.add( branch) ;

        }
        getBranches(branches) ;
        print(branches)  ;*/
      }
       else{
         print("error") ;
      }
    });
  }
   Future addNewUser ({int clientId , int branchId  , String userAName , String userEName , String phone , String email , String userName
       , String password, int clientBranch , String job , Function onAddUserResponse}){
     String url  = baseUrl+"Client/clintadduser";

       var map = new Map<String, dynamic>();
      map["ClientID"] = clientId.toString() ;
      map["BranchID"] = branchId.toString() ;
      map["User_L_Nm"] = userAName ;
      map["User_F_Nm"] = userEName ;
      map["User_Phone"] = phone ;
      map["User_Mail"] = email ;
      map["Clint_Usr_Nm"] = userName ;
      map["Clint_Usr_Ps"] = password ;
      map["Client_Branch"] = clientBranch.toString() ;
      map["User_Job"] = job ;
      print(map) ;
       http.post(url  ,body: map ).then((http.Response response) {

       if(response.statusCode == 200) {
         var obj = json.decode(response.body);
          print(obj) ;
         var  result  = obj  ['result']  ;
         String  msg  = result  ['message']  ;

         onAddUserResponse(msg)  ;


       }

       else{print("error") ;}


   });

   }
     Future getSystems(
       String clientId  , Function onGetSystem )async {
       String url  = baseUrl+"Client/lslclintsubservc";
       var map = new Map<String, dynamic>();
       map["ClientID"] = clientId;
       http.post(url  ,body: map ).then((http.Response response) {
       if(response.statusCode == 200) {
       var serviceList = json.decode(response.body);
       print("system");
       print(serviceList);
       var obj = serviceList['result'] ;  //array with key
       var branchList = obj['subservc'] ;  //array with key
       onGetSystem(branchList)  ;
       }
       else{
       print("error") ;
       }
       });
}
   Future getService(
       String value  , Function onGetService )async {
     String url  = baseUrl+"Client/lstreqtypes";
     var map = new Map<String, dynamic>();
     map["Lst_Fltr"] = value;
     http.post(url  ,body: map ).then((http.Response response) {
       if(response.statusCode == 200) {
         var obj = json.decode(response.body);
         var result = obj['result'] ;  //array with key
         var serviceList = result['types'] ;
         // var branchList = branchJson[''] ;  //array with key
         onGetService(serviceList)  ;
       }
       else{
         print("error") ;
       }
     });
   }
    Future addNewRequest   (Map bodyMap  , Function onResponse )async{
      String url  = baseUrl+"Client/clintaddrequest";
bodyMap.toString() ;
      http.post(url  ,body: bodyMap ).then((http.Response response) {
        print(response.statusCode) ;
        if(response.statusCode == 200) {
          var result = json.decode(response.body);
           var obj = result['result'] ;  //array with key
          String  msg  = obj['message'];
          print("result");
              print(result) ;
          onResponse(msg)  ;
        }
        else{
          print("error") ;
        }
      });
    }
    Future getRequests (int clientID , int parentID  , Function onGetRequest)async{
      String url  = baseUrl+"Client/clintlstrequest";
       List<Request > requests  = new List() ;
      var map = new Map<String, dynamic>();
      map["ClientID"] = clientID.toString();
      map["User_ClientID"] = parentID.toString();
      http.post(url  ,body: map ).then((http.Response response) {
        if(response.statusCode == 200) {
          var jsonObj = json.decode(response.body);
          var  resultObj  = jsonObj  ['result']  ;
          var  result  = resultObj  ['clintlst']  ;
print(jsonObj)  ;
          for (int i  =  0  ; i <result.length  ; i++) {
            print(result[i]) ;
           Request    request =      Request.fromJson(result[i])  ;
           requests.add( request) ;

          }
          onGetRequest(requests)  ;

        }
        else{
          print("error") ;
        }
      });
    }



Future addRequestRate ({int clientID , int parentID  , int reqID , String date ,
    String time ,int rateService , int rateEng ,int ratResponse , String reqDesc,
   Function onResponse})async{
  String url  = baseUrl+"Client/reqrateing";
  var map = new Map<String, dynamic>();
  map["ClientID"] = clientID.toString();
  map["User_ClientID"] = parentID.toString();
  map["CliRequestsID"]= reqID.toString()  ;
  //map["Rate_Date"]= date;
 // map["Rate_Time"] = time;
  map["Rate_Service"]= rateService.toString();
  map ["Rate_Engineer"] =rateEng.toString() ;
  map["Rate_Response"] =ratResponse.toString() ;
  map["Request_Desc"] = reqDesc;
map.toString() ;
  http.post(url  ,body: map ).then((http.Response response) {
    print(response.statusCode ) ;
    if(response.statusCode == 200) {
      var obj = json.decode(response.body);
     // print("addreq result"+result);

      // var branchList = branchJson[''] ;  //array with key
      var  result  = obj  ['result']  ;
      String  msg  = result  ['message']  ;
      onResponse(msg)  ;
      print(msg) ;
    }
    else{
      print("error") ;
    }
  });
}
   Future sendImage ({int clientId , int requestID  , int parentID , String imagePath ,
      Function onResponse}){
     String url  = baseUrl+"uploadimgfldr";

     var map = new Map<String, dynamic>();
     map["ClientID"] = clientId.toString() ;
     map["User_ClientID"] = parentID.toString() ;
     map["httpRequest"] = imagePath ;
     map["CliRequestsID"] = requestID.toString() ;

     print(map) ;
     http.post(url  ,body: map ).then((http.Response response) {
       if(response.statusCode == 200) {
         var result = json.decode(response.body);
         print("addreq result"+result);
         String  msg  = result  ['Message']  ;
//print(msg);
         onResponse(msg)  ;


       }

       else{print("error") ;}


     });

   }
   Future cancelReq ( {int reqID  ,
     Function onResponse}){
     String url  = baseUrl+"Client/reqcancel";

     var map = new Map<String, dynamic>();
     map["CliRequestsUID"] = reqID.toString() ;

     print(map) ;
     http.post(url  ,body: map ).then((http.Response response) {
       if(response.statusCode == 200) {
         var obj = json.decode(response.body);
         var result = obj  ['result'] ;
         String  msg  = result  ['message']  ;
         onResponse(msg)  ;

       }

       else{print("error") ;}


     });

   }
   Future cancelClose ( {int reqID  ,String note ,
     Function onResponse}){
     String url  = baseUrl+"Client/reqnotcompleate";

     var map = new Map<String, dynamic>();
     map["CliRequestsUID"] = reqID.toString() ;
     map["Request_Note"] = note ;

     print(map) ;
     http.post(url  ,body: map ).then((http.Response response) {
       if(response.statusCode == 200) {
         var obj = json.decode(response.body);
         var result = obj  ['result'] ;
         String  msg  = result  ['message']  ;
         onResponse(msg)  ;

       }

       else{print("error") ;}


     });

   }
   Future getAppStatues ( {
     Function onResponse}){
     String url  = baseUrl+"Client/appstatus";

     http.get(url ).then((http.Response response) {
       if(response.statusCode == 200) {
         var obj = json.decode(response.body);
         var result = obj  ['result'] ;
         String  msg  = result  ['message']  ;
         onResponse(msg)  ;
         print(msg) ;

       }

       else{print("error") ;}


     });

   }
   Future getAppStatics ( { int clientId ,
     Function onResponse}){
     String url  = baseUrl+"Client/appdashboard";
     var map = new Map<String, dynamic>();
     map["ClientID"] = clientId.toString() ;


     print(map) ;
     http.post(url , body: map ).then((http.Response response) {
       if(response.statusCode == 200) {
         var obj = json.decode(response.body);
         var result = obj  ['result'] ;
         var user = result  ['user'] ;
         onResponse(user)  ;
         print(user) ;

       }

       else{print("error") ;}


     });

   }
   Future getImages (  {int reqID  ,
     Function onResponse}){
     String url  = baseUrl+"Client/clintlstrequestimgs";
List <Images>list  = new List() ;
     var map = new Map<String, dynamic>();
     map["CliRequestsID"] = reqID.toString() ;

     print(map) ;
     http.post(url  ,body: map ).then((http.Response response) {
       if(response.statusCode == 200) {
         var obj = json.decode(response.body);
         var result = obj  ['result'] ;
         var  imagesArr  = result  ['reqimges']  ;
          for(int i = 0  ; i  <imagesArr.length ; i++) {
            Images image  =  Images.fromJson(imagesArr[i]  );
            list.add(image) ;
          }
          onResponse(list) ;
        print(list) ;

       }

       else{print("error") ;}


     });

   }
}
