import 'package:another_login/bloc/CounterBloc.dart';
import 'package:another_login/bloc/TodoBloc.dart';
import 'package:another_login/model/board.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Board> boardMessages = [];
  Board board;

  final GlobalKey formKey = GlobalKey<FormState>();
  DataSnapshot snapshoty;
  DatabaseReference databaseRef;

  @override
  void initState() {
    super.initState();
    board = Board(body: "", subject: "");

    databaseRef = firebaseDatabase.reference().child("community_board");
  }

  void _onAdded(Event event) {
    print(event.snapshot);

    setState(() {
      boardMessages.add(Board.fromSnapshot(event.snapshot));
    });
    print(boardMessages);
  }

  void _onSubmit() {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      form.reset();

      firebaseDatabase
          .reference()
          .child("community_board")
          .push()
          .set(board.toJson());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: ListTile(
                      leading: Icon(Icons.subject),
                      title: TextFormField(
                        initialValue: "",
                        onSaved: (str) => board.subject = str,
                        validator: (val) => val == "" ? val : null,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: ListTile(
                      leading: Icon(Icons.label),
                      title: TextFormField(
                        initialValue: "",
                        onSaved: (str) => board.body = str,
                        validator: (val) => val == "" ? val : null,
                      ),
                    ),
                  ),
                  FlatButton(
                    color: Colors.blue,
                    child: Text('Submit'),
                    onPressed: _onSubmit,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: StreamBuilder(
                

                stream: databaseRef.onValue,
                builder: (BuildContext context, AsyncSnapshot<Event> event) {
                
                  // Map<dynamic, dynamic<String, dynamic>>


                if(event.hasData){

                  Map<dynamic, dynamic> mapData = event.data.snapshot.value;

                  mapData.forEach((id, val){

                    board = Board(key: id, body: val['body'], subject: val['subject']);
                    boardMessages.add(board);

                  });

                  return ListView.builder(
                    itemCount: boardMessages.length,
                    itemBuilder: (BuildContext context, int index){
                      return Card(
                        child: ListTile(
                          title: Text('${boardMessages[index].subject}'),
                          subtitle: Text('${boardMessages[0].body}'),
                        ),
                      );
                    },
                  );

                } else {
                  return  Text('New data');


                }

                }
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



// if (event.data != null) {
//                     if(event.data.snapshot != null){
//                     final Map<dynamic, dynamic> mapData =
//                         event.data.snapshot.value;

//                     mapData.forEach((id, val) {
//                       board = Board(
//                           key: id, body: val['body'], subject: val['subject']);

//                       boardMessages.add(board);

//                       print(boardMessages[0].key);

//                       if (boardMessages.length > 0) {
//                         return ListView.builder(
//                           itemCount: boardMessages.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Card(
//                               child: ListTile(
//                                 title: Text('${boardMessages[index].body}'),
//                               ),
//                             );
//                           },
//                         );
//                       } else {
//                         return Container(child: Text('Nothing here'),);
//                       }
//                     });
//                   } else {
//                     return Container(child: Text('Nothing here'),);
//                   }
//                   } else {
//                     return Container(child: Text('Nothing here'),);
//                   }
//                 },