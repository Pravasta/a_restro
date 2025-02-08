import '../../../../data/model/response/restaurant_response_model.dart';

sealed class GetPopularRestaurantState {}

class GetPopularRestaurantInitialState extends GetPopularRestaurantState {}

class GetPopularRestaurantLoadingState extends GetPopularRestaurantState {}

class GetPopularRestaurantErrorState extends GetPopularRestaurantState {
  final String error;

  GetPopularRestaurantErrorState(this.error);
}

class GetPopularRestaurantLoadedState extends GetPopularRestaurantState {
  final List<Restaurant> data;

  GetPopularRestaurantLoadedState(this.data);
}
