import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/database/database_model.dart';
import 'package:meditation_app/helper/navigation.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';
import 'package:meditation_app/ui/screens/category/widget/detail_item.dart';

import '../../../../data/model/response/pdfs_response.dart';

class DownloadPdfCategoryScreen extends ConsumerStatefulWidget {
  const DownloadPdfCategoryScreen({super.key});

  @override
  ConsumerState<DownloadPdfCategoryScreen> createState() => _DownloadPdfCategoryScreenState();
}

class _DownloadPdfCategoryScreenState extends ConsumerState<DownloadPdfCategoryScreen> with AutomaticKeepAliveClientMixin {
  static AppStyle _style = AppStyle();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero, ()  {
      // if (ref.read(courseProvider).downloadPdfResponse.isNotEmpty) return;
       getCategorys();
      //  getPDFData();
    });
    super.initState();
  }
  getPDFData() async {
    if (ref.read(courseProvider).downloadPdfResponse.isNotEmpty) return;
    await ref.read(courseProvider).getPdfFromDatabaseTemp();
  }

  getCategorys() async {
    if (ref.read(courseProvider.notifier).downloadPdfResponse.isNotEmpty) return;
    log("inti caaallllleeddddd");
    ref.read(courseProvider.notifier).downloadPdfResponses.clear();
    ref.read(courseProvider.notifier).downloadPdfResponse.clear();
    final coursePro = ref.read(courseProvider);
    coursePro.stopPDFLoading();
    await coursePro.getCategoryPdfFromDatabase();
    if (coursePro.downloadPdfResponses.isEmpty) return;
    for (final category in coursePro.downloadPdfResponses) {
      await ref.read(courseProvider.notifier).getPdfFromDatabase(int.parse(category.categoryId ?? ""));
    }
    coursePro.stopPDFLoading();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Size size = MediaQuery.sizeOf(context);
    final courseP = ref.watch(courseProvider);
    _style = AppStyle(screenSize: size);

    return Scaffold(
        appBar: CustomAppBar(
          screenSize: size,
          style: _style,
          title: 'Downloaded Pdf',
        ),
        extendBodyBehindAppBar: true,
        // body: courseP.isPDFLoading == false && courseP.downloadPdfResponse.isNotEmpty
        body:courseP.downloadPdfResponse.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _controller,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(
                    bottom: _style.scale * 100,
                    top: _style.scale * 10,
                  ),
                  itemCount: courseP.downloadPdfResponse.length,
                  itemBuilder: (context, index) {
                    // var models = courseP.downloadPdfResponse.toSet().toList();
                    if (courseP.pushData == true) {
                      // courseP.downloadPdfResponse.clear();
                      courseP.pushData = false;
                      // getCategorys();
                      //  courseP.getPdfFromDatabaseTemp();
                    }
                    PdfModel model = PdfModel();
                    if (courseP.downloadPdfResponse.isNotEmpty) {
                      model = courseP.downloadPdfResponse[index];
                    }

                    return GestureDetector(
                      onTap: () {
                        viewPdf(model.pdfFile);
                      },
                      child: DetailItem.pdf(
                        appStyle: _style,
                        // pdfModel: PdfResponse(),
                        title: model.pdfName ?? '',
                        subTitle: model.categoryTitle ?? "",
                        index: '$index',
                        isShow: false,
                        isRemove: true,
                        onToggleBookmark: (){},
                        isDownloaded: false,
                        pressRemove: () async {
                          print('courseP.downloadPdfResponse.length ${courseP.downloadPdfResponse.length}');
                          if (courseP.downloadPdfResponse.length == 1) {
                            // courseP.startPDFLoading();
                            courseP.pushData = true;
                            await courseP.deleteCategoryPdf(model.categoryId ?? 0, context);
                            await courseP.deletePdf(int.parse(model.pdfId ?? "0"), context);

                            courseP.downloadPdfResponses.clear();
                            courseP.downloadPdfResponse.clear();
                            // await courseP.getCategoryPdfFromDatabase();
                            // for (final category in courseP.downloadPdfResponses) {
                            //   await courseP.getPdfFromDatabase(category.categoryId ?? 0);
                            // }
                            // courseP.stopPDFLoading();
                            setState(() {});
                          } else {
                            log("else ............called");
                            // courseP.startPDFLoading();
                            courseP.pushData = true;
                            await courseP.deletePdf(int.parse(model.pdfId ?? "0"), context);
                            /*// courseP.downloadPdfResponses.clear();
                            // courseP.downloadPdfResponse.clear();
                            // await courseP.getCategoryPdfFromDatabase();
                            //   for (final category in courseP.downloadPdfResponses) {
                            //     await courseP.getPdfFromDatabase(category.categoryId ?? 0);
                            //   }
                            //
                            //
                            // courseP.stopPDFLoading();
                             courseP.getPdfFromDatabaseTemp();*/
                            courseP.downloadPdfResponse.removeAt(index);
                            setState(() {});
                          }
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
                ),
              )
            : Center(
                child:courseP.isPDFLoading? const CircularProgressIndicator():const Center(child: Text("No downloaded PDF found.",style: TextStyle(fontSize: 16, color: Colors.white)),),
              ));
  }

  @override
  void deactivate() {
    ref.read(courseProvider.notifier).downloadPdfResponse.clear();
    ref.read(courseProvider.notifier).downloadPdfResponses.clear();
    super.deactivate();
  }

  void viewPdf(String? pdfUrl) {
    if (pdfUrl == null) return;
    context.pushViewPDFScreen(pdfUrl);
  }

  @override
  bool get wantKeepAlive => true;
}
