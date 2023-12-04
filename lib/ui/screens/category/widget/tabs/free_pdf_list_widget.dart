import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/provider/resource_provider/free_pdfs_provider.dart';

import '../../../../../theme/styles.dart';
import '../detail_item.dart';

class FreePdfListWidget extends ConsumerStatefulWidget {
  final int categoryId;
  final String categoryTitle;

  const FreePdfListWidget({super.key, required this.categoryTitle, required this.categoryId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FreePdfListWidgetState();
}

class _FreePdfListWidgetState extends ConsumerState<FreePdfListWidget> with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    Future.delayed(Duration.zero, () => ref.read(freePdfsProvider).fetchPdfs(widget.categoryId));
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
    _style = AppStyle(screenSize: MediaQuery.sizeOf(context));
    var provider = ref.watch(freePdfsProvider);

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

        return GestureDetector(
          onTap: () => viewPdf(model.pdfUrl),
          child: DetailItem.pdf(
            appStyle: _style,
            title: model.title ?? '',
            subTitle: model.categoryTitle ?? '',
            index: '$index',
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
    );
  }

  void viewPdf(String? pdfUrl) {
    if (pdfUrl == null) return;

    /// TODO ::: View PDF
  }

  @override
  bool get wantKeepAlive => true;
}
