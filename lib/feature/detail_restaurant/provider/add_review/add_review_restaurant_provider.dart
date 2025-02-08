import 'package:a_restro/data/model/request/add_review_request_model.dart';
import 'package:a_restro/feature/detail_restaurant/provider/add_review/add_review_restaurant_state.dart';
import 'package:a_restro/feature/detail_restaurant/repository/detail_restaurant_repository.dart';
import 'package:flutter/material.dart';

class AddReviewRestaurantProvider extends ChangeNotifier {
  final DetailRestaurantRepository _repository;

  AddReviewRestaurantProvider({
    required DetailRestaurantRepository repository,
  }) : _repository = repository;

  AddReviewRestaurantState _resultState = AddReviewRestaurantIntialState();

  AddReviewRestaurantState get resultState => _resultState;

  Future<void> addReviewRestaurant(AddReviewRequestModel data) async {
    try {
      _resultState = AddReviewRestaurantLoadingState();
      notifyListeners();

      await _repository.addReview(data);

      _resultState = AddReviewRestaurantIntialState();
      notifyListeners();
    } catch (e) {
      _resultState = AddReviewRestaurantErrorState(error: e.toString());
      notifyListeners();
    }
  }
}
