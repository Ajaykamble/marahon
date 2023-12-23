// ignore_for_file: overridden_fields

import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:marathon/config/environment.dart';
import 'package:marathon/utils/app_endpoints.dart';
import 'package:marathon/utils/exceptions/app_exception.dart';

class RetryPolicyInterceptor extends RetryPolicy {
  @override
  int maxRetryAttempts = 5;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    String url = response.request!.url;

    String status = AppEndpoints.unauthorizedRequests.firstWhere(
      (String element) {
        bool containsUrl = (url == "${Environment.baseUrl}$element");

        return containsUrl;
      },
      orElse: () => "",
    );
    if (response.statusCode == HttpStatus.unauthorized) {
      if (status.isEmpty) {
        //await AuthService.refreshToken();
        //TODO: call to refresh token endpoint
        return true;
      } else {
        throw UnAuthorizedException(response: response.toHttpResponse(), message: "401", statusCode: response.statusCode);
      }
    }

    return false;
  }
}
