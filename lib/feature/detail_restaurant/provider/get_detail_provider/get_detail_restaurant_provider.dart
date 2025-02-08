import 'package:a_restro/feature/detail_restaurant/provider/get_detail_provider/get_detail_restaurant_state.dart';
import 'package:a_restro/feature/detail_restaurant/repository/detail_restaurant_repository.dart';
import 'package:flutter/material.dart';

class GetDetailRestaurantProvider extends ChangeNotifier {
  final DetailRestaurantRepository _detailRestaurantRepository;

  GetDetailRestaurantProvider({
    required DetailRestaurantRepository detailRestaurantRepository,
  }) : _detailRestaurantRepository = detailRestaurantRepository;

  GetDetailRestaurantState _resultState = GetDetailRestaurantIntialState();

  GetDetailRestaurantState get resultState => _resultState;

  Future<void> getDetailRestaurant(String restoId) async {
    try {
      _resultState = GetDetailRestaurantLoadingState();
      notifyListeners();

      final result =
          await _detailRestaurantRepository.getDetailRestaurant(restoId);

      _resultState = GetDetailRestaurantLoadedState(data: result);
      notifyListeners();
    } catch (e) {
      _resultState = GetDetailRestaurantErrorState(error: e.toString());
      notifyListeners();
    }
  }
}
