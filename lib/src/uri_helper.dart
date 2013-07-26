library restful.uri_helper;

class UriHelper extends Uri {
  
  UriHelper({String scheme, String host, int port, List<String> pathSegments, Map<String, String> queryParams, String fragment}) : 
    super(scheme: scheme, host: host, port: port, pathSegments: pathSegments, queryParameters: queryParams, fragment: fragment);
  
  factory UriHelper.from(String uri) {
    var parsed = Uri.parse(uri);
    return new UriHelper(
        scheme: parsed.scheme, host: parsed.host, port: parsed.port, 
        pathSegments: parsed.pathSegments, queryParams: parsed.queryParameters, fragment: parsed.fragment
    );
  }
  
  UriHelper append(String path) {
    return new UriHelper(
        scheme: scheme, host: host, port: port, pathSegments: new List.from(pathSegments)..add(path), 
        queryParams: queryParameters, fragment: fragment
    );
  }
  
  UriHelper appendEach(Iterable<String> paths) {
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