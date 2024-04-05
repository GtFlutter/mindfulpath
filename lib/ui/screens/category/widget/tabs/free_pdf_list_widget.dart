import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/helper/navigation.dart';
import 'package:meditation_app/provider/resource_provider/free_pdfs_provider.dart';

import '../../../../../data/model/response/category_list_reponse.dart';
import '../../../../../database/database_helper.dart';
import '../../../../../theme/styles.dart';
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
  void initState()  {

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _style = AppStyle(screenSize: MediaQuery.sizeOf(context));
    var provider = ref.watch(freePdfsProvider);

    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');

    provider.downloadedPDF.map((e){
      print('First Id%%%%%%%%%%%%%%%%%%%%${e.categoryId}');
    });

    provider.pdfsResponse?.list?.map((e){
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
       final data= provider.downloadedPDF.any((element) => model.categoryId==element.categoryId);
       final datas= provider.downloadedPDF.any((element) => element.id == provider.pdfsResponse?.list?[index].id);
        print('-------123------->$data');
        print('-------789------->$datas');

        return GestureDetector(
          onTap: () => viewPdf(model.pdfUrl),
          child: DetailItem.pdf(
            appStyle: _style,
            title: model.title ?? '',
            pdfModel: model,
            subTitle: model.categoryTitle ?? '',
            index: '$index',
            isShow: true,
            isDownloaded:provider.downloadedPDF.any((element) => model.categoryId==element.categoryId),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
    );
  }

  void viewPdf(String? pdfUrl) {
    if (pdfUrl == null) return;
    context.pushViewPDFScreen(pdfUrl);
  }

  @override
  bool get wantKeepAlive => true;
}
