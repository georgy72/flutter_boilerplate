import '../../utils/requests/requests.dart';

export '../../utils/requests/requests.dart';

class MiddlewareClient extends HttpClient {
  final HttpClient _client;
  final List<Middleware> _middlewares;

  MiddlewareClient._(this._client, this._middlewares);

  factory MiddlewareClient.build(HttpClient client, List<Middleware> middlewares) {
    var _client = client;
    var _middlewares = middlewares;
    if (client is MiddlewareClient) {
      _client = client._client;
      _middlewares = List.from(middlewares);
      _middlewares.addAll(client._middlewares);
    }
    return MiddlewareClient._(_client, _middlewares);
  }

  @override
  Future<Response> fetch(
    String url, {
    FetchMethod method = FetchMethod.get,
    Map<String, String>? headers,
    body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final request = await _requestPipeline(Request(url, method, headers ?? {}, body, queryParameters));
    final response = _responsePipeline(await _fetch(request));
    return response;
  }

  Future<Response> _fetch(Request r) {
    return _client.fetch(r.url, method: r.method, headers: r.headers, body: r.body, queryParameters: r.queryParameters);
  }

  Future<Request> _requestPipeline(Request request) async {
    var res = request;
    for (var i = 0; i < _middlewares.length; i++) {
      res = await _middlewares[i].interceptRequest(res);
    }
    return res;
  }

  Future<Response> _responsePipeline(Response response) async {
    var res = response;
    for (var i = _middlewares.length - 1; i >= 0; i--) {
      res = await _middlewares[i].interceptResponse(res);
    }
    return res;
  }

  @override
  void close() {
    _client.close();
  }
}

abstract class Middleware {
  Future<Request> interceptRequest(Request request) async {
    return request;
  }

  Future<Response> interceptResponse(Response response) async {
    return response;
  }
}

class Request {
  final String url;
  final FetchMethod method;
  final Map<String, String>? headers;
  final dynamic body;
  final Map<String, dynamic>? queryParameters;

  Request(this.url, this.method, this.headers, this.body, this.queryParameters);

  Request copyWith({
    String? url,
    FetchMethod? method,
    Map<String, String>? headers,
    dynamic? body,
    Map<String, dynamic>? queryParameters,
  }) {
    return Request(
      url ?? this.url,
      method ?? this.method,
      headers ?? this.headers,
      body ?? this.body,
      queryParameters ?? this.queryParameters,
    );
  }
}
