import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

final dio = Dio();

addRetry() {
  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      logPrint: print, // specify log function
      retries: 3, // retry count
      retryDelays: const [
        Duration(milliseconds: 500), // wait half sec before first retry
        Duration(seconds: 1), // wait 1 sec before second retry
        Duration(seconds: 2), // wait 2 sec before third retry
      ],
    ),
  );
}

class RaribleAPI {
  Future<List<dynamic>> getSpotlight() async {
    dynamic data;
    addRetry();
    try {
      var response = await dio.get("https://data.rarible.com/featured");
      data = response.data;
    } catch (e) {
      rethrow;
    }
    DateTime now = DateTime.now();
    List<dynamic> record = data['records'];
    List<dynamic> spotlights = [];
    for (dynamic d in record) {
      DateTime from = DateTime.parse(d["createdTime"]);
      if (daysBetween(from, now) <= 30) {
        Map<String, dynamic> field = d['fields'];
        String title = field['title'] ?? "Unknown";
        String address;
        bool islocal;
        if (field.containsKey('address')) {
          islocal = true;
          address = field['address'];
        } else {
          islocal = false;
          address = field['URL'];
        }
        String type, url;
        if (field.containsKey("video")) {
          type = "video";
          url = field['video'][0]['url'];
        } else {
          type = "image";
          url = field['image'][0]['url'];
        }
        Map<String, dynamic> temp = {
          'title': title,
          'type': type,
          'url': url.replaceAll("https://dl.airtable.com/.attachments",
              "https://img.rarible.com/feat/video/webp/x2"),
          'thumbnail': url.replaceAll("https://dl.airtable.com/.attachments",
              "https://img.rarible.com/feat/video/png/x2"),
          'address': address,
          'islocal': islocal,
        };
        spotlights.add(temp);
      }
    }
    return spotlights;
  }

  Future<List<dynamic>> getCollection(
      {required String method,
      required String blockchain,
      required String period}) async {
    Map<String, dynamic> reference = {
      "Ethereum": "ETHEREUM",
      "Tezos": "TEZOS",
      "Flow": "FLOW",
      "Polygon": "POLYGON",
      "1 day": "DAY",
      "7 days": "WEEK",
      "30 days": "MONTH",
      "Collection": "collections",
      "Seller": "sellers"
    };
    addRetry();

    String baseUrl =
        "https://rarible.com/marketplace/api/v4/rankings/${reference[method]}";
    Map<String, dynamic> data = {
      "blockchain": reference[blockchain],
      "period": reference[period],
      "size": 15
    };
    try {
      var response = await dio.post(baseUrl, data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> collectionByRawAddress(String address) async {
    addRetry();
    String url = "https://rarible.com/marketplace/api/v4/collections/$address";
    try {
      var response = await dio.get(url);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> collectionStats(String address) async {
    addRetry();
    String url =
        "https://rarible.com/marketplace/api/v4/statistics/collections/$address/stats";
    try {
      var response = await dio.get(url);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  walletByAddress(List<String> addresses) async {
    addRetry();
    String url = "https://rarible.com/marketplace/api/v4/profiles/list";
    try {
      var response = await dio.post(url, data: addresses);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getItemsID({required List<String> collections}) async {
    addRetry();
    var data = {
      "size": 8,
      "filter": {
        "verifiedOnly": false,
        "sort": "LOW_PRICE_FIRST",
        "collections": collections,
        "currency": "0x0000000000000000000000000000000000000000",
        "nsfw": true,
        "creatorAddresses": []
      }
    };
    String url = "https://rarible.com/marketplace/search/v1/items";
    try {
      var response = await dio.post(url, data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
    // return 0;
  }

  Future<List<dynamic>> getItemsByIds({required List<String> ids}) async {
    addRetry();
    String url = "https://rarible.com/marketplace/api/v4/items/byIds";
    try {
      var response = await dio.post(url, data: ids);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getDataOfItemsOfCollection(String Address) async {
    addRetry();
    try {
      var items = await getItemsID(collections: [Address]);
      List<String> ids =
          List.from(items).map((e) => e['id'].toString()).toList();
      List<dynamic> data = await getItemsByIds(ids: ids);
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
