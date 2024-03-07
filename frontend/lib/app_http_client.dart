import 'dart:convert';

import 'package:http/http.dart' as http;

class AppHttpClient {
  late final http.Client _inner;
  late String _backendUrl;
  String? _key;
  String? _jwt;

  AppHttpClient._internal() {
    _inner = http.Client();
  }

  static final AppHttpClient _instance = AppHttpClient._internal();

  factory AppHttpClient() => _instance;

  void addAuthorizationHeader(String key) {
    _key = key;
  }

  void removeAuthorizationHeader() {
    _key = null;
  }

  void setBackendUrl(String url) {
    _backendUrl = url;
  }

  Future<http.Response> get(String url) async {
    final modifiedUrl = _prependBackendURL(url);
    final request = http.Request('GET', modifiedUrl);
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = '*/*';
    if (_key != null) {
      request.headers['Key'] = _key!;
    }
    if (_jwt != null) {
      request.headers['Authorization'] = "Bearer $_jwt";
    }
    return await _inner.send(request).then(http.Response.fromStream);
  }

  Future<http.Response> post(String url, Map<String, String>? body) async {
    final modifiedUrl = _prependBackendURL(url);
    final request = http.Request('POST', modifiedUrl);
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = '*/*';
    if (_key != null) {
      request.headers['Key'] = _key!;
    }
    if (_jwt != null) {
      request.headers['Authorization'] = "Bearer $_jwt";
    }
    request.body = jsonEncode(body);
    return _inner.send(request).then(http.Response.fromStream);
  }

  Future<http.Response> put(String url, Map<String, String>? body) async {
    final modifiedUrl = _prependBackendURL(url);
    final request = http.Request('PUT', modifiedUrl);
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = '*/*';
    if (_key != null) {
      request.headers['Key'] = _key!;
    }
    if (_jwt != null) {
      request.headers['Authorization'] = "Bearer $_jwt";
    }
    request.body = jsonEncode(body);
    return await _inner.send(request).then(http.Response.fromStream);
  }

  Future<http.Response> delete(String url) async {
    final modifiedUrl = _prependBackendURL(url);
    final request = http.Request('DELETE', modifiedUrl);
    request.headers['Content-type'] = 'application/json';
    request.headers['Accept'] = '*/*';
    if (_key != null) {
      request.headers['Key'] = _key!;
    }
    if (_jwt != null) {
      request.headers['Authorization'] = "Bearer $_jwt";
    }
    return await _inner.send(request).then(http.Response.fromStream);
  }

  void close() {
    _inner.close();
  }

  Uri _prependBackendURL(String url) {
    String urlString = _backendUrl + url;
    return Uri.parse(urlString);
  }

  void addJwt(String jwt) {
    _jwt = jwt;
  }

  void removeJwt() {
    _jwt = null;
  }
}
