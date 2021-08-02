/*
 *
 *  Created by Eng. Reham Mokhtar on 7/7/20 6:05 PM
 *   Copyright (c) 2020 . All rights reserved.
 *   Last modified 7/7/20 6:01 PM
 *
 */
import 'package:photo_view/photo_view.dart';
import 'package:support_system/ApiConnections/httpRequest.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
class ImageView extends StatefulWidget  {
  String imageUrl   ;

  ImageView(this.imageUrl ,{Key key}): super(key: key);//add also

  @override
State<StatefulWidget> createState() {
  // TODO: implement createState
  return new ImageState();
}

}
class ImageState extends State<ImageView> {
  String imageUrlText ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageUrlText  = widget.imageUrl ;
    print(Api.baseUrl+imageUrlText) ;

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return createDialog();
  }
  Dialog createDialog (){


    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: double.infinity,
        width: 300.0,

       child:
      //  Image.network(Api.baseUrl  +  imageUrlText ,),
            PhotoView (
              imageProvider:
              CachedNetworkImageProvider(Api.baseUrl+imageUrlText),
            )
            /*  FlatButton(onPressed: (){
             Navigator.of(context).pop();
           },
               child: Text('Got It!', style: TextStyle(color: Colors.purple, fontSize: 18.0),))*/

      ),
    );
    //   showDialog(context: context, builder: (BuildContext context) => errorDialog);
    return errorDialog ;

  }
}