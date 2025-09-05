import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/provider/change_password_provider.dart';
import 'package:meditation_app/theme/text_style.dart';

import '../../../../theme/styles.dart';
import '../../../../util/constants.dart';
import '../../../common/common_bottom_sheet_widget.dart';
import '../../authentication/widget/password_text_field.dart';

class ChnagePasswordSheet extends ConsumerStatefulWidget {
  const ChnagePasswordSheet({super.key});

  @override
  ConsumerState<ChnagePasswordSheet> createState() => _ChnagePasswordSheetState();
}

class _ChnagePasswordSheetState extends ConsumerState<ChnagePasswordSheet> {
  static AppStyle _style = AppStyle();

  final TextEditingController _oldPasswordCtrl = TextEditingController();
  final TextEditingController _newPasswordCtrl = TextEditingController();

  final FocusNode _oldPwdFocusNode = FocusNode();
  final FocusNode _newPwdFocusNode = FocusNode();

  @override
  void initState() {
    ref.read(changePasswordProvider).clearAllErrorText(notifie: false);
    super.initState();
  }

  @override
  void dispose() {
    _oldPwdFocusNode.dispose();
    _newPwdFocusNode.dispose();
    _oldPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    _style = AppStyle(screenSize: size);

    var provider = ref.watch(changePasswordProvider);
    provider.addListener(
      () => setState(() {}),
    );

    return AbsorbPointer(
      absorbing: provider.isLoading,
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: const Color(0xFF2D251F),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonBottomSheetWidget(
                style: _style,
                title: 'Change Password',
                doneLable: 'Save',
                onCancle: () {
                  if (provider.isLoading) return;
                  if (context.canPop()) {
                    context.pop();
                  }
                },
                onDone: provider.isLoading ? null : onSave,
              ),
              if (provider.isLoading)
                LinearProgressIndicator(
                  minHeight: _style.scaleX(1.5),
                  backgroundColor: Colors.transparent,
                ),
              if (provider.commonErrorText != null && provider.commonErrorText!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    provider.commonErrorText!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _style.text.font(mulishSemiBold600, sizePx: 13, color: Colors.red),
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(
                  left: _style.scaleX(25),
                  right: _style.scaleX(25),
                  bottom: 20,
                  top: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PasswordTextField(
                      key: const ValueKey('cps1'),
                      focusNode: _oldPwdFocusNode,
                      controller: _oldPasswordCtrl,
                      textInputAction: TextInputAction.next,
                      errorText: provider.oldPwdErrorText,
                      labelText: 'Old Password',
                      onChanged: (_) {
                        provider.setOldPwdError();
                      },
                      onSubmitted: (_) {
                        _newPwdFocusNode.requestFocus();
                      },
                      style: _style,
                    ),
                    SizedBox(height: _style.scaleX(30)),
                    PasswordTextField(
                      key: const ValueKey('cps2'),
                      focusNode: _newPwdFocusNode,
                      textInputAction: TextInputAction.done,
                      controller: _newPasswordCtrl,
                      labelText: 'New Password',
                      errorText: provider.newPwdErrorText,
                      onChanged: (_) {
                        provider.setNewPwdError();
                      },
                      style: _style,
                    ),
                    if (MediaQuery.of(context).viewInsets.bottom == 0) SizedBox(height: _style.scaleX(100)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSave() {
    FocusManager.instance.primaryFocus?.unfocus();

    String oldPassword = _oldPasswordCtrl.text.trim();
    String newPassword = _newPasswordCtrl.text.trim();

    ///old password validation
    if (oldPassword.isEmpty) {
      _oldPwdFocusNode.requestFocus();
      ref.read(changePasswordProvider).setOldPwdError(error: 'Please enter an Old Password');
    }  else if (oldPassword.length < AppConstants.PWD_MIN_LENGTH) {
      _oldPwdFocusNode.requestFocus();
      ref.read(changePasswordProvider).setOldPwdError(error: 'Password must be atleast ${AppConstants.PWD_MIN_LENGTH} character');
    } else if (oldPassword.length > AppConstants.PWD_MAX_LENGTH) {
      _oldPwdFocusNode.requestFocus();
      ref.read(changePasswordProvider).setOldPwdError(error: 'Password length must be between ${AppConstants.PWD_MIN_LENGTH}-${AppConstants.PWD_MAX_LENGTH} character...');
    } else if (oldPassword.contains(RegExp(r'\s'))) {
      _oldPwdFocusNode.requestFocus();
      ref.read(changePasswordProvider).setOldPwdError(error: 'Password should not contain space...');
    }

    ///new password validation
    if (newPassword.isEmpty) {
      _newPwdFocusNode.requestFocus();
      ref.read(changePasswordProvider).setNewPwdError(error: 'Please enter a new Password');
    } else if (newPassword.length < AppConstants.PWD_MIN_LENGTH) {
      _newPwdFocusNode.requestFocus();
      ref.read(changePasswordProvider).setNewPwdError(error: 'Password must be atleast ${AppConstants.PWD_MIN_LENGTH} character');
    } else if (newPassword.length > AppConstants.PWD_MAX_LENGTH) {
      _newPwdFocusNode.requestFocus();
      ref.read(changePasswordProvider).setNewPwdError(error: 'Password length must be between ${AppConstants.PWD_MIN_LENGTH}-${AppConstants.PWD_MAX_LENGTH} character...');
    } else if (newPassword.contains(RegExp(r'\s'))) {
      _newPwdFocusNode.requestFocus();
      ref.read(changePasswordProvider).setNewPwdError(error: 'Password should not contain space...');
    }
    if (newPassword == oldPassword && oldPassword.isNotEmpty && newPassword.isNotEmpty) {
      ref.read(changePasswordProvider).setNewPwdError(error: 'New password should not be same as old password');
    }
    if (newPassword.isNotEmpty && oldPassword.isNotEmpty) {
      ref.read(changePasswordProvider).changePassword(oldPassword, newPassword);
    }
  }
}
