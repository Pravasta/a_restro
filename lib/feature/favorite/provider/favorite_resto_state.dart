import '../../../data/model/response/restaurant_response_model.dart';

sealed class FavoriteRestoState {}

class FavoriteRestoInitialState extends FavoriteRestoState {}

class FavoriteRestoLoadingState extends FavoriteRestoState {}

class FavoriteRestoLoadedState extends FavoriteRestoState {
  final List<Restaurant> data;

  FavoriteRestoLoadedState(this.data);
}

class FavoriteRestoSuccessState extends FavoriteRestoState {
  final String message;

  FavoriteRestoSuccessState(this.message);
}

class FavoriteRestoErrorState extends FavoriteRestoState {
  final String message;

  FavoriteRestoErrorState(this.message);
}
