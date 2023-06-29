import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route_helper.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/views/base/background_image.dart';

import '../util/app_images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Future.delayed(
      const Duration(seconds: 3),
      () => context.replace(RouteHelper.signInUp),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: BackgroundImage(
        alignment: AlignmentDirectional.center,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              AppImages.splashLogo,
              width: size.shortestSide * 0.3,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: (size.shortestSide * 0.3) * 0.15),
              child: Text(
                'Calm Oasis',
                style: mulishLight300.copyWith(fontSize: 40, letterSpacing: 4.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
