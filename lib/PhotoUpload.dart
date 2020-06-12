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
                onPressed: validateAndSave,
                ),

            ],

          ),

      ),

    );
  }
}