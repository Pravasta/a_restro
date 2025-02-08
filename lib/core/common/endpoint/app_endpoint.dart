import '../../variables/variable.dart';
import 'uri_helper.dart';

class AppEndpoint {
  final String _baseUrl;

  AppEndpoint({required String baseUrl}) : _baseUrl = baseUrl;

  Uri getListRestaurant() {
    return UriHelper.createUrl(
      host: _baseUrl,
      path: 'list',
    );
  }

  Uri searchRestaurant(String query) {
    return UriHelper.createUrl(
      host: _baseUrl,
      path: 'search',
      queryParameters: {'q': query},
    );
  }

  Uri getDetailRestaurant(String restoId) {
    return UriHelper.createUrl(
      host: _baseUrl,
      path: 'detail/$restoId',
    );
  }

  Uri addReview() {
    return UriHelper.createUrl(
      host: _baseUrl,
      path: 'review',
    );
  }

  factory AppEndpoint.create() {
    return AppEndpoint(baseUrl: Variable.baseUrl);
  }
}
