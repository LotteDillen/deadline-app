import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './customCard.dart';
import 'secondPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Deadline' 'app',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: MyHomePage(title: 'Deadline app'),
        routes: <String, WidgetBuilder>{
          '/a': (BuildContext context) => SecondPage(title: 'Page A'),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  var documentIdee;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController taskTitleInputController;
  TextEditingController taskDescripInputController;
  TextEditingController nameInputController;

  String name = 'hahaha';

  @override
  initState() {
    taskTitleInputController = new TextEditingController();
    taskDescripInputController = new TextEditingController();
    nameInputController = new TextEditingController();
    super.initState();
    naamdata();
  }

  void naamdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');
    if (nameInputController != null) {
      setState(() {
        name = userId;
      });
      return;
    }
  }

  Future<Null> addname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', nameInputController.text);
    setState(() {
      name = nameInputController.text;
    });
    nameInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welkom, ''$name', style: TextStyle(fontSize: 30)),
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('tasks').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return new CustomCard(
                          title: document['title'],
                          description: document['description'],
                          id: document['id'],
                        );
                      }).toList(),
                    );
                }
              },
            )),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.person),
                iconSize: 40,
                padding: EdgeInsets.fromLTRB(50, 15, 0, 0),
                onPressed: _showProfiel),
            IconButton(
                icon: Icon(Icons.add),
                iconSize: 40,
                padding: EdgeInsets.fromLTRB(0, 15, 50, 0),
                onPressed: _showDialog),
          ],
        ),
      ),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(20.0),
        content: Column(
          children: <Widget>[
            Text("Please fill all fields to create a new task"),
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Task Title*'),
                controller: taskTitleInputController,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Due date*',
                ),
                controller: taskDescripInputController,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                taskTitleInputController.clear();
                taskDescripInputController.clear();
                Navigator.pop(context);
              }),
          FlatButton(
              child: Text('Add'),
              onPressed: () {
                var documentIdeeLol;
                if (taskDescripInputController.text.isNotEmpty &&
                    taskTitleInputController.text.isNotEmpty) {
                  Firestore.instance
                      .collection('tasks')
                      .add({
                        "title": taskTitleInputController.text,
                        "description": taskDescripInputController.text
                      })
                      .then((result) => {
                            Navigator.pop(context),
                            taskTitleInputController.clear(),
                            taskDescripInputController.clear(),
                            documentIdeeLol = result.documentID,
                            print(result.documentID),
                          })
                      .then((result) => {
                            Firestore.instance
                                .collection('tasks')
                                .document(documentIdeeLol)
                                .updateData({"id": documentIdeeLol})
                          })
                      .catchError((err) => print(err));
                }
              })
        ],
      ),
    );
  }

  _showProfiel() async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(20.0),
        content: Column(
          children: <Widget>[
            Text("Please fill in your name"),
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'Name*'),
                controller: nameInputController,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          FlatButton(child: Text('Change'), onPressed: () {
            addname();
            Navigator.pop(context);
          })
        ],
      ),
    );
  }
}
