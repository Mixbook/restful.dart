library restful.request_helper;

import 'dart:async';
import 'dart:html';
import 'package:logging/logging.dart';
import 'package:restful/src/formats.dart';
import 'package:restful/src/request_fault.dart';

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
    var serializedData = data != null ? format.serialize(data) : null;
    request.open(method, url);

    if (method != 'get') {
      request.setRequestHeader('Content-Type', format.contentType);
    }
    request.setRequestHeader('Accept', format.contentType);
    request.onLoad.listen((event) {
      if ((request.status >= 200 && request.status < 300) || request.status == 0) {
        completer.complete(request);
      } else {
        completer.completeError(new RequestFault(method, url, serializedData, request));
      }
    });

    request.onError.listen((event) {
      completer.completeError(new RequestFault(method, url, serializedData, request));
    });

    if (serializedData != null) {
      request.send(serializedData);
    } else {
      request.send();
    }

    return completer.future.catchError((RequestFault fault) {
      _logRequestFailure(fault);
      throw fault;
    });
  }

}

void _logRequestFailure(RequestFault fault) {
  _logger.warning(
      '''Failed to load '${fault.method.toUpperCase()} ${fault.url}'

Status Code: ${fault.request.status}

Request Payload:
${fault.data}

Response:
${fault.request.responseText}
'''
  );
}

Logger _logger = new Logger("restful.request_helper");
