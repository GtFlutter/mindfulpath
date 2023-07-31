import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meditation_app/data/model/response/error_res_model.dart';
import 'package:meditation_app/util/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  static const String _noInternetMessage = 'Connection to API server failed due to internet connection';
  final Duration _timeoutIn = const Duration(seconds: 60);
  final http.Response _errorResponse = http.Response(
    jsonEncode(ErrorResponse(status: false, message: _noInternetMessage).toJson()),
    500,
  );

  String? token;
  Map<String, String> _mainHeaders = {};

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConfigs.TOKEN);
    updateHeader(token);
  }

  void updateHeader(String? token) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  Future<http.Response> getData(
    String uri, {
    Map<String, String>? headers,
  }) async {
    try {
      log('====> API Call: $uri \n Header: $_mainHeaders');
      http.Response response = await http
          .get(
            Uri.parse(appBaseUrl + uri),
            headers: headers ?? _mainHeaders,
          )
          .timeout(_timeoutIn);
      return handleResponse(response, uri);
    } catch (_) {
      return _errorResponse;
    }
  }

  Future<http.Response> postData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      log('===> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
      log('===> API Body: $body');
      http.Response response = await http
          .post(
            Uri.parse(appBaseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(_timeoutIn);
      return handleResponse(response, uri);
    } catch (_) {
      return _errorResponse;
    }
  }

  Future<http.Response> postMultipartData(
    String uri,
    Map<String, String> body,
    List<MultipartBody> multipartBody, {
    Map<String, String>? headers,
  }) async {
    try {
      log('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
      log('====> API Body: $body with ${multipartBody.length} files');
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      request.headers.addAll(headers ?? _mainHeaders);
      for (var multipart in multipartBody) {
        request.files.add(
          http.MultipartFile(
            multipart.key,
            multipart.file.readAsBytes().asStream(),
            multipart.file.lengthSync(),
            filename: multipart.file.path.split('/').last,
          ),
        );
      }
      request.fields.addAll(body);
      http.Response response = await http.Response.fromStream(await request.send());
      return handleResponse(response, uri);
    } catch (_) {
      return _errorResponse;
    }
  }

  Future<http.Response> putData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      log('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
      log('====> API Body: $body');
      http.Response response = await http
          .put(
            Uri.parse(appBaseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(_timeoutIn);
      return handleResponse(response, uri);
    } catch (_) {
      return _errorResponse;
    }
  }

  Future<http.Response> deleteData(
    String uri, {
    Map<String, String>? headers,
  }) async {
    try {
      log('====> API Call: $uri\nHeader: ${headers ?? _mainHeaders}');
      http.Response response = await http
          .delete(
            Uri.parse(appBaseUrl + uri),
            headers: headers ?? _mainHeaders,
          )
          .timeout(_timeoutIn);
      return handleResponse(response, uri);
    } catch (_) {
      return _errorResponse;
    }
  }

  http.Response handleResponse(http.Response response, String uri) {
    if (response.statusCode != 200 && response.body.isEmpty) {
      return _errorResponse;
    }
    log('====> API http.Response: [${response.statusCode}] $uri\n${response.body}');
    return response;
  }
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}
