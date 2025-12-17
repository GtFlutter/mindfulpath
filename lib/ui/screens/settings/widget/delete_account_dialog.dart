import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/payment/payment_screen.dart';
import 'package:meditation_app/provider/dashboard_provider.dart';
import 'package:meditation_app/provider/resource_provider/paid_audios_provider.dart';
import 'package:meditation_app/provider/resource_provider/paid_videos_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/util/constants.dart';

import '../../../../provider/auth_provider.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../search/util/query_time.dart';

class DeleteAccountDialog extends ConsumerWidget {
  const DeleteAccountDialog(this.style, {super.key});

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
                    'Delete Account',
                    style: style.text.font(mulishSemiBold600, sizePx: 20),
                  ),
                  SizedBox(height: style.scaleX(10)),
                  Text(
                    'Are you sure, you want to delete your Account?',
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
                          onPressed: authP.isLoading ? null : () => authP.deleteAccount(),
                          style: FilledButton.styleFrom(
                            textStyle: style.text.font(mulishSemiBold600, sizePx: 15),
                            padding: EdgeInsets.symmetric(vertical: style.scaleX(10)),
                          ),
                          child: Text(authP.isLoading ? 'Deleting...' : 'Delete'),
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

