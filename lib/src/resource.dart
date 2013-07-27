library restful.resource;

import 'dart:async';
import 'package:restful/src/request.dart';
import 'package:restful/src/formats.dart';
import 'package:restful/src/uri_helper.dart';

class Resource {
  final String url;
  final Format format;
  
  UriHelper _uri;
  
  Resource({this.url, this.format}) {
    _uri = new UriHelper.from(url);
  }
  
  Future create([Map<String, Object> params]) {
    params = params != null ? params : {};
    return request('post', url, params);
  }
  
  Future clear() {
    return request('delete', url);
  }
  
  Future delete(Object id) {
    var uri = _uri.append(id.toString()).toString();
    return request('delete', uri);
  }
  
  Future find(Object id) {
    var uri = _uri.append(id.toString()).toString();
    return request('get', uri);
  }
  
  Future findAll() {
    return request('get', url);
  }
  
  Future query(Map<String, Object> params) {
    var uri = _uri.replaceParams(params).toString();
    return request('get', uri);
  }
  
  Future save(Object id, Map<String, Object> params) {
    var uri = _uri.append(id).toString();
    return request('put', uri, params);
  }
  
  Resource nest(Object id, String resource) {
    var uri = _uri.appendEach([id, resource]).toString();
    return new Resource(url: uri, format: format);
  }
  
  Future request(String method, String url, [Object data]) {
    var request = new Request(method, url, format);
    return (data != null ? request.send(data) : request.send()).then(_deserialize);
  }
  
  Object _deserialize(String response) {
    return format.deserialize(response);
  }
}