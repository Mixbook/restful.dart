library restful.tests.rest_api;

import 'package:unittest/unittest.dart';
import 'package:restful/src/rest_api.dart';
import 'package:restful/src/formats.dart';

void testRestApi() {
  group("RestApi", () {
    RestApi restApi;
    
    setUp(() {
      restApi = new RestApi(apiUri: "http://www.example.com", format: JSON);
    });
    
    test("should append resource name", () {
      var resource = restApi.resource('users');
      expect(resource.url, equals("http://www.example.com/users"));
    });
  });
}