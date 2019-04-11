import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_trip/model/search_model.dart';

const HOME_URL = 'http://www.devio.org/io/flutter_app/json/home_page.json';

/// 搜索接口
class SearchDao {
  static Future<SearchModel> fetch(String url, String text) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(Utf8Decoder().convert(response.bodyBytes));
      SearchModel model = SearchModel.fromJson(result);
      model.keyword = text;
      return model;
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}
