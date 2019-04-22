import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_trip/model/travel_tab_model.dart';

const TRAVEL_TAB_URL = 'http://www.devio.org/io/flutter_app/json/travel_page.json';

/// 旅拍类别接口
class TravelTabDao {
  static Future<TravelTabModel> fetch() async {
    final response = await http.get(TRAVEL_TAB_URL);
    if (response.statusCode == 200) {
      var result = json.decode(Utf8Decoder().convert(response.bodyBytes));
      return TravelTabModel.fromJson(result);
    } else {
      throw Exception('Failed to load travel_page.json');
    }
  }
}
