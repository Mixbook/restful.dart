library restful.tests.resource;

import 'dart:async';
import 'dart:convert';
import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';
import 'package:restful/src/resource.dart';
import 'package:restful/src/formats.dart';
import 'package:restful/src/request_helper.dart';
import 'request_mock.dart';

void testResource() {
  group("RestResource", () {

    Resource resource;
    HttpRequestMock request;

    setUp(() {
      resource = new Resource(url: "http://www.example.com/users", format: JSON_FORMAT);

      request = new HttpRequestMock();
      httpRequestFactory = () => request;
    });

    test("should append subresource names", () {
      var subresource = resource.nest(1, 'posts');
      var expected = Uri.parse("http://www.example.com").replace(path: "users/1/posts").toString();
      expect(subresource.url, equals(expected));
    });

    group("clear", () {
      test("should send 'DELETE' to correct URL", () {
        return resource.clear().then((json) {
          request.getLogs(callsTo('open', 'delete', 'http://www.example.com/users')).verify(happenedOnce);
        });
      });

      test("should deserialize response", () {
        var response = true;
        request.responseText = JSON.encode(response);

        return resource.clear().then((json) {
          expect(json, equals(response));
        });
      });
    });

    group("create", () {
      test("should send 'POST' to correct URL", () {
        return resource.create({'name': 'Jimmy Page'}).then((json) {
          request.getLogs(callsTo('open', 'post', 'http://www.example.com/users')).verify(happenedOnce);
        });
      });

      test("should serialize request data", () {
        var data = {'name': 'Jimmy Page'};
        return resource.create(data).then((json) {
          request.getLogs(callsTo('send', resource.format.serialize(data))).verify(happenedOnce);
        });
      });

      test("should deserialize response", () {
        var response = {'id': 1, 'name': 'Jimmy Page'};
        request.responseText = JSON.encode(response);

        return resource.create(new Map.from(response)..remove('id')).then((json) {
          expect(json, equals(response));
        });
      });
    });

    group("delete", () {
      test("should send 'DELETE' to correct URL", () {
        return resource.delete(1).then((json) {
          var expectedUri = Uri.parse("http://www.example.com").replace(path: "users/1").toString();
          request.getLogs(callsTo('open', 'delete', expectedUri)).verify(happenedOnce);
        });
      });

      test("should deserialize response", () {
        var response = {'success': true};
        request.responseText = JSON.encode(response);

        return resource.delete(1).then((json) {
          expect(json, equals(response));
        });
      });
    });

    group("find", () {
      test("should send 'GET' to correct URL", () {
        return resource.find(1).then((json) {
          var expectedUri = Uri.parse("http://www.example.com").replace(path: "users/1").toString();
          request.getLogs(callsTo('open', 'get', expectedUri)).verify(happenedOnce);
        });
      });

      test("should deserialize response", () {
        var response = {'id': 1, 'name': 'Jimmy Page'};
        request.responseText = JSON.encode(response);

        return resource.find(1).then((json) {
          expect(json, equals(response));
        });
      });
    });

    group("findAll", () {
      test("should send 'GET' to correct URL", () {
        return resource.findAll().then((json) {
          request.getLogs(callsTo('open', 'get', 'http://www.example.com/users')).verify(happenedOnce);
        });
      });

      test("should deserialize response", () {
        var response = [{'id': 1, 'name': 'Jimmy Page'}, {'id': 2, 'name': 'David Gilmour'}];
        request.responseText = JSON.encode(response);

        return resource.find(1).then((json) {
          expect(json, equals(response));
        });
      });
    });

    group("query", () {
      test("should send 'GET' to correct URL", () {
        return resource.query({'param1': 'value1'}).then((json) {
          var expectedUri = Uri.parse("http://www.example.com")
              .replace(path: "users", queryParameters: {"param1": "value1"})
              .toString();

          request.getLogs(callsTo('open', 'get', expectedUri)).verify(happenedOnce);
        });
      });

      test("should deserialize response", () {
        var response = [{'id': 1, 'name': 'Jimmy Page'}, {'id': 2, 'name': 'David Gilmour'}];
        request.responseText = JSON.encode(response);

        return resource.query({'param1': 'value1'}).then((json) {
          expect(json, equals(response));
        });
      });
    });

    group("save", () {
      test("should send 'PUT' to correct URL", () {
        return resource.save(1, {'name': 'David Gilmour'}).then((json) {
          var expectedUri = Uri.parse("http://www.example.com").replace(path: "users/1").toString();
          request.getLogs(callsTo('open', 'put', expectedUri)).verify(happenedOnce);
        });
      });

      test("should serialize request data", () {
        var data = {'name': 'David Gilmour'};
        return resource.save(1, data).then((json) {
          request.getLogs(callsTo('send', resource.format.serialize(data))).verify(happenedOnce);
        });
      });

      test("should deserialize response", () {
        var response = {'id': 1, 'name': 'Jimmy Page'};
        request.responseText = JSON.encode(response);

        return resource.save(1, {'param1': 'value1'}).then((json) {
          expect(json, equals(response));
        });
      });
    });

  });
}