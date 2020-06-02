
import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'LoginRegisterPage.dart';
import 'Authentication.dart';

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

        home: MappingPage(auth: Auth(),),

    );
  }
}