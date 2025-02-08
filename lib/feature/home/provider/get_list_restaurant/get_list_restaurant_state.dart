import 'package:a_restro/data/model/response/restaurant_response_model.dart';

sealed class GetListRestaurantState {}

class GetListRestaurantInitialState extends GetListRestaurantState {}

class GetListRestaurantLoadingState extends GetListRestaurantState {}

class GetListRestaurantErrorState extends GetListRestaurantState {
  final String error;

  GetListRestaurantErrorState(this.error);
}

class GetListRestaurantLoadedState extends GetListRestaurantState {
  final List<Restaurant> data;

  GetListRestaurantLoadedState(this.data);
}
