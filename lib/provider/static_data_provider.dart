import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/model/response/static_data_model.dart';
import 'package:meditation_app/provider/repo_provider/auth_repo_provider.dart';

final getStaticDataProvider = FutureProvider<List<StaticData>>((ref) async {
  var repo = ref.read(authRepoProvider);

  Response response = await repo.getStaticPage();

  List<StaticData> listStaticData = <StaticData>[];
  if (response.statusCode == 200) {
    listStaticData = [];
    jsonDecode(response.body)['data']['static_page_data'].forEach((v) {
      listStaticData.add(StaticData.fromJson(v));
    });
    return listStaticData;
  } else {
    return [];
  }
});
