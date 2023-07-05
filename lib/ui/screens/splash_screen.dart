import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/screen_paths.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/util/assets.dart';

import '../../theme/styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    Future.delayed(const Duration(seconds: 3), () {
      context.go(ScreenPaths.signInUp, extra: true);
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: BackgroundImage(
        alignment: AlignmentDirectional.center,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              ImagePaths.splashLogo,
              width: size.shortestSide * 0.3,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: (size.shortestSide * 0.3) * 0.15),
              child: Text(
                'Calm Oasis',
                style: _style.text.font(mulishLight300, sizePx: 40, spacingPc: 4.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
