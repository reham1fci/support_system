class Request {
String reqDisc  ;
String date  ;
String time  ;
int reqNum  ;
String statues  ;
String reqEngineer  ;
int systemID  ;
 String systemName ;
 String requestTypeName ;
int requestTypeID  ;
int clientBranchID  ;
int branchID   ;
String branchName  ;
String clientBranchName  ;
String reqImages;
int problemID ;
String problemName ;
bool isRated ;
int statuesID ;
int responseEmp ;
String empName  ;

Request({this.reqDisc, this.date, this.time, this.systemID, this.requestTypeID,
    this.clientBranchID, this.branchID , this.problemID   ,this.reqImages});


Request._({this.reqDisc, this.date, this.time, this.reqNum, this.statues,
    this.reqEngineer, this.systemID, this.systemName, this.requestTypeName,
    this.requestTypeID, this.clientBranchID, this.branchID, this.branchName,
    this.clientBranchName ,this.isRated ,this.statuesID , this.responseEmp , this.empName});
factory Request.fromJson (Map<String  ,dynamic> json){
 return Request._(
  systemID: json['Main_Service'],
  requestTypeID:json['Request_Type'],
  reqDisc:  json['Request_Desc'],
  time:     json['Request_Time'],
  date:     json['Request_Date'],
  clientBranchID:  json['Clint_Brnch_ID'],
  clientBranchName: json['Branch_L_Nm']  ,
  branchID: json['BranchID'] ,
  branchName:  json['Branch_L_Nm'] ,
  reqEngineer:  json['Res_Emp_L_Nm'],
  reqNum: json['CliRequestsUID']  ,
  requestTypeName:  json['Req_Type_L_Nm'],
  statues: json['App_Ar_Nm'] ,
  systemName: json['Sub_L_Nm']  ,
   isRated: json['IsRated']  ,
   statuesID: json['Request_Status']  ,
   responseEmp: json['Res_EmployeeID']  ,
   empName: json['Res_Ar_Nm']  ,

     );
}

@override
String toString() {
 return 'Request{reqDisc: $reqDisc, date: $date, time: $time, reqNum: $reqNum, statues: $statues, reqEngineer: $reqEngineer, systemID: $systemID, systemName: $systemName, requestTypeName: $requestTypeName, requestTypeID: $requestTypeID, clientBranchID: $clientBranchID, branchID: $branchID, branchName: $branchName, clientBranchName: $clientBranchName, reqImages: $reqImages, problemID: $problemID, problemName: $problemName}';
}



/*{
"CliRequestsUID": 1,
"Request_Date": "15/01/2020",
"RequestDate": "2020-01-15T00:00:00",
"Request_Time": "04:32 PM",
"Request_Day": "Wednesday",
"Request_Desc": "شاشة العملاء لا تحفظ",
"BranchID": 1,
"Branch_L_Nm": "جــده",
"Clint_Brnch_ID": 1,
"Client_Branch_Nm": "فرع جده",
"ClientID": 2,
"Client_L_Nm": "ماجد القحطاني",
"User_ClientID": 0,
"User_L_Nm": "ماجد القحطاني",
"Main_Service": 1,
"Main_L_Nm": "ماكس برو",
"Sub_Service": 1,
"Sub_L_Nm": "رئيسية",
"Request_Status": 2,
"Responsible_Emp": 2,
"Res_Emp_L_Nm": "عبد الوارث",
"Req_Status_L_Nm": "طلب مؤكد"
}*/







Map newRequestMap(int clientID , int usClientID, int responseEmp) {
 var map = new Map<String, dynamic>();
 map["Request_Desc"] = reqDisc;
 map["BranchID"] = branchID.toString();
 map["Clint_Brnch_ID"] = clientBranchID.toString();
 map["ClientID"] = clientID.toString();
 map["User_ClientID"] = usClientID.toString();
 map["Sub_Service"] = systemID.toString();
 map["Request_Type"] = requestTypeID.toString();
 map["Problem_Type"] = problemID.toString();
 map["ReqImgs"] = reqImages ;
 map["Responsible_Emp"] = responseEmp.toString() ;

 printWrapped(map.toString()) ;
 return map;
}
  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

}