library restful.resource;

import 'dart:async';
import 'package:restful/src/request.dart';
import 'package:restful/src/formats.dart';
import 'package:restful/src/uri_helper.dart';

class RestResource {
  final String url;
  final Format format;
  
  UriHelper _uri;
  
  RestResource({this.url, this.format}) {
    _uri = new UriHelper.from(url);
  }
  
  Future create(Map<String, Object> params) {
    return new Request.post(url, format.contentType)
        .send(format.serialize(params))
        .then(_deserialize);
  }
  
  Future clear() {
    return new Request.delete(url, format.contentType)
        .send()
        .then(_deserialize);
  }
  
  Future delete(Object id) {
    var uri = _uri.append(id.toString()).toString();
    return new Request.delete(uri, format.contentType)
        .send()
        .then(_deserialize);
  }
  
  Future find(Object id) {
    var uri = _uri.append(id.toString()).toString();
    return new Request.get(uri, format.contentType)
        .send()
        .then(_deserialize);
  }
  
  Future findAll() {
    return new Request.get(url, format.contentType)
        .send()
        .then(_deserialize);
  }
  
  Future query({Object id, Map<String, Object> params}) {
    var uri = _uri.replaceParams(params);
    if (id != null) {
      uri = uri.append(id.toString());
    }
    return new Request.get(uri.toString(), format.contentType)
        .send()
        .then(_deserialize);
  }
  
  Future save(Object id, Map<String, Object> params) {
    var uri = _uri.append(id.toString()).toString();
    return new Request.put(uri, format.contentType)
        .send(params)
        .then(_deserialize);
  }
  
  RestResource subresourceId(Object id, String resource) {
    var uri = _uri.appendEach([id.toString(), resource]);
    return new RestResource(url: uri.toString(), format: format);
  }
  
  Object _deserialize(String response) {
    return format.deserialize(response);
  }
}