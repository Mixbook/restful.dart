library restful.tests;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';

import 'uri_helper_tests.dart';
import 'rest_api_tests.dart';
import 'resource_tests.dart';
import 'request_helper_tests.dart';

void main() {
  useHtmlEnhancedConfiguration();
  
  testUriHelper();
  testRestApi();
  testResource();
  testRequests();
}