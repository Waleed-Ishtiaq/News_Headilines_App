// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_model.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';

class NewsRepository {
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlineApi(
      String name) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=$name&apiKey=f048c3ec1c5746bcb76c73d0244bea56';
    final response = await http.get(Uri.parse(url));

    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoriesNewsModel> categoriesNewsApi(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=$category&apiKey=f048c3ec1c5746bcb76c73d0244bea56';
    final response = await http.get(Uri.parse(url));

    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
