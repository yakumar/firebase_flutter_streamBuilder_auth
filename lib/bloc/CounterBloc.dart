import 'dart:async';



class CounterBloc implements CounterDispose {

  int counter = 0;

  final StreamController streamController = StreamController<int>();

  get streamSink => streamController.sink;

  get stream => streamController.stream;

  void updateCounter(){
    counter++;

    streamSink.add(counter);

  }
  void decrementCounter(){
    counter--;

    streamController.sink.add(counter);
  }




@override
  dispose() {
    
     streamController.close();
    
    
  }

}


abstract class CounterDispose {
  dispose();
}

final counterBloc = CounterBloc();