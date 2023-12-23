import 'dart:developer';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'dart:io';

import 'package:marathon/utils/exceptions/app_exception.dart';

class HttpStatusCodeInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {

    data.headers = {
      "content-type": "application/json",
      "accept": "application/json",
    };
    return data;
  }

  void checkResponseStatusCode({required Response data}) {
    int statusCode = data.statusCode;
    switch (statusCode) {
      /// if response status code is not 200 || 201 then throwing exception
      case HttpStatus.ok:
      case HttpStatus.created:
        break;
      case HttpStatus.unauthorized:
        throw UnAuthorizedException(response: data, message: "404", statusCode: statusCode);
      case HttpStatus.notFound:
        throw NotFoundException(response: data, message: "404", statusCode: statusCode);
      case HttpStatus.badRequest:
        throw BadRequestException(response: data, message: "400", statusCode: statusCode);
      case HttpStatus.tooManyRequests:
        throw TooManyRequestException(response: data, message: "429", statusCode: statusCode);
      case HttpStatus.internalServerError:
        throw ServerException(response: data, message: "500", statusCode: statusCode);
      case HttpStatus.networkConnectTimeoutError:
        throw NetworkConnectTimeoutErrorException(response: data, message: "599", statusCode: statusCode);
      default:
        throw AppException(data, "Something Went Wrong", 500);
    }
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    checkResponseStatusCode(data: data.toHttpResponse());

    return data;
  }
}
