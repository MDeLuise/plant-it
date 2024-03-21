import 'dart:convert';

import 'package:http/http.dart' as http;

class AppHttpClient {
  late final http.Client _inner;
  String? backendUrl;
  String? key;
  String? jwt;

  AppHttpClient() {
    _inner = http.Client();
  }

  Future<http.Response> get(String url) async {
    final modifiedUrl = _prependBackendURL(url);
    final request = http.Request('GET', modifiedUrl);
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = '*/*';
    if (key != null) {
      request.headers['Key'] = key!;
    }
    if (jwt != null) {
      request.headers['Authorization'] = "Bearer $jwt";
    }
    return await _inner.send(request).then(http.Response.fromStream);
  }

  Future<http.Response> getNoAuth(String url) async {
    final modifiedUrl = _prependBackendURL(url);
    final request = http.Request('GET', modifiedUrl);
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = '*/*';
    return await _inner.send(request).then(http.Response.fromStream);
  }

  Future<http.Response> post(String url, Map<String, dynamic>? body) async {
    final modifiedUrl = _prependBackendURL(url);
    final request = http.Request('POST', modifiedUrl);
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = '*/*';
    if (key != null) {
      request.headers['Key'] = key!;
    }
    if (jwt != null) {
      request.headers['Authorization'] = "Bearer $jwt";
    }
    request.body = jsonEncode(body);
    return _inner.send(request).then(http.Response.fromStream);
  }

  Future<http.Response> put(String url, Map<String, dynamic>? body) async {
    final modifiedUrl = _prependBackendURL(url);
    final request = http.Request('PUT', modifiedUrl);
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = '*/*';
    if (key != null) {
      request.headers['Key'] = key!;
    }
    if (jwt != null) {
      request.headers['Authorization'] = "Bearer $jwt";
    }
    request.body = jsonEncode(body);
    return await _inner.send(request).then(http.Response.fromStream);
  }

  Future<http.Response> delete(String url) async {
    final modifiedUrl = _prependBackendURL(url);
    final request = http.Request('DELETE', modifiedUrl);
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = '*/*';
    if (key != null) {
      request.headers['Key'] = key!;
    }
    if (jwt != null) {
      request.headers['Authorization'] = "Bearer $jwt";
    }
    return await _inner.send(request).then(http.Response.fromStream);
  }

  void close() {
    _inner.close();
  }

  Uri _prependBackendURL(String url) {
    String urlString = "${backendUrl ?? ""}$url";
    return Uri.parse(urlString);
  }
}
