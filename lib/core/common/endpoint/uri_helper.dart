class UriHelper {
  static createUrl({
    required String host,
    String? path,
    Map<String, dynamic>? queryParameters,
  }) {
    return Uri(
        scheme: 'https',
        host: host,
        path: path,
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ));
  }
}
