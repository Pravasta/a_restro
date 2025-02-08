import 'package:flutter/material.dart';

import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/feature/home/repository/home_repository.dart';

import 'get_popular_restaurant_state.dart';

class GetPopularRestaurantProvider extends ChangeNotifier {
  final HomeRepository _repository;

  GetPopularRestaurantProvider({
    required HomeRepository repository,
  }) : _repository = repository;

  GetPopularRestaurantState _resultState = GetPopularRestaurantInitialState();

  GetPopularRestaurantState get resultState => _resultState;

  Future<void> getPopularResto() async {
    List<Restaurant> popularResto = [];

    try {
      _resultState = GetPopularRestaurantLoadingState();
      notifyListeners();

      final result = await _repository.getRestaurantList();

      if (result.isNotEmpty) {
        for (int i = 0; i < result.length; i++) {
          if (result[i].rating! >= 4.5) {
            popularResto.add(result[i]);
          }
        }
        _resultState = GetPopularRestaurantLoadedState(popularResto);
        notifyListeners();
      } else {
        _resultState = GetPopularRestaurantLoadedState([]);
        notifyListeners();
      }
    } catch (e) {
      _resultState = GetPopularRestaurantErrorState(e.toString());
      notifyListeners();
    }
  }
}
