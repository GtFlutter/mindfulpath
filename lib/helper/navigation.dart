import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';

extension OnContext on BuildContext {
  Future<T?> pushViewPDFScreen<T extends Object?>(String url) {
    return push(RoutePath.pdfViewer, extra: url);
  }
}
