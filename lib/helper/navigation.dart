import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';

import '../data/model/response/category_list_reponse.dart';
import '../ui/screens/category/widget/detail_item.dart';

extension OnContext on BuildContext {
  Future<T?> pushViewPDFScreen<T extends Object?>(String url) {
    return push(RoutePath.pdfViewer, extra: url);
  }

  void goToDetailCategoryScreen(CategoryListResponse category, {DIModel? video}) {
    return go(RoutePath.detailCategoryScreenPath, extra: (category, video));
  }
}
