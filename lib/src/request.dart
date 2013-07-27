library restful.request;

import 'dart:async';
import 'dart:html';
import 'package:restful/src/formats.dart';
import 'package:restful/src/uri_helper.dart';

typedef HttpRequest RequestFactory();

/// Allows for mocking an HTTP request for testing.
RequestFactory httpRequestFactory = () => new HttpRequest();

class Request {
  
  final String url;
  final String method;
  final Format format;
  
  Request(this.method, this.url, this.format);
  
  Request.get(this.url, this.format) : method = 'get';
  
  Request.post(this.url, this.format) : method = 'post';
  
  Request.put(this.url, this.format) : method = 'put';
  
  Request.delete(this.url, this.format) : method = 'delete';
  
  Future send([Object data]) {
    var completer = new Completer();
    
    var request = httpRequestFactory();
    request.open(method, url);
    
    if (method != 'get') {
      request.setRequestHeader('Content-Type', format.contentType);
    }
    
    request.onLoad.listen((event) {
      if ((request.status >= 200 && request.status < 300) || request.status == 0 || request.status == 304) {
        completer.complete(request.responseText);
      } else {
        completer.completeError(request.responseText);
      }
    });
    request.onError.listen((event) => completer.completeError(request.responseText));
    
    if (data != null) {
      request.send(format.serialize(data));
    } else {
      request.send();
    }
    
    return completer.future;
  }
  
}