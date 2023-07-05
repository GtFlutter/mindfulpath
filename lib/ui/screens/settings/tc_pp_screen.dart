import 'package:flutter/material.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';

import '../../../theme/styles.dart';

/// TODO : Working On Terms And Conditions

/// Terms & Conditions And Privacy Policy Screen
class TCPPScreen extends StatelessWidget {
  final bool isTermsAndConditions;
  const TCPPScreen({super.key, required this.isTermsAndConditions});
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    /// [isTerms] True If This is For Terms & Conditions And False For Privacy Policy

    String termsAndConditions =
        '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.Lorem Ipsum has been the industry's standard .
''';
    String privacyPolicy =
        '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.

Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.Lorem Ipsum has been the industry's standard .
''';

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        screenSize: size,
        title: isTermsAndConditions ? 'Terms & Conditions' : 'Privacy Policy',
        onDonePressed: () {},
        style: _style,
      ),
      body: BackgroundImage(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(_style.scale * 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isTermsAndConditions ? termsAndConditions : privacyPolicy,
                style: _style.text.font(
                  isTermsAndConditions ? mulishSemiBold600 : mulishMedium500,
                  sizePx: 10,
                  heightPx: 18,
                  color: isTermsAndConditions ? AppColors.tcContentColor : AppColors.ppContentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
