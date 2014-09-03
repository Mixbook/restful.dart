library restful.tests.request;

import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';
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
      return request.send().then((json) {
        httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', JSON_FORMAT.contentType)).verify(happenedOnce);
      });
    });

    test("should set header's Content-Type on PUT requests", () {
      return new RequestHelper.put('url', JSON_FORMAT).send().then((json) {
        httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', JSON_FORMAT.contentType)).verify(happenedOnce);
      });
    });

    test("should not set header's Content-Type on GET requests", () {
      return new RequestHelper.get('url', JSON_FORMAT).send().then((json) {
        httpRequest.getLogs(callsTo('setRequestHeader', 'Content-Type', JSON_FORMAT.contentType)).verify(neverHappened);
      });
    });

    group("with an error status", () {
      setUp(() {
        httpRequest.status = 500;
      });

      test("should fail with completeError", () {
        expect(new RequestHelper.get('url', JSON_FORMAT).send(), throws);
      });
    });
  });
}