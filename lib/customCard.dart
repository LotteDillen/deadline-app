import 'package:flutter/material.dart';
import './secondPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CustomCard extends StatelessWidget {
  CustomCard({@required this.title, this.description, this.id});

  final title;
  final description;
  final id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SecondPage(title: title, description: description)));
        },
        child: Card(
            child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Text(title, style: TextStyle(fontSize: 20)),
                    Spacer(),
                    FlatButton(
                      child: Icon(Icons.delete),
                      onPressed: () {
                            deleteData();
                          
                      },
                    ),
                  ],
                ))));
  }

  deleteData(){
    Firestore.instance.collection('tasks').document(this.id).delete();
    print(this.id);
  }
}
