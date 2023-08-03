import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/response/static_data_model.dart';
import 'package:meditation_app/provider/static_data_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';
import 'package:meditation_app/util/constants.dart';

import '../../../theme/styles.dart';

/// Terms & Conditions And Privacy Policy Screen
class TCPPScreen extends ConsumerWidget {
  final bool isTermsAndConditions;
  const TCPPScreen({super.key, required this.isTermsAndConditions});
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    /// [isTerms] True If This is For Terms & Conditions And False For Privacy Policy

    AsyncValue<List<StaticData>> data = ref.watch(getStaticDataProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        screenSize: size,
        title: isTermsAndConditions ? 'Terms & Conditions' : 'Privacy Policy',
        style: _style,
      ),
      body: BackgroundImage(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(getStaticDataProvider.future),
            child: data.when(
              // skipLoadingOnRefresh: false,
              data: (data) {
                int index = data.indexWhere(
                  (element) {
                    return element.key == (isTermsAndConditions ? 'terms_condition' : 'privacy_policy');
                  },
                );
                if (index != -1 && data[index].value != null) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(_style.scale * 20),
                    child: Html(
                      shrinkWrap: true,
                      data: data[index].value ?? '',
                      style: {
                        "p.fancy": Style(
                          textAlign: TextAlign.center,
                          padding: HtmlPaddings.all(16),
                          backgroundColor: Colors.grey,
                          margin: Margins(left: Margin(50, Unit.px), right: Margin.auto()),
                          width: Width(300, Unit.px),
                          fontWeight: FontWeight.bold,
                        ),
                      },
                    ),
                  );
                } else {
                  return WentWrong(
                    style: _style,
                    onPressed: () {
                      ref.refresh(getStaticDataProvider.future);
                    },
                  );
                }
              },
              error: (Object error, StackTrace stackTrace) {
                return WentWrong(
                  style: _style,
                  onPressed: () {
                    ref.refresh(getStaticDataProvider.future);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WentWrong extends StatelessWidget {
  final VoidCallback? onPressed;

  const WentWrong({
    super.key,
    required this.style,
    this.onPressed,
  });

  final AppStyle style;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(style.scaleX(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              AppConstants.WENT_WRONG,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: onPressed,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
