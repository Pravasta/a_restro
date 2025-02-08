import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/data/service/remote/restaurant_service.dart';

class SearchRepository {
  final RestaurantService _service;

  SearchRepository({required RestaurantService service}) : _service = service;

  Future<List<Restaurant>> searchRestaurant(String query) async {
    try {
      final execute = await _service.searchRestaurant(query);
      return execute.restaurants ?? [];
    } catch (e) {
      throw e.toString();
    }
  }

  factory SearchRepository.create() {
    return SearchRepository(
      service: RestaurantService.create(),
    );
  }
}
