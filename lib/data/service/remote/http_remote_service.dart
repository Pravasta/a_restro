import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class HttpRemoteService {
  final http.Client _client;

  HttpRemoteService({
    required http.Client client,
  }) : _client = client;

  Future<String> downloadAndSaveFile(String url, String fileName) async {
    final bytes = await getByteArrayFromUrl(url);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  Future<Uint8List> getByteArrayFromUrl(String url) async {
    final response = await _client.get(Uri.parse(url));
    return response.bodyBytes;
  }

  factory HttpRemoteService.create() {
    return HttpRemoteService(client: http.Client());
  }
}
