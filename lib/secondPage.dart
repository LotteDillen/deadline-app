import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  SecondPage({@required this.title, this.description});

  final title;
  final description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title, style: TextStyle(fontSize: 40)),
                Container(
                  child: Column(children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.alarm),
                      iconSize: 100,
                    ),
                    Text(description, style: TextStyle(color: Colors.red, fontSize: 20)),
                  ]),
                ),
                RaisedButton(
                    child: Text('Back To HomeScreen'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () => Navigator.pop(context)),
              ]),
        ));
  }
}
