import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/payment/payment_screen.dart';
import 'package:meditation_app/provider/dashboard_provider.dart';
import 'package:meditation_app/provider/resource_provider/paid_videos_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/util/constants.dart';

import '../../../../provider/auth_provider.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog(this.style, {super.key});

  final AppStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authP = ref.watch(authProvider);
    return AbsorbPointer(
      absorbing: authP.isLoading,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: style.scaleX(330)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            style.scaleX(12.5),
            style.scaleX(26.5),
            style.scaleX(12.5),
            style.scaleX(18),
          ),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Log out',
                    style: style.text.font(mulishSemiBold600, sizePx: 20),
                  ),
                  SizedBox(height: style.scaleX(10)),
                  Text(
                    'Are you sure, you want to Logout?',
                    style: style.text.font(mulishRegular400, sizePx: 13),
                  ),
                  SizedBox(height: style.scaleX(37.5)),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: authP.isLoading
                              ? null
                              : () {
                                  if (context.canPop()) context.pop();
                                },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            textStyle: style.text.font(mulishSemiBold600, sizePx: 15),
                            padding: EdgeInsets.symmetric(vertical: style.scaleX(10)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: style.scaleX(21)),
                      Expanded(
                        child: FilledButton(
                          onPressed: authP.isLoading ? null : () => authP.logoutUser(),
                          style: FilledButton.styleFrom(
                            textStyle: style.text.font(mulishSemiBold600, sizePx: 15),
                            padding: EdgeInsets.symmetric(vertical: style.scaleX(10)),
                          ),
                          child: Text(authP.isLoading ? 'Logging out..' : 'Log out'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (authP.isLoading)
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: style.scaleX(10)),
                  constraints: BoxConstraints(maxHeight: style.scaleX(20), maxWidth: style.scaleX(20)),
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: style.scaleX(2),
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.green.shade900),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


void buyNow(BuildContext context,{required String categoryId}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (c) {
      Size size = MediaQuery.of(c).size;
      AppStyle style = AppStyle(screenSize: size);
      return ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.scaleX(10))),
          child: BuyNowDialog(style, categoryId),
        ),
      );
    },
  );
}

class BuyNowDialog extends ConsumerWidget {
  const BuyNowDialog(this.style, this.categoryId, {super.key});

  final AppStyle style;
  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dashboardP = ref.watch(dashboardProvider);
    return AbsorbPointer(
      absorbing: dashboardP.isPurchaseLoading,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: style.scaleX(330)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            style.scaleX(12.5),
            style.scaleX(26.5),
            style.scaleX(12.5),
            style.scaleX(18),
          ),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Upgrade for Full Access',
                    style: style.text.font(mulishSemiBold600, sizePx: 20),
                  ),
                  SizedBox(height: style.scaleX(10)),
                  Text(
                    'Upgrade for full access to exclusive videos and enjoy a premium viewing experience!',
                    textAlign: TextAlign.center,
                    style: style.text.font(mulishRegular400, sizePx: 13),
                  ),
                  SizedBox(height: style.scaleX(37.5)),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: dashboardP.isPurchaseLoading
                              ? null
                              : () {
                            if (context.canPop()) context.pop();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            textStyle: style.text.font(mulishSemiBold600, sizePx: 15),
                            padding: EdgeInsets.symmetric(vertical: style.scaleX(10)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: style.scaleX(21)),
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            // bool result = await dashboardP.purchaseCategory(categoryId);
                            // if (result) ref.read(paidVideosProvider).fetchVideos(int.parse(categoryId));
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UsePaypal(
                                clientId: 'AY6pLhhWX00Vac5a3WWDSq2E-uM24d-2r263Qo3a0FHvh755tEw5lh8tTkbTl24VB2vgceToCyqMqjLa',
                                secretKey: 'EHT63o9JrnCT_VJH1_OXHmJmZCGY_sYQShbMQAIHXbt0q9kqt2WFsUl6bLK1KutTrvDLnbrrtbIUmL0h',
                                cancelURL: 'https://samplesite.com/return',
                                returnURL: 'https://samplesite.com/cancel',
                                sandboxMode: true,
                                transactions: const [
                                  {
                                    "amount": {
                                      "total": 2,
                                      "currency": "AUD",
                                    },
                                    "description": "The payment transaction description.",
                                  }
                                ],
                                note: 'add wallet amount',
                                onCancel: (value) {
                                  debugPrint('ON Cancel :: $value');
                                },
                                onError: (value) {
                                  debugPrint('ON Error :: $value');
                                  context.pop();
                                  showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
                                },
                                onSuccess: (value) async {
                                  log('ON Success :: $value', name: 'On Success');
                                  bool result = await dashboardP.purchaseCategory(categoryId, value['paymentId']);
                                  if (result) ref.read(paidVideosProvider).fetchVideos(int.parse(categoryId));
                                },
                              ),
                            ));
                          },
                          style: FilledButton.styleFrom(
                            textStyle: style.text.font(mulishSemiBold600, sizePx: 15),
                            padding: EdgeInsets.symmetric(vertical: style.scaleX(10)),
                          ),
                          // child: Text(dashboardP.isPurchaseLoading ? 'Buying...' : 'Buy now'),
                          child: const Text('Buy now'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (dashboardP.isPurchaseLoading)
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: style.scaleX(10)),
                  constraints: BoxConstraints(maxHeight: style.scaleX(20), maxWidth: style.scaleX(20)),
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: style.scaleX(2),
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.green.shade900),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
