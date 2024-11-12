import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../theme/styles.dart';
import '../custom_app_bar.dart';

class PdfViewer extends StatelessWidget {
  final String url;
  const PdfViewer.network({super.key, required this.url});
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    _style = AppStyle(screenSize: size);
    return Scaffold(
      appBar: CustomAppBar(screenSize: size, style: _style),
      // ignore: avoid_unnecessary_containers
      body: Container(child: SfPdfViewer.network(url)),
    );
  }
}
