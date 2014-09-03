library restful.rest_api;

import 'package:restful/src/formats.dart';
import 'package:restful/src/resource.dart';

class RestApi {
  final String apiUri;
  final Format format;
  
  RestApi({this.apiUri, this.format});
  
  Resource resource(String name) {
    var uri = Uri.parse(apiUri);
    var path = uri.pathSegments.toList()..addAll(name.split("/"));
    uri = uri.replace(pathSegments: path);
    return new Resource(url: uri.toString(), format: format);
  }
}