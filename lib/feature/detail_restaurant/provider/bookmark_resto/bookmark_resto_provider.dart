import 'package:a_restro/feature/detail_restaurant/repository/detail_restaurant_repository.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/request/add_favorite_resto_request_model.dart';

class BookmarkRestoProvider extends ChangeNotifier {
  final DetailRestaurantRepository _repository;

  BookmarkRestoProvider({
    required DetailRestaurantRepository repository,
  }) : _repository = repository;

  String _message = '';
  String get message => _message;

  bool _isBookmark = false;

  bool get isBookmark => _isBookmark;

  set isBookmarked(bool value) {
    _isBookmark = value;
    notifyListeners();
  }

  Future<void> addBookmark(AddFavoriteRestoRequestModel data) async {
    try {
      final result = await _repository.insertFavoriteRestaurant(data);

      _message = result;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeBookmark(String id) async {
    try {
      final result = await _repository.removeFavoriteRestaurant(id);

      _message = result;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      notifyListeners();
    }
  }

  Future<bool> checkBookmarked(String id) async {
    try {
      final result = await _repository.getRestaurantById(id);
      return result.id == id;
    } catch (e) {
      return false;
    }
  }
}
