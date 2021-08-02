/*
 *
 *  Created by Eng. Reham Mokhtar on 7/6/20 5:29 PM
 *   Copyright (c) 2020 . All rights reserved.
 *   Last modified 7/6/20 5:28 PM
 *
 */

class Images  {
  String url  ;
  int id ;
   int reqID   ;

  Images({this.url, this.id, this.reqID});

  Images._();

  factory Images.fromJson (Map<String  ,dynamic> json){
    return Images(reqID: json["CliRequestsID"] , id: json["ImgsRequestsUID"] , url: json["Img_Url"]) ;
  }
}