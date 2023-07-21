import 'package:flutter/material.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/support/widget/support_section_ticket_item.dart';

import '../../../theme/styles.dart';
import '../../common/custom_app_bar.dart';

class SupportSectionScreen extends StatefulWidget {
  const SupportSectionScreen({super.key});

  @override
  State<SupportSectionScreen> createState() => _SupportSectionScreenState();
}

class _SupportSectionScreenState extends State<SupportSectionScreen> {
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: 'Support Section',
      ),
      body: BackgroundImage(
        alignment: Alignment.topCenter,
        child: SafeArea(
          bottom: false,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: _style.scaleX(20), vertical: _style.scaleX(25)),
            itemBuilder: (context, index) {
              return SupportSectionTicketItem(
                style: _style,
                onPressed: () {},
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: _style.scaleX(25));
            },
            itemCount: 4,
          ),
        ),
      ),
    );
  }
}
