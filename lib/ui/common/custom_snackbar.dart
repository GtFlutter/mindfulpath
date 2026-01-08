import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as ref;
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/theme/text_style.dart';

import '../../helper/route/route_paths.dart';
import '../../provider/auth_provider.dart';
import '../../theme/colors.dart';

/// [type]   true = Sucsses, false = Error and for null = Normal
/// Default const Duration(seconds: 3)
void showCustomSnackBar(
  String message, {
  bool? type,
  SnackBarAction? action,
  Duration? duration,
}) {
  BuildContext? context = rootNavigator.currentContext;
  if (context != null && context.mounted) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: mulishRegular400.copyWith(
                color: type == null
                    ? null
                    : type
                        ? Colors.green.shade900
                        : Colors.red.shade900),
          ),
          duration: duration ?? const Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          behavior: SnackBarBehavior.floating,
          action: action,
        ),
      );
  }
}
bool isLogin(String msg,WidgetRef ref){
  bool isLoggedIn = ref.read(authProvider).isUserLoggedIn;
  if(!isLoggedIn){
    showCustomSnackBar(
      msg,
      action: SnackBarAction(
        label: 'Sign in',
        backgroundColor: AppColors.primaryColor.withOpacity(0.8),
        textColor: Colors.brown.shade800,
        onPressed: () => appRouter.go(RoutePath.signIn),
      ),
      duration: const Duration(seconds: 5),
    );
    return false;
  }else{
    return true;
  }
  return false;
}