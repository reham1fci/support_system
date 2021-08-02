/*
 *
 *  Created by Eng. Reham Mokhtar on 03/02/20 06:16 م
 *   Copyright (c) 2020 . All rights reserved.
 *   Last modified 03/02/20 06:16 م
 *
 */

class Branch {
  int  branchID  ;
  String  branchName  ;
  Branch({this.branchID, this.branchName});
 factory Branch.fromJson (Map<String  ,dynamic> json){
   return Branch(branchID:  json['RecordSerial']  , branchName: json['Branch_Nm']  )  ;
  }
  factory Branch.systemFromJson (Map<String  ,dynamic> json){
    return Branch(branchID:  json['SubServiceUID']  , branchName: json['Sub_L_Nm']  )  ;
  }
  factory Branch.serviceFromJson (Map<String  ,dynamic> json){
    return Branch(branchID:  json['Lst_ID']  , branchName: json['Lst_L_Nm']  )  ;
  }
  @override
  String toString() {
    return 'Branch{branchID: $branchID, branchName: $branchName}';
  }

}