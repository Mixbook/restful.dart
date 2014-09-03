library restful.tests.request_mock;

import 'dart:async';
import 'dart:html';
import 'package:mock/mock.dart';

class HttpRequestMock extends Mock implements HttpRequest {
  
  var responseText = '';
  
  int status = 200;
  
  int delay = 25;
  
  HttpRequestMock() {
    when(callsTo('send')).alwaysCall(([a]) {
      new Timer(new Duration(milliseconds: delay), () {
        onLoadController.add(true);
      });
    });
  }
  
  var onLoadController = new StreamController.broadcast();
  Stream get onLoad => onLoadController.stream;
  
  var onErrorController = new StreamController.broadcast();
  Stream get onError=> onErrorController.stream;
  
}