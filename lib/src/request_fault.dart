library restful.request_fault;

import 'dart:html';

class RequestFault {
  final String url;
  final String method;
  final Object data;
  final HttpRequest request;

  RequestFault(this.method, this.url, this.data, this.request);
}