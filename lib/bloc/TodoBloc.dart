import 'dart:async';


class TodoBloc implements Tobloc {
  @override
  dispose() {
    // TODO: implement dispose
    streamController.close();
  }

  List<String> todoList = [];

  final streamController = StreamController<List<String>>();

  get streamSink => streamController.sink;

  get stream => streamController.stream;

  void addTodo(String todo){


    todoList.add(todo);

    streamSink.add(todoList);


  }






}

abstract class Tobloc {

  void dispose();

}
final todoBloc = TodoBloc();