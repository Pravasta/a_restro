import 'package:flutter/material.dart';

import 'package:a_restro/feature/favorite/provider/favorite_resto_state.dart';
import 'package:a_restro/feature/favorite/repository/favorite_repository.dart';

class FavoriteRestoProvider extends ChangeNotifier {
  final FavoriteRepository _repository;

  FavoriteRestoProvider({
    required FavoriteRepository repository,
  }) : _repository = repository;

  FavoriteRestoState _resultState = FavoriteRestoInitialState();
  FavoriteRestoState get resultState => _resultState;

  Future<void> getAllFavoriteRestaurant() async {
    try {
      _resultState = FavoriteRestoLoadingState();
      notifyListeners();

      final result = await _repository.getAllFavoriteRestaurant();

      _resultState = FavoriteRestoLoadedState(result);
      notifyListeners();
    } catch (e) {
      _resultState = FavoriteRestoErrorState(e.toString());
      notifyListeners();
    }
  }
}
