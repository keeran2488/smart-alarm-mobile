import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smartClockFinal/news_model.dart';

class ApiManager {
  Future<NewsModel> getNews() async {
    var client = http.Client();

    var newsModel;

    try {
      var response = await client.get(
          'http://newsapi.org/v2/top-headlines?language=en&apiKey=a58184c8b6014a9ea17772a36ff15f01');
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        newsModel = NewsModel.fromJson(jsonMap);
      }
    } catch (Exception) {
      return newsModel;
    }
    return newsModel;
  }
}
