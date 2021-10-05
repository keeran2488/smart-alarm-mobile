import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smartClockFinal/api/urls.dart';
import 'package:smartClockFinal/models/news_model.dart';

class ApiManager {
  Future<NewsModel> getNews() async {
    var client = http.Client();
    var response = await client.get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);

      return NewsModel.fromJson(jsonMap);
    } else {
      throw Exception("Failed to load news");
    }
  }
}
