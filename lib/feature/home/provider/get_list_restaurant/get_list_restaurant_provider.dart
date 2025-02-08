import 'package:flutter/material.dart';

import 'package:a_restro/feature/home/provider/get_list_restaurant/get_list_restaurant_state.dart';
import 'package:a_restro/feature/home/repository/home_repository.dart';

class GetListRestaurantProvider extends ChangeNotifier {
  final HomeRepository _repository;

  GetListRestaurantProvider({
    required HomeRepository repository,
  }) : _repository = repository;

  GetListRestaurantState _resultState = GetListRestaurantInitialState();

  GetListRestaurantState get resultState => _resultState;

  Future<void> getAllRestaurant() async {
    try {
      _resultState = GetListRestaurantLoadingState();
      notifyListeners();

      final result = await _repository.getRestaurantList();

      if (result.isNotEmpty) {
        _resultState = GetListRestaurantLoadedState(result);
        notifyListeners();
      } else {
        _resultState = GetListRestaurantLoadedState([]);
        notifyListeners();
      }
    } catch (e) {
      _resultState = GetListRestaurantErrorState(e.toString());
      notifyListeners();
    }
  }
}
