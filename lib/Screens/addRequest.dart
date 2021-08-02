import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_system/ApiConnections/httpRequest.dart';
import 'package:support_system/Model/Branch.dart';
import 'package:support_system/Model/client.dart';
import 'package:support_system/Model/request.dart';
import '../app_localizations.dart';
import '../my_colors.dart';
 import 'package:intl/intl.dart';
import  'package:keyboard_actions/keyboard_actions.dart';


class AddRequest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RequestState();
  }
}

enum Answers { Camera, Gallery }

class RequestState extends State<AddRequest> {
  List<String> systemList = new List<String>();

  List<Image> imagesList = new List<Image>();

  TextEditingController reqDescription  = new TextEditingController();
int selectedServiceId  = 0  ;
int selectedSystemId   = 0  ;
int selectedBranchId   = 0  ;
int selectProblemId   = 0  ;
String reqErr  = null ;
String selectedServiceName ;
String selectedSystemName ;
String selectedBranchName ;
String selectedProblemName ;
  Client clientLocalData ;
  String currentDate   ;
  String currentTime ;
   void getDataTime  () {
     var now = new DateTime.now();
     var formatter = new DateFormat('dd/MM/yyyy');
     var timeFormat =  new DateFormat( 'hh:mm aaa')  ;
      currentDate = formatter.format(now);
      currentTime = timeFormat.format(now);
    // print(formatted);
     //print(time);
   }
  Api api  = new Api()  ;
  Future <void> getData() async{

    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    clientLocalData = Client.fromJson(json.decode( sharedPrefs.getString("user") )) ;
    api.getClientBranches(clientLocalData.clientId.toString() , onGetBranches ) ;
    api.getService("6" , onGetServices ) ;
    api.getService("7" , onGetProblems ) ; // problemlist
    api.getSystems(clientLocalData.clientId.toString() , onGetSystem ) ;
    if(clientLocalData.clientBranchId !=0){
    selectedBranchName = clientLocalData.clientBranchName ;
    selectedBranchId =clientLocalData . clientBranchId ;
    }
  }
  List <Branch> branchesList = new  List() ;
  List <Branch> systemsList = new  List() ;
  List <Branch> servicesList = new  List() ;
  List <Branch> problemList = new  List() ;
  void onGetBranches (var branchList ){

    setState(() {
      for(int i  =  0 ; i <branchList.length ; i++){
       Branch    branch =      Branch.fromJson(branchList[i])  ;
        branchesList.add( branch) ;
      }
if(clientLocalData .clientBranchId == 0 ){
  selectedBranchName = branchesList[0].branchName ;
  selectedBranchId =branchesList[0]. branchID ;
}
    });

  }
  void onGetServices (var serviceList ){
    setState(() {
      for(int i  =  0 ; i <serviceList.length ; i++){
          Branch    service =      Branch.serviceFromJson(serviceList[i])  ;
        servicesList.add( service) ;
      }
    });}
  void onGetProblems (var serviceList ){
    setState(() {
      for(int i  =  0 ; i <serviceList.length ; i++){
        Branch    problem =      Branch.serviceFromJson(serviceList[i])  ;
        problemList.add( problem) ;
      }
    });}
    void onGetSystem (var systemList ){
      setState(() {
        for(int i  =  0 ; i <systemList.length ; i++){
         Branch    system =      Branch.systemFromJson(systemList[i])  ;
        systemsList.add( system) ;

        }
      });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     selectedBranchName  = " اختر الفرع " ;
     selectedSystemName  = " اختر النظام " ;
     selectedServiceName  = " اختر نوع الطلب " ;
     selectedProblemName  = " اختر المشكله " ;

    menuItems = List<PopupMenuEntry<String>>();
    getData() ;
  }
   String errorMsg =  ""     ;
   String errorMsg2 =  ""     ;
   String errorMsg3 =  ""     ;
   String errorMsgProblem =  ""     ;
    bool errorBranch = false ; bool errorSystem = false ; bool errorRequestType = false ; bool errorProblem = false ;

  @override
  Widget build(BuildContext context) {
    menuItems.add(new PopupMenuItem<String>(
      child: new Text(AppLocalizations.of(context).translate("delete")),
      value: "delete",
    ));
    // TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).translate("add_req")),
        backgroundColor: MyColors.blue,
      ),
      backgroundColor: MyColors.grey,
      body:
          //  SingleChildScrollView( child:

    loading?
    KeyboardActions(
        config:  KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL, //optional
        keyboardBarColor: Colors.grey[200], //optional
        nextFocus: true, //optional
        actions: [
test(),
],),


