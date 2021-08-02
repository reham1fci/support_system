/*
 *
 *  Created by Eng. Reham Mokhtar on 03/02/20 01:10 م
 *   Copyright (c) 2020 . All rights reserved.
 *   Last modified 03/02/20 01:10 م
 *
 */
import 'package:flutter/material.dart';
class Alert extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  new _State();
  }

}
class _State  extends State<Alert> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
    static  Future<void> showAlert(String alertTitle  , String message  ,  BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertTitle),
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
              },
            ),
          ],
        );
      },
    );
  }

}