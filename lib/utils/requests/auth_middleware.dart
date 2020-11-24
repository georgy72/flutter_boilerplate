import 'dart:convert';

import '../../resources/resources.dart';
import '../../services/persistent_storage.dart';
import '../../utils/requests/requests.dart';

import 'middleware.dart';

class AuthMiddleware extends Middleware {
  final PersistentStorage storage;
  final Function() onUnauthorized;

  AuthMiddleware(this.storage, {this.onUnauthorized}) : assert(storage != null);

  @override
  Future<Request> interceptRequest(Request request) async {
    final r = await _addAuthorizationHeader(request);
    return super.interceptRequest(r);
  }

  @override
  Future<Response> interceptResponse(Response response) {
    if (response.statusCode == 401)
      _handleUnauthorized(response);
    else if (response.ok && response.request.method == 'POST') {
      final url = response.request.url.toString();
      if (url == Constants.urls.profile || url == Constants.urls.auth) _handleAuthorization(response);
    }
    return super.interceptResponse(response);
  }

  Future<Request> _addAuthorizationHeader(Request request) async {
    if (request.headers?.containsKey('Authorization') == true) return request;
    final token = await storage.getAuthToken();
    if (token == null || token.isEmpty) return request;

    final headers = Map<String, String>.from(request.headers ?? {});
    headers['Authorization'] = createAuthorizationValue(token);
    return request.copyWith(headers: headers);
  }

  Future<void> _handleAuthorization(Response response) async {
    final data = json.decode(response.textContent);
    if (data == null) return;
    final token = data['token'];
    if (token == null) return;
    await storage.saveAuthToken(token);
  }

  Future<void> _handleUnauthorized(Response response) async {
    await storage.clearAuthToken();
    if (onUnauthorized == null) return;
    onUnauthorized();
  }
}

String createAuthorizationValue(String token) {
  return 'Bearer $token';
}
