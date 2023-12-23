import 'package:http/http.dart';
import 'dart:convert';

class AppException implements Exception {
  Response? response;
  String? message;
  int? statusCode;

  AppException([this.response, this.message, this.statusCode]);

  @override
  String toString() {
    return jsonEncode({"message":message,"statusCode":statusCode,});
  }
}

class FetchDataException extends AppException {
  FetchDataException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}

//400
class BadRequestException extends AppException {
  BadRequestException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}

//400
class BadUriException extends AppException {
  BadUriException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}

//401
class UnAuthorizedException extends AppException {
  UnAuthorizedException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}

class InvalidInputException extends AppException {
  InvalidInputException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}

class DuplicateEntryException extends AppException {
  DuplicateEntryException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}

class FileNotSelectedException extends AppException {
  FileNotSelectedException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}

class ImageSizeException extends AppException {
  ImageSizeException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}

class DimensionException extends AppException {
  DimensionException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}

//500
class ServerException extends AppException {
  ServerException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}

//404
class NotFoundException extends AppException {
  NotFoundException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}

//429
class TooManyRequestException extends AppException {
  TooManyRequestException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}

//599
class NetworkConnectTimeoutErrorException extends AppException {
  NetworkConnectTimeoutErrorException({Response? response, String? message, int? statusCode}) : super(response, message, statusCode);
}
