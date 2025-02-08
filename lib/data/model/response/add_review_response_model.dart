import 'dart:convert';

import 'package:a_restro/data/model/response/restaurant_detail_response_model.dart';

class AddReviewResponseModel {
  final bool? error;
  final String? message;
  final List<CustomerReview>? customerReviews;

  AddReviewResponseModel({
    this.error,
    this.message,
    this.customerReviews,
  });

  factory AddReviewResponseModel.fromJson(String str) =>
      AddReviewResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddReviewResponseModel.fromMap(Map<String, dynamic> json) =>
      AddReviewResponseModel(
        error: json["error"],
        message: json["message"],
        customerReviews: json["customerReviews"] == null
            ? []
            : List<CustomerReview>.from(
                json["customerReviews"]!.map((x) => CustomerReview.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "customerReviews": customerReviews == null
            ? []
            : List<dynamic>.from(customerReviews!.map((x) => x.toMap())),
      };
}