          child:ListView(         children: <Widget>[


      createServiceDropDown(),
            errorRequestType ? new Padding(padding:new EdgeInsets.only( left: 40.0  , right: 40.0 ,) ,child:
            new Align(alignment: Alignment.topLeft,child:new Text(errorMsg2 ,style:  new TextStyle(color: Colors.red , fontSize: 12),) ,)  ):SizedBox(),
            createSystemDropDown(),
            errorSystem? new Padding(padding:new EdgeInsets.only(left: 40.0  , right: 40.0) ,child:
            new Align(alignment: Alignment.topLeft,child:new Text(errorMsg ,style:  new TextStyle(color: Colors.red , fontSize: 12),) ,)  ): SizedBox() ,

            dropDownVisibility ? createProblemsDropDown(): SizedBox() ,
            errorProblem ? new Padding(padding:new EdgeInsets.only( left: 40.0  , right: 40.0 ,) ,child:
            new Align(alignment: Alignment.topLeft,child:new Text(errorMsgProblem ,style:  new TextStyle(color: Colors.red , fontSize: 12),) ,)  ):SizedBox(),


            createBranchDropDown(),
           errorBranch? new Padding(padding:new EdgeInsets.only(left: 40.0  , right: 40.0 ) ,child:
            new Align(alignment: Alignment.topLeft,child:new Text(errorMsg3 ,style:  new TextStyle(color: Colors.red , fontSize: 12),) ,)  ):SizedBox(),
            createTextField(reqDescription, "des_request", 'images/request.png', reqErr),
            //new IconButton(icon: new Icon(Icons.camera_enhance , color: MyColors.semoni,), onPressed: _askUser , ),
             addImageBtn?addAttachmentBtn():SizedBox(),
            imageListView(),
            sendRequestBtn(),

  ], ))
        // )
      :new Center(
      child: CircularProgressIndicator(),
    ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////
  SizedBox imageListView() {
    return
      //new Flexible(
      SizedBox(
        height: 200, // constrain height


      child: new ListView.builder(
          physics: const NeverScrollableScrollPhysics(),


          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: imagesList.length,
          itemBuilder: (context, index) {
            return new PopupMenuButton<String>(
              initialValue: "delete",
              onSelected: onSelect,
              child: imagesList[index],
              itemBuilder: (BuildContext context) {
                return menuItems;
            },
            );
          }),
    );
  }

  FlatButton addAttachmentBtn() {
    return new FlatButton.icon(
        onPressed: _askUser,
        icon: new Icon(
          Icons.camera,
          color: MyColors.semoni,
        ),
        label: new Text(AppLocalizations.of(context).translate("select_image")));
  }
  void onSelectBranch(Branch branch){
    setState(() {
      selectedBranchId = branch.branchID ;
      selectedBranchName  = branch.branchName ;
    });
  }
  Padding createBranchDropDown(){
    // selectBranch =  "test2" ;
    return
      new Padding(padding:new EdgeInsets.only(bottom: 8.0 , left: 40.0  , right: 40.0 , top: 8.0) ,child:
      new DropdownButton<Branch>(

        isExpanded: true,
        items: branchesList.map((Branch value) {
          return new DropdownMenuItem<Branch>(
            value: value,
            child: new Text(value.branchName),
          );
        }).toList(),

        onChanged: onSelectBranch,
        hint:  Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.ac_unit, color: MyColors.semoni,),
            ),
            new Text(
               selectedBranchName)       ],
        ),
        iconEnabledColor: MyColors.semoni,
      )) ;
  }

  void onSelectSystem(Branch system) {
    setState(() {
      selectedSystemId = system.branchID ;
      selectedSystemName = system.branchName ;
    });
  }

  Padding createSystemDropDown() {
    return new Padding(
        padding:
            new EdgeInsets.only(bottom: 8.0, left: 40.0, right: 40.0, top: 8.0),
        child: new DropdownButton<Branch>(
          isExpanded: true,
          items: systemsList.map((Branch value) {
            return new DropdownMenuItem<Branch>(
              value: value,
              child: new Text(value.branchName),
            );
          }).toList(),
          onChanged: onSelectSystem,
          hint: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(
                  Icons.ac_unit,
                  color: MyColors.semoni,
                ),
              ),
              new Text(selectedSystemName),
            ],
          ),
          iconEnabledColor: MyColors.semoni,
        ));
  }

  void onSelectService(Branch service) {
    setState(() {
      selectedServiceId = service.branchID  ;
       selectedServiceName = service.branchName ;
        if (selectedServiceId == 3 || selectedServiceId == 2){
          dropDownVisibility = true ;
        }
        else{
          dropDownVisibility = false ;
        }
      print(selectedServiceId);
    });
  }
  Padding createServiceDropDown() {
    return new Padding(
        padding:
            new EdgeInsets.only(bottom: 8.0, left: 40.0, right: 40.0, top: 8.0),
        child: new DropdownButton<Branch>(
          isExpanded: true,
          items: servicesList.map((Branch  value) {
            return new DropdownMenuItem<Branch>(
              value: value,
              child: new Text(value.branchName),
            );
          }).toList(),
          onChanged:  onSelectService,
          hint: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(
                  Icons.ac_unit,
                  color: MyColors.semoni,
                ),
              ),
              new Text(selectedServiceName),
            ],
          ),
          iconEnabledColor: MyColors.semoni,
        ));
  }
  void onSelectProblem(Branch service) {
    setState(() {
        selectProblemId = service.branchID  ;
        selectedProblemName = service.branchName ;
     print(selectedServiceId);
    });
  }
   bool dropDownVisibility = false ;
  Padding createProblemsDropDown() {
    return

      new Padding(
         padding:
         new EdgeInsets.only(bottom: 8.0, left: 40.0, right: 40.0, top: 8.0),
         child: new DropdownButton<Branch>(
           isExpanded: true,
           items: problemList.map((Branch  value) {
             return new DropdownMenuItem<Branch>(
               value: value,
               child: new Text(value.branchName),
             );
           }).toList(),
           onChanged:  onSelectProblem,
           hint: Row(
             children: <Widget>[
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: 12.0),
                 child: Icon(
                   Icons.ac_unit,
                   color: MyColors.semoni,
                 ),
               ),
               new Text(selectedProblemName),
             ],
           ),
           iconEnabledColor: MyColors.semoni,
         ));


  }

  Padding createTextField(TextEditingController controller, String hint,
      String iconName, String error_message) {
    return new Padding(
        padding:
            new EdgeInsets.only(bottom: 8.0, left: 40.0, right: 40.0, top: 8.0),
        child: new TextField(
          controller: controller,
          focusNode: _nodeText5,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).translate(hint),
            fillColor: Colors.white,
            filled: false,
            errorText: error_message,

            /*prefixIcon: Icon(
              Icons.note,
              color: MyColors.semoni,),*/
            /* icon: Icon(
             Icons.edit,
             color: MyColors.semoni,) , */

              suffixIcon:  Icon(
                Icons.edit,
                color: MyColors.semoni,) ,

          ),
          maxLines: 4,
        ));
  }
    void onAddRequestResponse (String response ){
     print(response) ;
     if(response == "success") {
       loading = true ;
       onRequestAddedWindow(AppLocalizations.of(context).translate("request_done"))
      ;

     }
      else {
        loading  = true ;
       onRequestAddedWindow(AppLocalizations.of(context).translate("error")) ;
     }
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
                 if(message == AppLocalizations.of(context).translate("request_done")) {
                   Navigator.of(context).pop("done");

                 }
              },
            ),
          ],
        );
      },
    );
  }
  bool loading = true ;

  void onSendRequestBtn() {
    setState(() {
      if(requestValidation()) {
        // add request
        loading= false ;

        getDataTime() ;
        Api api  = new Api()  ;
Request request  = new Request(branchID: clientLocalData.ourBranchId , clientBranchID: selectedBranchId , date: currentDate , time: currentTime , reqDisc: reqDescription.text , requestTypeID:  selectedServiceId
    , systemID:  selectedSystemId  ,problemID: selectProblemId  , reqImages: ordImg) ;
 Map  bodyMap  = request.newRequestMap(clientLocalData.clientId, clientLocalData.parentId ,clientLocalData.responseEmp) ;
api.addNewRequest(bodyMap, onAddRequestResponse)  ;
      }
    });
  }

  Padding sendRequestBtn() {
    return new Padding(
        padding:
            EdgeInsets.only(bottom: 8.0, left: 40.0, right: 40.0, top: 8.0),
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
                onPressed: onSendRequestBtn,
                child: new Text(
                  AppLocalizations.of(context).translate("send_request"),
                  style: new TextStyle(color: Colors.white),
                ),
              ),
            ))
    )
    ;
  }
   final FocusNode _nodeText5 = FocusNode();

  KeyboardActionsItem  test(){

    return KeyboardActionsItem(
    focusNode: _nodeText5,
    toolbarButtons: [
    //button 1
    (node) {
    return GestureDetector(
    onTap: () => node.unfocus(),
    child: Container(
    color: Colors.white,
    padding: EdgeInsets.all(8.0),
    child: Text(
      AppLocalizations.of(context).translate("close"),
    style: TextStyle(color: Colors.black),
    ),
    ),
    );
  }]);}
  File _image;
  bool addImageBtn = true ;
  // List<String> ordImg = new List();
