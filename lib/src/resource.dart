library restful.resource;

import 'dart:async';
import 'dart:html';
import 'package:restful/src/request_helper.dart';
import 'package:restful/src/formats.dart';

class Resource {
  final String url;
  final Format format;
  
  Uri _uri;
  
  Resource({this.url, this.format}) {
    _uri = Uri.parse(url);
  }
  
  Future create([Map<String, Object> params]) {
    params = params != null ? params : {};
    return request('post', url, params);
  }
  
  Future clear() {
    return request('delete', url);
  }
  
  Future delete(Object id) {
    var path = _uri.pathSegments.toList()..add(id.toString());
    var uri = _uri.replace(pathSegments: path, port: _uri.port).toString();
    return request('delete', uri);
  }
  
  Future find(Object id) {
    var path = _uri.pathSegments.toList()..add(id.toString());
    var uri = _uri.replace(pathSegments: path, port: _uri.port).toString();
    return request('get', uri);
  }
  
  Future findAll() {
    return request('get', url);
  }
  
  Future query(Map<String, String> params) {
    var queryParams = new Map.from(_uri.queryParameters)..addAll(params);
    var uri = _uri.replace(queryParameters: queryParams, port: _uri.port).toString();
    return request('get', uri);
  }
  
  Future save(Object id, Map<String, Object> params) {
    var path = _uri.pathSegments.toList()..add(id.toString());
    var uri = _uri.replace(pathSegments: path, port: _uri.port).toString();
    return request('put', uri, params);
  }
  
  Resource nest(Object id, String resource) {
    var path = _uri.pathSegments.toList()..addAll([id.toString(), resource]);
    var uri = _uri.replace(pathSegments: path, port: _uri.port).toString();
    return new Resource(url: uri, format: format);
  }
  
  Future request(String method, String url, [Object data]) {
    var request = new RequestHelper(method, url, format);
    return (data != null ? request.send(data) : request.send()).then(_deserialize);
  }
  
  Object _deserialize(HttpRequest request) {
    return format.deserialize(request.responseText);
  }
}
