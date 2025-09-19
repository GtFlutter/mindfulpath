import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/helper/navigation.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/provider/resource_provider/free_pdfs_provider.dart';

import '../../../../../data/model/response/category_list_reponse.dart';
import '../../../../../database/database_helper.dart';
import '../../../../../helper/route/route_paths.dart';
import '../../../../../helper/route/router.dart';
import '../../../../../provider/auth_provider.dart';
import '../../../../../provider/bookmark_provider.dart';
import '../../../../../theme/colors.dart';
import '../../../../../theme/styles.dart';
import '../../../../common/custom_snackbar.dart';
import '../detail_item.dart';

class FreePdfListWidget extends ConsumerStatefulWidget {
  final CategoryListResponse category;

  const FreePdfListWidget({super.key, required this.category});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FreePdfListWidgetState();
}

class _FreePdfListWidgetState extends ConsumerState<FreePdfListWidget> with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ref.read(freePdfsProvider).fetchPdfs(widget.category.id!);
      await initCall();
    });

    ///to get downloaded pdf for if already downloaded then hide button so....
    super.initState();
  }

  Future<void> initCall() async {
    ref.read(freePdfsProvider).downloadedPDF = await ref.read(databaseProvider).getPdf(widget.category.id!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> refreshh() async {
    Future.delayed(Duration.zero, () async {
      final coursePRead = ref.read(courseProvider);
      final coursePWatch = ref.watch(courseProvider);
      await coursePRead.getCategoryPdfFromDatabase();
      // for(final category in coursePWatch.downloadPdfResponses){
      print('+++++++++_________----------+++++++${widget.category.id}');
      await coursePRead.getPdfFromDatabase(widget.category.id ?? 0);

      //}
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _style = AppStyle(screenSize: MediaQuery.sizeOf(context));
    var provider = ref.watch(freePdfsProvider);

    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');

    provider.downloadedPDF.map((e) {
      print('First Id%%%%%%%%%%%%%%%%%%%%${e.categoryId}');
    });

    provider.pdfsResponse?.list?.map((e) {
      print('Second Id%%%%%%%%%%%%%%%%%%%%${e.categoryId}');
    });

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.pdfsResponse == null || provider.pdfsResponse!.list == null) {
      return const Center(child: Text('Unable to find data!'));
    }
    if (provider.pdfsResponse!.list!.isEmpty) {
      return const Center(child: Text('Free PDF\'s Is Empty'));
    }

    final downloadP = ref.watch(downloadProvider);

    print('++++++++++===========++++++++++${downloadP.Pdfcomplate}');
    if (downloadP.Pdfcomplate == true) {
      refreshh();
      ref.read(downloadProvider.notifier).Pdfcomplate = false;
      setState(() {});
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: _style.scale * 100,
        top: _style.scale * 10,
      ),
      itemCount: provider.pdfsResponse!.list!.length,
      itemBuilder: (context, index) {
        var model = provider.pdfsResponse!.list![index];
        print('-------456------->${model.categoryId}');
        final data = provider.downloadedPDF.any((element) => model.categoryId == element.categoryId);
        final datas = provider.downloadedPDF.any((element) => element.id == provider.pdfsResponse?.list?[index].id);
        print('-------123------->$data');
        print('--------789------>$datas');
        print('-------model.pdf!.id------->${model.id}');

        return GestureDetector(
          onTap: () => viewPdf(model.pdfUrl),
          child: DetailItem.pdf(
            appStyle: _style,
            title: model.title ?? '',
            pdfModel: model,
            subTitle: model.categoryTitle ?? '',
            index: '$index',
            seletedItemId: model.id,
            isShow: true,
            isDownloaded: provider.downloadedPDF.any((element) => model.id.toString() == element.pdfId),
            onToggleBookmark: () {
              toggleItemBookmark(model.id, isRemove: model.bookmarked ?? false,);
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
    );
  }

  Future<void> toggleItemBookmark(int? itemId, {bool isRemove = false}) async {
    bool isLoggedIn = ref.read(authProvider).isUserLoggedIn;
    if(!isLoggedIn){
      showCustomSnackBar(
        'Please Sign in to Bookmark',
        action: SnackBarAction(
          label: 'Sign in',
          backgroundColor: AppColors.primaryColor.withOpacity(0.8),
          textColor: Colors.brown.shade800,
          onPressed: () => appRouter.go(RoutePath.signIn),
        ),
        duration: const Duration(seconds: 5),
      );
      return;
    }
    if (itemId == null) return;
    await ref.read(bookmarkProvider.notifier).toggleBookmark(itemId, isRemove: isRemove,isPDF: true);
    ref.read(freePdfsProvider.notifier).fetchPdfs(widget.category.id ?? 0);
  }

  void viewPdf(String? pdfUrl) {
    if (pdfUrl == null) return;
    context.pushViewPDFScreen(pdfUrl);
  }



  @override
  bool get wantKeepAlive => true;
}
