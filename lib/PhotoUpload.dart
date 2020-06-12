import 'package:PilotingApp/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadPhotoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _UploadPhotoPageState();
  }

}

class _UploadPhotoPageState extends State<UploadPhotoPage>{

  File _sampleImage;
  String _myValue;
  String url;

  final formKey = new GlobalKey<FormState>();
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _sampleImage = File(pickedFile.path);
    });
  }

  bool validateAndSave(){

    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  }

  void uploadStatusImage() async{
    if(validateAndSave()){
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");

      //generate a random key

      var timekey = new DateTime.now();

      final StorageUploadTask uploadTask = postImageRef.child(timekey.toString() + ".jpg").putFile(_sampleImage);

      var ImageUrl = await(await uploadTask.onComplete).ref.getDownloadURL();

      url = ImageUrl.toString();

      print("Image URL" +url);

      goToHomePage();
      saveToDatabase(url);

    }
  }

  void saveToDatabase(url){
    var dbTimekey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimekey);
    String time = formatTime.format(dbTimekey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "image": url,
      "description": _myValue,
      "date": date,
      "time": time,
    };

    ref.child("Posts").push().set(data);
  }

  void goToHomePage(){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context){
        return new HomePage();
      }
      )
      );
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Upload Image"),
        centerTitle: true,
      ),

      body: new Center(
        child: _sampleImage == null? Text("Select an Image"): enableUpload(),
      ),

      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload(){

    return Container(

      child: new Form(

      key: formKey,

          child: Column(

            children: <Widget>[

              Image.file(_sampleImage, height: 310.0, width: 660.0,),

              SizedBox(height: 15.0,),

              TextFormField(

                decoration: new InputDecoration(labelText: 'Description'),

                validator: (value){

                  return value.isEmpty ? 'Description is required' : null;
                },

                onSaved: (value){

                  return _myValue = value;
                },

              ),

              SizedBox(height: 15.0,),

              RaisedButton(

                elevation: 10.0,
                child: Text("Add New Post"),
                textColor: Colors.white,
                color: Colors.pink,
                onPressed: uploadStatusImage,
                ),

            ],

          ),

      ),

    );
  }
}