import 'package:flutter/material.dart';

import 'package:a_restro/feature/search/provider/search_restaurant_state.dart';
import 'package:a_restro/feature/search/repository/search_repository.dart';

class SearchRestaurantProvider extends ChangeNotifier {
  final SearchRepository _repository;

  SearchRestaurantProvider({
    required SearchRepository repository,
  }) : _repository = repository;

  SearchRestaurantState _resultState = SearchRestaurantInitialState();

  SearchRestaurantState get resultState => _resultState;

  Future<void> searchRestaurant(String query) async {
    try {
      _resultState = SearchRestaurantLoadingState();
      notifyListeners();

      await Future.delayed(Duration(seconds: 1));

      final result = await _repository.searchRestaurant(query);

      if (result.isNotEmpty) {
        _resultState = SearchRestaurantLoadedState(data: result);
      } else {
        _resultState = SearchRestaurantLoadedState(data: []);
      }
      notifyListeners();
    } catch (e) {
      _resultState = SearchRestaurantErrorState(error: e.toString());
      notifyListeners();
    }
  }
}
