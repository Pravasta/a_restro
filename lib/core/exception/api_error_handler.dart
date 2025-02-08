import 'api_exception.dart';

class ApiErrorHandler {
  static Exception handleError({
    required int statusCode,
    required String error,
  }) {
    switch (statusCode) {
      case 400:
        return BadRequestException(message: error);
      case 401:
        return UnauthorizedException(message: error);
      case 402:
        return PaymentRequiredException(message: error);
      case 403:
        return ForbiddenException(message: error);
      case 404:
        return NotFoundException(message: error);
      case 405:
        return MethodNotAllowedException(message: error);
      case 406:
        return NotAcceptableException(message: error);
      case 408:
        return RequestTimeoutException(message: error);
      case 500:
        return InternalServerErrorException(message: error);
      case 501:
        return NotImplementedException(message: error);
      case 502:
        return BadGatewayException(message: error);
      default:
        return ApiException(message: error);
    }
  }
}
