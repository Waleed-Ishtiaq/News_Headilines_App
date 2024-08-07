import 'package:news_app/models/categories_model.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  final _repo = NewsRepository();

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlineApi(
      String channelName) async {
    final response = await _repo.fetchNewsChannelHeadlineApi(channelName);
    return response;
  }

  Future<CategoriesNewsModel> categoriesNewsApi(String category) async {
    final response = await _repo.categoriesNewsApi(category);
    return response;
  }
}
