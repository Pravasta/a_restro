import 'package:a_restro/data/model/response/restaurant_detail_response_model.dart';

sealed class GetDetailRestaurantState {}

class GetDetailRestaurantIntialState extends GetDetailRestaurantState {}

class GetDetailRestaurantLoadingState extends GetDetailRestaurantState {}

class GetDetailRestaurantErrorState extends GetDetailRestaurantState {
  final String error;

  GetDetailRestaurantErrorState({required this.error});
}

class GetDetailRestaurantLoadedState extends GetDetailRestaurantState {
  final RestaurantDetail data;

  GetDetailRestaurantLoadedState({required this.data});
}
