library restful.tests.request;

import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';
import 'package:restful/src/request_helper.dart';
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
      var request = new RequestHelper.post('url', JSON_FORMAT);
      request.send().then(expectAsync1((json) {
        httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', JSON_FORMAT.contentType)).verify(happenedOnce);
      }));
    });

    test("should set header's Content-Type on PUT requests", () {
      new RequestHelper.put('url', JSON_FORMAT).send().then(expectAsync1((json) {
        httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', JSON_FORMAT.contentType)).verify(happenedOnce);
      }));
    });

    test("should not set header's Content-Type on GET requests", () {
      new RequestHelper.get('url', JSON_FORMAT).send().then(expectAsync1((json) {
        httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', JSON_FORMAT.contentType)).verify(neverHappened);
      }));
    });
  });
}