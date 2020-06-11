import 'package:PilotingApp/Authentication.dart';
import 'package:PilotingApp/DialogBox.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';

class LoginRegisterPage extends StatefulWidget{

  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState(){
    return _LoginRegisterState();
  }
}

 enum FormType{
    login,
    register
  }

class _LoginRegisterState extends State<LoginRegisterPage>{

  DialogBox dialogBox = new DialogBox();

  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  //specify methods
  bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  }

  void validateAndSubmit() async{

    if(validateAndSave()){
      try{
        if(_formType == FormType.login){
          String userId = await widget.auth.SignIn(_email, _password);
          dialogBox.information(context, "Congratulations =","your have logged in succesfully");
          print("Login User Id = " +userId);
        }else{
          String userId = await widget.auth.SignUp(_email, _password);
          dialogBox.information(context, "Congratulations =","your account has been created successfully");
          print("register User Id = " +userId);
        }

        widget.onSignedIn();

      }catch(e){
        dialogBox.information(context, "Error =", e.toString());
        print("Error = " +e.toString());
      }
    }
  }

  void moveToRegister(){
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.login;
    });
  }

  //Desgin of Login/Register Page
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Piloting App"),
        backgroundColor: Colors.pink,
      ),

      body: new Container(
        margin: EdgeInsets.all(15.0),

        child: new Form(

          key: formKey,

          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButtons(),

          ),
          ),
      ),
    );
  }

  List<Widget> createInputs(){
    return[
      SizedBox(height: 10.0,),
      logo(),
      SizedBox(height: 20.0,),

      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value){
          return value.isEmpty ? 'Email is required' :null;
        },

        onSaved: (value){
          return _email = value;
        },
      ),

      SizedBox(height: 10.0,),

      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,

        validator: (value){
          return value.isEmpty ? 'Password is required' :null;
        },

        onSaved: (value){
          return _password = value;
        },

      ),

      SizedBox(height: 20.0,),

    ];
  }

  

  Widget logo(){
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset('images/airbus.png'),
      ),
      );
  }


  List<Widget> createButtons(){

    if(_formType == FormType.login){
      return[
    new RaisedButton(
      child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
      textColor: Colors.white,
      color: Colors.pink,


      onPressed: validateAndSubmit,
      ),

    new FlatButton(
      child: new Text("Not have an Account?", style: new TextStyle(fontSize: 14.0)),
      textColor: Colors.red,

       onPressed: moveToRegister,
      ),
    ];

    }else{

       return[
    new RaisedButton(
      child: new Text("Create Account", style: new TextStyle(fontSize: 20.0)),
      textColor: Colors.white,
      color: Colors.pink,

      onPressed: validateAndSubmit,
      ),

    new FlatButton(
      child: new Text("Already Registered?", style: new TextStyle(fontSize: 14.0)),
      textColor: Colors.red,

       onPressed: moveToLogin,
      ),
    ];

    }
  }
}
  
