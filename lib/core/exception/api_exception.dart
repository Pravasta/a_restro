class ApiException implements Exception {
  final String? message;

  ApiException({this.message});

  @override
  String toString() {
    return message ?? 'unknown error';
  }
}

class BadRequestException extends ApiException {
  BadRequestException({String message = ''}) : super(message: message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({String message = ''}) : super(message: message);
}

class PaymentRequiredException extends ApiException {
  PaymentRequiredException({String message = ''}) : super(message: message);
}

class ForbiddenException extends ApiException {
  ForbiddenException({String message = ''}) : super(message: message);
}

class NotFoundException extends ApiException {
  NotFoundException({String message = ''}) : super(message: message);
}

class RequestTimeoutException extends ApiException {
  RequestTimeoutException({String message = ''}) : super(message: message);
}

class MethodNotAllowedException extends ApiException {
  MethodNotAllowedException({String message = ''}) : super(message: message);
}

class NotAcceptableException extends ApiException {
  NotAcceptableException({String message = ''}) : super(message: message);
}

class InternalServerErrorException extends ApiException {
  InternalServerErrorException({String message = ''}) : super(message: message);
}

class NotImplementedException extends ApiException {
  NotImplementedException({String message = ''}) : super(message: message);
}

class BadGatewayException extends ApiException {
  BadGatewayException({String message = ''}) : super(message: message);
}

class LoginFailedException extends ApiException {
  LoginFailedException({String message = 'LOGIN-FAILED'})
      : super(message: message);
}

class UnauthenticatedException extends ApiException {
  UnauthenticatedException({String message = 'UNAUTHENTICATED'})
      : super(message: message);
}

class AuthenticatedFailedException extends ApiException {
  AuthenticatedFailedException({String message = 'AUTHENTICATED-FAILED'})
      : super(message: message);
}

class UnknownException extends ApiException {
  UnknownException({String message = 'UNKNOWN-ERROR'})
      : super(message: message);
}
