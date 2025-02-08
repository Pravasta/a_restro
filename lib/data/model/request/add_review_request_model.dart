import 'dart:convert';

class AddReviewRequestModel {
  final String id;
  final String review;
  final String name;
  AddReviewRequestModel({
    required this.id,
    required this.review,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'review': review,
      'name': name,
    };
  }

  factory AddReviewRequestModel.fromMap(Map<String, dynamic> map) {
    return AddReviewRequestModel(
      id: map['id'] as String,
      review: map['review'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddReviewRequestModel.fromJson(String source) =>
      AddReviewRequestModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
