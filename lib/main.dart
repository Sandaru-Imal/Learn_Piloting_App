import 'package:PilotingApp/LoginRegisterPage.dart';
import 'package:flutter/material.dart';


void main(){
  runApp(new PilotingApp());
}

class PilotingApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Piloting App",
      theme: new ThemeData(
        primarySwatch: Colors.pink,
        ),

        home: LoginRegisterPage(),

    );
  }
}