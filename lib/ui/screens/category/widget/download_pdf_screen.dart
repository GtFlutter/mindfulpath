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
  ConsumerState<DownloadPdfCategoryScreen> createState() => _DownloadPdfCategoryScreenState();
}

class _DownloadPdfCategoryScreenState extends ConsumerState<DownloadPdfCategoryScreen> with AutomaticKeepAliveClientMixin  {
  static AppStyle _style = AppStyle();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {


    },);
    super.initState();
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


    return Scaffold(
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: 'Downloaded Pdf',
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 100,left: 20,right: 20),
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
            var model = courseP.downloadPdfResponse[index];
            return GestureDetector(
              onTap: (){
                viewPdf(model.pdfFile);
              },
              child: DetailItem.pdf(
                appStyle: _style,
                title: model.pdfName ?? '',
                subTitle: 'Meditation',
                index: '$index',
                isShow: false,
                isDownloaded: false,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
        ),
      )
    );
  }

  void viewPdf(String? pdfUrl) {
    if (pdfUrl == null) return;
    context.pushViewPDFScreen(pdfUrl);
  }


  @override
  bool get wantKeepAlive => true;
}
