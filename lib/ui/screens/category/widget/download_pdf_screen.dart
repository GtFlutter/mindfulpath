import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/helper/navigation.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';
import 'package:meditation_app/ui/screens/category/widget/detail_item.dart';

class DownloadPdfCategoryScreen extends ConsumerStatefulWidget {
  const DownloadPdfCategoryScreen({super.key});

  @override
  ConsumerState<DownloadPdfCategoryScreen> createState() =>
      _DownloadPdfCategoryScreenState();
}

class _DownloadPdfCategoryScreenState
    extends ConsumerState<DownloadPdfCategoryScreen>
    with AutomaticKeepAliveClientMixin {
  static AppStyle _style = AppStyle();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ref.read(courseProvider.notifier).downloadPdfResponses.clear();
      ref.read(courseProvider.notifier).downloadPdfResponse.clear();
      await getCategorys();
    });
    super.initState();
  }

  getCategorys()async{
    await ref.read(courseProvider).getCategoryPdfFromDatabase();
    for(final category in ref.watch(courseProvider).downloadPdfResponses){
      await ref.read(courseProvider.notifier).getPdfFromDatabase(category.categoryId??0);
    }

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
    _style = AppStyle(screenSize: size);

    final courseP = ref.watch(courseProvider);
    var getCategory = 0;
    int? getPdfId = 0;


    courseP.downloadPdfResponses.any((element) {
      getCategory = element.categoryId ?? 0;
      return true;
    });

    courseP.downloadPdfResponse.any((element) {
      getPdfId = int.parse(element.pdfId ?? "");

      return true;
    });


    return Scaffold(
        appBar: CustomAppBar(
          screenSize: size,
          style: _style,
          title: 'Downloaded Pdf',
        ),
        extendBodyBehindAppBar: true,
        body: Padding(
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
              var models = courseP.downloadPdfResponse.toSet().toList();
             // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${models.length}');

              print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${courseP.pushData}');

              if(courseP.pushData==true){
                courseP.downloadPdfResponse.clear();
                courseP.ref.read(courseProvider.notifier).pushData=false;
                getCategorys();

              }

              var model = models[index];

              return GestureDetector(
                onTap: () {
                  viewPdf(model.pdfFile);
                },
                child: DetailItem.pdf(
                  appStyle: _style,
                  title: model.pdfName ?? '',
                  subTitle: model.categoryTitle ?? "",
                  index: '$index',
                  isShow: false,
                  isRemove: true,
                  isDownloaded: false,
                  pressRemove: () async {
                    print('AEIOU__________96 ${courseP.downloadPdfResponse.length}');
                      print('AEIOU__________97 ${getCategory}');
                      print('AEIOU__________98 ${getPdfId}');
                        if (courseP.downloadPdfResponse.length == 1) {
                          courseP.ref.read(courseProvider.notifier).pushData = true;
                          courseP.ref
                              .read(courseProvider.notifier)
                              .deleteCategoryPdf(getCategory, context);
                          courseP.ref
                              .read(courseProvider.notifier)
                              .deletePdf(getPdfId??0, context);

                          courseP.downloadPdfResponses.clear();
                          courseP.downloadPdfResponse.clear();
                          await courseP.getCategoryPdfFromDatabase();
                          for(final category in courseP.downloadPdfResponses){
                            await ref.read(courseProvider.notifier).getPdfFromDatabase(category.categoryId??0);
                          }

                          setState(() {});

                        } else {
                          courseP.ref.read(courseProvider.notifier).pushData = true;
                          courseP.ref
                              .read(courseProvider.notifier)
                              .deletePdf(getPdfId??0, context);
                          courseP.downloadPdfResponses.clear();
                          courseP.downloadPdfResponse.clear();
                          await courseP.getCategoryPdfFromDatabase();
                          for(final category in courseP.downloadPdfResponses){
                            await ref.read(courseProvider.notifier).getPdfFromDatabase(category.categoryId??0);
                          }

                          setState(() {});
                        }



                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: _style.scaleX(25)),
          ),
        ));
  }

  void viewPdf(String? pdfUrl) {
    if (pdfUrl == null) return;
    context.pushViewPDFScreen(pdfUrl);
  }

  @override
  bool get wantKeepAlive => true;
}
