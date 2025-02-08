import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:a_restro/core/common/endpoint/app_endpoint.dart';
import 'package:a_restro/data/model/request/add_review_request_model.dart';
import 'package:a_restro/data/model/response/add_review_response_model.dart';
import 'package:a_restro/data/model/response/restaurant_detail_response_model.dart';
import 'package:a_restro/data/model/response/restaurant_response_model.dart';
import 'package:a_restro/data/model/response/search_restaurant_response_model.dart';

import '../../../core/exception/api_error_handler.dart';
import '../../../core/exception/api_exception.dart';

class RestaurantService {
  final http.Client _client;
  final AppEndpoint _endpoint;

  RestaurantService({
    required http.Client client,
    required AppEndpoint endpoint,
  })  : _client = client,
        _endpoint = endpoint;

  Future<RestaurantResponseModel> getRestaurantList() async {
    try {
      final url = _endpoint.getListRestaurant();

      final response = await _client.get(url);

      if (response.statusCode == 200) {
        return RestaurantResponseModel.fromJson(response.body);
      } else {
        final message = RestaurantResponseModel.fromJson(response.body);
        throw ApiErrorHandler.handleError(
          statusCode: response.statusCode,
          error: message.message ?? '',
        );
      }
    } catch (e) {
      if (e is SocketException) {
        throw 'Failed to connect to the network';
      } else {
        throw UnknownException(message: e.toString());
      }
    }
  }

  Future<SearchRestaurantResponseModel> searchRestaurant(String query) async {
    try {
      final url = _endpoint.searchRestaurant(query);

      final response = await _client.get(url);

      if (response.statusCode == 200) {
        return SearchRestaurantResponseModel.fromJson(response.body);
      } else {
        throw ApiErrorHandler.handleError(
          statusCode: response.statusCode,
          error: 'Restaurant not found',
        );
      }
    } catch (e) {
      if (e is SocketException) {
        throw 'Failed to connect to the network';
      } else {
        throw UnknownException(message: e.toString());
      }
    }
  }

  Future<RestaurantDetailResponseModel> getDetailRestaurant(
      String restoId) async {
    try {
      final url = _endpoint.getDetailRestaurant(restoId);

      final response = await _client.get(url);

      if (response.statusCode == 200) {
        return RestaurantDetailResponseModel.fromJson(response.body);
      } else {
        final message = RestaurantDetailResponseModel.fromJson(response.body);
        throw ApiErrorHandler.handleError(
          statusCode: response.statusCode,
          error: message.message ?? '',
        );
      }
    } catch (e) {
      if (e is SocketException) {
        throw 'Failed to connect to the network';
      } else {
        throw UnknownException(message: e.toString());
      }
    }
  }

  Future<AddReviewResponseModel> addReview(AddReviewRequestModel data) async {
    try {
      final url = _endpoint.addReview();
      final headers = {
        'Content-Type': 'application/json',
      };

      final response = await _client.post(
        url,
        headers: headers,
        body: data.toJson(),
      );

      if (response.statusCode == 201) {
        return AddReviewResponseModel.fromJson(response.body);
      } else {
        final message = RestaurantDetailResponseModel.fromJson(response.body);
        throw ApiErrorHandler.handleError(
          statusCode: response.statusCode,
          error: message.message ?? '',
        );
      }
    } catch (e) {
      if (e is SocketException) {
        throw 'Failed to connect to the network';
      } else {
        throw UnknownException(message: e.toString());
      }
    }
  }

  factory RestaurantService.create() {
    return RestaurantService(
      client: http.Client(),
      endpoint: AppEndpoint.create(),
    );
  }
}
