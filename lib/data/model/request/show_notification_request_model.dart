class ShowNotificationRequestModel {
  final int id;
  final String title;
  final String body;
  final String payload;
  final String contentTitle;
  final String description;
  final String imageUrl;

  ShowNotificationRequestModel({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.contentTitle,
    required this.description,
    required this.imageUrl,
  });
}
