

class Client {
   int clientId  ;
   int clientsUID  ;
   int parentId  ;
   int userType  ; // 1 main 2 -employee
   int ourBranchId ; // branch b
   String ourBranchName ; // branch b
   String lName ;  // arabic name
   String fName ;  // English name
   String phone ;
   String email ;
   int clientBranchId   ;
   String clientBranchName   ;
   String job ;
   String clientUserName ;
   bool   firstLogin ;
   bool   clientState ;
   String password ;
   int responseEmp ;
   String responseEmpNm  ;
   String responseEmpPhone  ;



   factory Client.fromJson (Map<String  ,dynamic> json){
      return Client._(
         clientId: json['ClientID'] , parentId: json['ParentID'] ,
         userType: json['UserTypeID'] , ourBranchId: json['BranchID'] ,
         ourBranchName: json['Branch_L_Nm'] , lName: json['User_L_Nm'] ,
         fName: json['User_F_Nm'] , firstLogin: json['Frst_Login'] ,
         clientState: json['User_State'] , clientUserName: json['Clint_Usr_Nm'] ,
         clientBranchId: json['Client_Branch'] , clientBranchName: json['Client_Branch_Nm'] ,
          job: json['User_Job']  , clientsUID: json['ClientsUsersUID'] , responseEmp:json['Res_EmployeeID'] ,
          responseEmpNm: json['Res_En_Nm'] ,
          responseEmpPhone: json['Res_Phone_No']  );
   }

   Map<String, dynamic> toJson() {
      return {
         "ClientID": this.clientId,
         "ParentID": this.parentId ,
         "UserTypeID": this.userType ,
         "BranchID": this.ourBranchId ,
         "User_F_Nm": this.fName ,
         "User_L_Nm": this.lName ,
         "Clint_Usr_Nm": this.clientUserName ,
         "Client_Branch": this.clientBranchId ,
         "Client_Branch_Nm": this.clientBranchName ,
         "User_Job": this.job ,
         "ClientsUsersUID": this.clientsUID ,
         "Frst_Login": this.firstLogin ,
         "Res_EmployeeID": this.responseEmp ,
        "Res_En_Nm" : this.responseEmpNm ,
        "Res_Phone_No" : this.responseEmpPhone ,
      };
   }

   Client.changePass(this.clientsUID, this.password);

   Client._({this.clientId, this.parentId, this.userType, this.ourBranchId,
       this.ourBranchName, this.lName, this.fName, this.clientBranchId,
       this.clientBranchName, this.job, this.clientUserName, this.firstLogin,
       this.clientState , this.clientsUID , this.responseEmp , this.responseEmpNm , this.responseEmpPhone});

   Client(this.clientUserName, this.password);

   Map loginMap() {
      var map = new Map<String, dynamic>();
      map["Clint_Usr_Nm"] = clientUserName;
      map["Clint_Usr_Ps"] = password;
      return map;
   }
   Map changePassMap(String newPass) {
      var map = new Map<String, dynamic>();
      map["ClientsUsersUID"] = clientsUID.toString();
      map["Clint_Usr_Ps"] = password;
      map["Clint_Usr_Ps_New"] = newPass;
      print(map.toString()) ;
      return map;
   }


   @override
   String toString() {
      return 'Client{clientId: $clientId, parentId: $parentId, userType: $userType, ourBranchId: $ourBranchId, ourBranchName: $ourBranchName, lName: $lName, fName: $fName, phone: $phone, email: $email, clientBranchId: $clientBranchId, clientBranchName: $clientBranchName, job: $job, clientUserName: $clientUserName, firstLogin: $firstLogin, clientState: $clientState, password: $password}';
   }

}