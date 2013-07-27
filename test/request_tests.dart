library restful.tests.request;

import 'dart:async';
import 'dart:html';
import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';
import 'package:restful/src/request.dart';
import 'package:restful/src/formats.dart';
import 'request_mock.dart';

void testRequests() {
  group("Request", () {
    HttpRequestMock httpRequest;
    
    setUp(() {
      httpRequest = new HttpRequestMock();
      httpRequestFactory = () => httpRequest;
    });
    
    test("should set header's Content-Type on POST requests", () {
      var request = new Request.post('url', JSON);
      request.send().then(expectAsync1((json) {
        httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', JSON.contentType)).verify(happenedOnce);
      }));
    });
    
    test("should set header's Content-Type on PUT requests", () {
      new Request.put('url', JSON).send().then(expectAsync1((json) {
        httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', JSON.contentType)).verify(happenedOnce);
      }));
    });
    
    test("should not set header's Content-Type on GET requests", () {
      new Request.get('url', JSON).send().then(expectAsync1((json) {
        httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', JSON.contentType)).verify(neverHappened);
      }));
    });
  });
}