import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_trip/model/travel_model.dart';
import 'package:my_trip/model/travel_tab_model.dart';

var Params = {
  "districtId": -1,
  "groupChannelCode": "RX-OMF",
  "type": null,
  "lat": -180,
  "lon": -180,
  "locatedDistrictId": 0,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {'cid': "09031014111431397988"},
  "contentType": "json"
};

/// 旅拍接口
class TravelDao {
  static Future<TravelItemModel> fetch(
      String url, String groupChannelCode, int pageIndex, int pageSize) async {

    Map paramsMap = Params['pagePara'];
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize'] = pageSize;
    Params['groupChannelCode'] = groupChannelCode;

    final response = await http.post(url, body: jsonEncode(Params));
    if (response.statusCode == 200) {
      var result = json.decode(Utf8Decoder().convert(response.bodyBytes));
      return TravelItemModel.fromJson(result);
    } else {
      throw Exception('Failed to load travel');
    }
  }
}
