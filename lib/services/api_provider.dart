import 'dart:convert';
import 'dart:io';

import '../models/api.dart';
import '../utils/requests/requests.dart';

import 'auth_api_provider.dart';

typedef ModelFactoryMethod<T> = T Function(dynamic value);

class ApiProvider {
  final HttpClient client;
  final AuthApiProvider auth;

  ApiProvider({HttpClient client})
      : this.client = client ?? createDefaultClient(),
        auth = AuthApiProvider(client);

  static HttpClient createDefaultClient() {
    return Requests(headers: {'Content-Type': 'application/json', 'Accept': 'application/json'});
  }

  static ApiErrors getErrors(Response response) {
    if (response == null) return null;
    final errors = json.decode(response.textContent);
    if (errors == null) return null;
    if (errors is Map<String, dynamic> && errors.isNotEmpty) return ApiErrors(errors);
    return null;
  }
}

extension HttpClientExtension on HttpClient {
  Future<T> fetchItem<T>(
    String url,
    ModelFactoryMethod<T> factoryMethod, {
    T defaultValue,
    FetchMethod method = FetchMethod.get,
    Map<String, String> headers,
    body,
    Map<String, dynamic> queryParameters,
  }) async {
    final response = await fetch(
      url,
      method: method,
      headers: headers,
      body: body,
      queryParameters: queryParameters,
    );
    if (!response.ok) return defaultValue;
    return factoryMethod(json.decode(response.textContent));
  }

  Future<ApiResponse<T>> fetchItemWithErrors<T>(
    String url,
    ModelFactoryMethod<T> factoryMethod, {
    T defaultValue,
    FetchMethod method = FetchMethod.get,
    Map<String, String> headers,
    body,
    Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await fetch(
        url,
        method: method,
        headers: headers,
        body: body,
        queryParameters: queryParameters,
      );
      if (!response.ok) return ApiResponse(defaultValue, ApiProvider.getErrors(response), status: response.statusCode);
      return ApiResponse(factoryMethod(json.decode(response.textContent)), null, status: response.statusCode);
    } on SocketException catch (e) {
      return ApiResponse(defaultValue, ApiErrors({'detail': e.osError.message}));
    } catch (e) {
      return ApiResponse(defaultValue, ApiErrors({'detail': e.toString()}));
    }
  }

  Future<List<T>> fetchList<T>(
    String url,
    ModelFactoryMethod<T> factoryMethod, {
    List<T> defaultValue,
    FetchMethod method = FetchMethod.get,
    Map<String, String> headers,
    body,
    Map<String, dynamic> queryParameters,
  }) async {
    final response = await fetch(
      url,
      method: method,
      headers: headers,
      body: body,
      queryParameters: queryParameters,
    );
    if (!response.ok) return defaultValue;
    final jsonArray = json.decode(response.textContent);
    return List<T>.from(jsonArray.map(factoryMethod));
  }
}
