library restful.rest_api;

import 'package:restful/src/formats.dart';
import 'package:restful/src/resource.dart';
import 'package:restful/src/uri_helper.dart';

class RestApi {
  final String apiUri;
  final Format format;
  
  RestApi({this.apiUri, this.format});
  
  Resource resource(String name) {
    var uri = new UriHelper.from(apiUri).appendEach(name.split("/")).toString();
    return new Resource(url: uri, format: format);
  }
}