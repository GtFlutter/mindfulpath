import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/common/background_image.dart';

import '../../provider/shared_pref_provider.dart';
import '../../util/assets.dart';

class SplashScreen extends ConsumerStatefulWidget {

  const SplashScreen({super.key});


  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      if (!mounted) return; // ensure widget is still active
      // final auth = ref.read(authProvider);
      context.go(RoutePath.discoverScreen);
      // if (auth.isUserLoggedIn) {
      //   context.go(RoutePath.discoverScreen);
      // } else {
      //   context.go(RoutePath.signIn);
      // }
    });

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);


    return Scaffold(
      backgroundColor: Colors.black,
      body: BackgroundImage(
        alignment: AlignmentDirectional.center,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              ImagePaths.splashLogo1,
              width: size.shortestSide * 0.3,
              fit: BoxFit.cover,
            ),
            // Padding(
            //   padding: EdgeInsets.only(bottom: (size.shortestSide * 0.3) * 0.15),
            //   child: Text(
            //     'Calm Oasis',
            //     style: _style.text.font(mulishLight300, sizePx: 40, spacingPc: 4.5),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
