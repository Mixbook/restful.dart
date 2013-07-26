library restful.request;

import 'dart:async';
import 'dart:html';
import 'package:restful/src/uri_helper.dart';

typedef HttpRequest RequestFactory();

/// Allows for mocking an HTTP request for testing.
RequestFactory httpRequestFactory = () => new HttpRequest();

class Request {
  
  final String url;
  final String method;
  final String contentType;
  
  Request(this.method, this.url, this.contentType);
  
  Request.get(this.url, this.contentType) : method = 'get';
  
  Request.post(this.url, this.contentType) : method = 'post';
  
  Request.put(this.url, this.contentType) : method = 'put';
  
  Request.delete(this.url, this.contentType) : method = 'delete';
  
  Future send([Object data]) {
    var completer = new Completer();
    
    var request = httpRequestFactory();
    request.setRequestHeader('Content-Type', contentType);
    request.open(method, url);
    request.onLoad.listen((event) => completer.complete(request.responseText));
    request.onError.listen((event) => completer.completeError(request.responseText));
    
    if (data != null) {
      request.send(data);
    } else {
      request.send();
    }
    
    return completer.future;
  }
  
}