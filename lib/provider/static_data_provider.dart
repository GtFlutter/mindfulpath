import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/model/response/static_data_model.dart';
import 'package:meditation_app/provider/repo_provider/config_repo_provider.dart';

final getStaticDataProvider = FutureProvider<List<StaticData>>((ref) async {
  var repo = ref.read(configRepoProvider);

  Response response = await repo.getStaticPageData();

  List<StaticData> listStaticData = <StaticData>[];
  if (response.statusCode == 200) {
    listStaticData = [];
    try {
      final jsonData = jsonDecode(response.body)['data']['static_page_data'];
      jsonData.forEach((v) {
        listStaticData.add(StaticData.fromJson(v));
      });
      return listStaticData;
    } catch (_) {
      return [];
    }
  } else {
    return [];
  }
});
