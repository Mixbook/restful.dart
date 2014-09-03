library restful.uri_helper;

@deprecated
class UriHelper extends Uri {
  
  factory UriHelper({String scheme, String host, int port, List<String> pathSegments, Map<String, String> queryParams, String fragment}) {
    return null;
  }
  
  factory UriHelper.from(String uri) {
    var parsed = Uri.parse(uri);
    return new UriHelper(
        scheme: parsed.scheme, host: parsed.host, port: parsed.port, 
        pathSegments: parsed.pathSegments, queryParams: parsed.queryParameters, fragment: parsed.fragment
    );
  }
  
  UriHelper append(Object path) {
    return appendEach([path]);
  }
  
  UriHelper appendEach(Iterable paths) {
    paths = paths.map((p) => p.toString());
    return new UriHelper(
        scheme: scheme, host: host, port: port, pathSegments: new List.from(pathSegments)..addAll(paths), 
        queryParams: queryParameters, fragment: fragment
    );
  }
  
  UriHelper replaceParams(Map<String, Object> params) {
    params = new Map.fromIterables(params.keys, params.values.map((v) => v.toString()));
    return new UriHelper(
        scheme: scheme, host: host, port: port, pathSegments: pathSegments, 
        queryParams: params, fragment: fragment
    );
  }
  
}