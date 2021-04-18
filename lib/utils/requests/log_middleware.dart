import 'dart:convert';

import '../../resources/resources.dart';
import '../../utils/requests/middleware.dart';
import '../../utils/requests/requests.dart';
import 'middleware.dart';

class LogMiddleware extends Middleware {
  final bool logRequest;
  final bool logResponse;

  LogMiddleware({this.logRequest = true, this.logResponse = true});

  @override
  Future<Request> interceptRequest(Request request) {
    if (logRequest) {
      final url = createUrl(request.url, queryParameters: request.queryParameters);
      App.info('${request.method} $url');
      App.verbose({'headers': request.headers, 'body': request.body});
    }
    return super.interceptRequest(request);
  }

  @override
  Future<Response> interceptResponse(Response response) {
    App.warning('${response.statusCode} (${response.request!.url})');
    App.verbose(json.decode(response.textContent));
    return super.interceptResponse(response);
  }
}
