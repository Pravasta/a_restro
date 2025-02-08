import 'package:a_restro/data/model/response/restaurant_response_model.dart';

sealed class SearchRestaurantState {}

class SearchRestaurantInitialState extends SearchRestaurantState {}

class SearchRestaurantLoadingState extends SearchRestaurantState {}

class SearchRestaurantErrorState extends SearchRestaurantState {
  final String error;

  SearchRestaurantErrorState({required this.error});
}

class SearchRestaurantLoadedState extends SearchRestaurantState {
  final List<Restaurant> data;

  SearchRestaurantLoadedState({required this.data});
}
