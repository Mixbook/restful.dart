library restful.tests.uri_helper;

import 'package:unittest/unittest.dart';
import 'package:restful/src/uri_helper.dart';

void testUriHelper() {
  group("UriHelper", () {
    test("should parse URI", () {
      var uri = new UriHelper.from("http://www.example.com:8080/my/path#fragment");
      expect(uri.scheme, equals("http"));
      expect(uri.host, equals("www.example.com"));
      expect(uri.port, equals(8080));
      expect(uri.path, equals("/my/path"));
      expect(uri.fragment, equals("fragment"));
    });
    
    test("should append path", () {
      var uri = new UriHelper.from("http://www.example.com/").appendEach(['my', 'path']);
      expect(uri.path, equals("/my/path"));
    });
    
    test("should replace query params", () {
      var uri = new UriHelper.from("http://www.example.com/").replaceParams({'param1': 'value1'});
      expect(uri.queryParameters, equals({'param1': 'value1'}));
    });
  });
}