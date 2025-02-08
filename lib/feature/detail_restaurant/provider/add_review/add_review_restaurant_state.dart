sealed class AddReviewRestaurantState {}

class AddReviewRestaurantIntialState extends AddReviewRestaurantState {}

class AddReviewRestaurantLoadingState extends AddReviewRestaurantState {}

class AddReviewRestaurantErrorState extends AddReviewRestaurantState {
  final String error;

  AddReviewRestaurantErrorState({required this.error});
}
