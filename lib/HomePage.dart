import 'package:PilotingApp/PhotoUpload.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'Posts.dart';

class HomePage extends StatefulWidget {
  HomePage({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Posts> postList = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference postRef = FirebaseDatabase.instance.reference().child('''
Posts''');
    postRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      print(KEYS);
      postList.clear();

      for (var individualKey in KEYS) {
        Posts posts = new Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
        );

        postList.add(posts);
      }
      setState(() {
        print('Length :  $postList.length');
      });
    });
  }

  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
        backgroundColor: Colors.pink,
      ),
      body: new Container(
        child: postList.length == 0
            ? new Text("No Blog Post available")
            : new ListView.builder(
                itemCount: postList.length,
                itemBuilder: (_, index) {
                  return PostsUI(
                      postList[index].image,
                      postList[index].description,
                      postList[index].date,
                      postList[index].time);
                }),
      ),
      bottomNavigationBar: new BottomAppBar(
        color: Colors.pink,
        child: new Container(
          margin: const EdgeInsets.only(left: 70.0, right: 70.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.local_car_wash),
                iconSize: 50.0,
                color: Colors.white,
                onPressed: _logoutUser,
              ),
              new IconButton(
                icon: new Icon(Icons.add_a_photo),
                iconSize: 40.0,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return new UploadPhotoPage();
                  }));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PostsUI(String image, String description, String date, String time) {
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: new EdgeInsets.all(14.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                new Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            new Image.network(image, fit: BoxFit.cover),
            SizedBox(
              height: 10.0,
            ),
            new Text(
              description,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
