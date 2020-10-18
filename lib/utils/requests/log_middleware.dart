
import 'package:flutter_boilerplate/utils/requests/requests.dart';

import 'middleware.dart';

class LogMiddleware extends Middleware {
  final bool logRequest;
  final bool logResponse;

  LogMiddleware({this.logRequest = true, this.logResponse = true})
      : assert(logRequest != null),
        assert(logResponse != null);

  @override
  Future<Request> interceptRequest(Request request) {
    if (logRequest) print('${request.method} ${request.url}\n${request.headers ?? {}}');
    return super.interceptRequest(request);
  }

  @override
  Future<Response> interceptResponse(Response response) {
    if (logResponse) print('${response.statusCode}: ${response.textContent}');
    return super.interceptResponse(response);
  }
}
