import 'dart:convert';

import 'package:http/http.dart' as http;

enum FetchMethod { get, post, put, patch, delete }

abstract class HttpClient {
  Future<Response> fetch(
    String url, {
    FetchMethod method = FetchMethod.get,
    Map<String, String> headers,
    body,
    Map<String, dynamic> queryParameters,
  });

  void close();
}

class Requests extends HttpClient {
  final Map<String, String> headers;
  final http.Client _client = http.Client();

  Requests({this.headers});

  Future<Map<String, String>> getHeaders(Map<String, String> headers) async {
    if (headers == null || headers.isEmpty) return this.headers;

    final data = Map<String, String>.from(this.headers ?? {});
    data.addAll(headers);
    return data;
  }

  Future<Response> fetch(
    String url, {
    FetchMethod method = FetchMethod.get,
    Map<String, String> headers,
    body,
    Map<String, dynamic> queryParameters,
  }) async {
    assert(url != null && url.length > 0);
    if (body is Map) body = json.encode(body);
    Future<http.Response> response;
    headers = await getHeaders(headers);
    url = createUrl(url, queryParameters: queryParameters);

    if (method == FetchMethod.get)
      response = _client.get(url, headers: headers);
    else if (method == FetchMethod.post)
      response = _client.post(url, headers: headers, body: body);
    else if (method == FetchMethod.patch)
      response = _client.patch(url, headers: headers, body: body);
    else if (method == FetchMethod.put)
      response = _client.put(url, headers: headers, body: body);
    else if (method == FetchMethod.delete) response = _client.delete(url, headers: headers);
    return Response.fromResponse(await response);
  }

  @override
  void close() {
    _client.close();
  }
}

String createUrl(url, {Map<String, dynamic> queryParameters}) {
  var _url = Uri.parse(url);
  Map<String, dynamic> parameters = _url.queryParameters;
  if (queryParameters != null && queryParameters.isNotEmpty) {
    parameters = Map<String, dynamic>.from(parameters ?? {}); // parameters is unmodifiable
    parameters.addAll(queryParameters);
  }
  if (parameters.isEmpty) parameters = null;
  url = Uri(scheme: _url.scheme, host: _url.host, path: _url.path, queryParameters: parameters, port: _url.port);
  return url.toString();
}

class Response extends http.Response {
  Response.fromResponse(http.Response response)
      : super(
          response.body,
          response.statusCode,
          request: response.request,
          headers: response.headers,
          isRedirect: response.isRedirect,
          reasonPhrase: response.reasonPhrase,
          persistentConnection: response.persistentConnection,
        );

  bool get ok => isResponseOk(this);

  bool get clientError => statusCode >= 400 && statusCode < 500;

  String get textContent => utf8.decode(bodyBytes);
}

bool isResponseOk(http.Response response) {
  assert(response != null);
  return response.statusCode >= 200 && response.statusCode < 300;
}
