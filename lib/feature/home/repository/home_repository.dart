import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/data/service/remote/restaurant_service.dart';

class HomeRepository {
  final RestaurantService _restaurantService;

  HomeRepository({
    required RestaurantService restaurantService,
  }) : _restaurantService = restaurantService;

  Future<List<Restaurant>> getRestaurantList() async {
    try {
      final execute = await _restaurantService.getRestaurantList();
      return execute.restaurants ?? [];
    } catch (e) {
      throw e.toString();
    }
  }

  factory HomeRepository.create() {
    return HomeRepository(
      restaurantService: RestaurantService.create(),
    );
  }
}