String ordImg  =  "";
  Future getImage(String type) async {
    var image;
    if (type == "camera") {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _image = image;
      List<int> imageBytes = image.readAsBytesSync();
     // print(imageBytes);
      String base64Image = base64Encode(imageBytes);
ordImg = base64Image ;
addImageBtn  = false ;
      print("image");
      List  imName  = _image.toString().split("/") ;
     String m = imName[imName.length-1] ;
      print(m) ;
 //api.sendImage(parentID: clientLocalData.parentId , clientId: clientLocalData.clientId , imagePath: _image.toString() ,requestID: 0 , onResponse: (msg){
  // print(msg);
 //} );
      print(_image);
      imagesList.add(Image.file(_image));
    });
  }

  /* File _image;
   Future getImageGallery() async{
    var imageFile=await ImagePicker.pickImage(source: ImageSource.gallery);
    final tempDir=await getTemporaryDirectory();
    final path=tempDir.path;
    final id=await FirebaseAuth.instance.currentUser();
    String uid=id.uid;

    int rand=Math.Random().nextInt(100000);
    Img.Image image=Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImage=Img.copyResize(image, 500);
    var compressImg=File("$path/image_$uid.jpg")
     ..writeAsBytesSync(Img.encodeJpg(smallerImage,quality: 85));
    setState(() {
     _image=imageFile;
    });
   }*/

  Future _askUser() async {
    switch (await showDialog(
        context: context,
        builder: (context) {
         return new SimpleDialog(
          title: new Text(AppLocalizations.of(context).translate("select_image")),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Padding(
                  padding: new EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                  child: new Row(
                    children: <Widget>[
                      new Padding(
                          padding: new EdgeInsets.only(left: 8.0, right: 8.0),
                          child: new Icon(
                            Icons.camera_alt,
                            color: MyColors.semoni,
                          )),
                      new Text(AppLocalizations.of(context).translate("camera")),
                    ],
                  )),
              //new Text("Yes" , style:  new de,) ,
              onPressed: () {
                Navigator.pop(context, Answers.Camera);
              },
            ),
            new SimpleDialogOption(
              child: new Padding(
                  padding: new EdgeInsets.all(8.0),
                  child: new Row(
                    children: <Widget>[
                      new Padding(
                          padding: new EdgeInsets.only(left: 8.0, right: 8.0),
                          child: new Icon(
                            Icons.image,
                            color: MyColors.semoni,
                          )),
                      new Text(AppLocalizations.of(context).translate("gallery")),
                    ],
                  )),
              onPressed: () {
                Navigator.pop(context, Answers.Gallery);
              },
            ),
          ],
         );}
          )
          )
          {
      case Answers.Camera:
        getImage("camera");
        break;
      case Answers.Gallery:
        getImage("gallery");

        break;
    }
  }

  void onSelect(String v) {
    setState(() {
      if (v == "delete") {
        imagesList.removeAt(index);
      }
    });
  }

  int index = 0;

  List<PopupMenuEntry<String>> menuItems;

  void popupDelete() {

  }
   bool requestValidation () {
     bool validate  = true  ;
     reqErr = null  ;
      errorMsg="" ;
      errorMsg2="" ;
      errorMsg3="" ;
      errorMsgProblem = "" ;
      errorBranch = false ;  errorSystem = false ;  errorRequestType = false ;  errorProblem = false ;

     if(selectedBranchId==0 ){
          validate = false  ;
           errorMsg3  =  AppLocalizations.of(context).translate("enter")+ " " +selectedBranchName ;
            errorBranch = true  ;
        }

       if( selectedServiceId == 0){
         errorMsg2  =  AppLocalizations.of(context).translate("enter")+ " " +selectedServiceName ;

         validate = false  ;
          errorRequestType = true ;


       }if ( selectedSystemId ==  0 ){
       errorMsg  =  AppLocalizations.of(context).translate("enter")+ " " +selectedSystemName;

       validate = false  ;
       errorSystem = true ;


     }
       if( dropDownVisibility && selectProblemId == 0){
         errorMsgProblem  =  AppLocalizations.of(context).translate("enter")+ " " +selectedProblemName;

         validate = false  ;
         errorProblem = true ;
       }
        if( reqDescription.text.isEmpty) {
          validate = false  ;

          reqErr =  AppLocalizations.of(context).translate("enter")+ " "+ AppLocalizations.of(context).translate("des_request") ;
    }
     return validate ;
   }
}
