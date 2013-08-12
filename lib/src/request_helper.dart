library restful.request_helper;

import 'dart:async';
import 'dart:html';
import 'package:restful/src/formats.dart';
import 'package:logging/logging.dart';

typedef HttpRequest RequestFactory();

/// Allows for mocking an HTTP request for testing.
RequestFactory httpRequestFactory = () => new HttpRequest();

class RequestHelper {
  
  final String url;
  final String method;
  final Format format;
  
  RequestHelper(this.method, this.url, this.format);
  
  RequestHelper.get(this.url, this.format) : method = 'get';
  
  RequestHelper.post(this.url, this.format) : method = 'post';
  
  RequestHelper.put(this.url, this.format) : method = 'put';
  
  RequestHelper.delete(this.url, this.format) : method = 'delete';
  
  Future<HttpRequest> send([Object data]) {
    var completer = new Completer();
    
    var request = httpRequestFactory();
    request.open(method, url);
    
    if (method != 'get') {
      request.setRequestHeader('Content-Type', format.contentType);
    }
    
    request.onLoad.listen((event) {
      if ((request.status >= 200 && request.status < 300) || request.status == 0) {
        completer.complete(request);
      } else {
        _logger.warning("Unhandled HTTP status code ${request.status} for $url");
      }
    });
    request.onError.listen((event) => completer.completeError(request));
    
    if (data != null) {
      request.send(format.serialize(data));
    } else {
      request.send();
    }
    
    return completer.future;
  }
  
}

Logger _logger = new Logger("restful.request_helper");