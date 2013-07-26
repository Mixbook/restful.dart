library restful.rest_api;

import 'package:restful/src/formats.dart';
import 'package:restful/src/rest_resource.dart';
import 'package:restful/src/uri_helper.dart';

class RestApi {
  final String apiUri;
  final Format format;
  
  RestApi({this.apiUri, this.format});
  
  RestResource resource(String name) {
    var uri = new UriHelper.from(apiUri).append(name).toString();
    return new RestResource(url: uri, format: format);
  }
}