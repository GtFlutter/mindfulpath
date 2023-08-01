// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_auth_app_bar.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_header.dart';
import 'package:meditation_app/ui/common/custom_next_button.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/ui/screens/authentication/widget/password_text_field.dart';

import '../../../helper/route/route_paths.dart';
import '../../../theme/colors.dart';
import '../../../theme/styles.dart';
import '../../../util/constants.dart';

class CreateNewPasswordScreen extends ConsumerStatefulWidget {
  final String phoneNo;
  const CreateNewPasswordScreen({super.key, required this.phoneNo});

  @override
  ConsumerState<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends ConsumerState<CreateNewPasswordScreen> {
  static AppStyle _style = AppStyle();

  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  final FocusNode _pwdFocusNode = FocusNode();
  final FocusNode _cPwdFocusNode = FocusNode();

  String? _pwdErrorText;
  String? _cnfPwdErrorText;

  void setPwdError(String? error) {
    setState(() {
      _pwdErrorText = error;
    });
  }

  void setCnfPwdError(String? error) {
    setState(() {
      _cnfPwdErrorText = error;
    });
  }

  @override
  void dispose() {
    _pwdFocusNode.dispose();
    _cPwdFocusNode.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    _style = AppStyle(screenSize: size);
    var authP = ref.watch(authProvider);

    return AbsorbPointer(
      absorbing: authP.isLoading,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: CustomAuthAppBar(
          screenSize: size,
          style: _style,
          automaticallyImplyLeading: false,
        ),
        body: BackgroundImage(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Column(
                children: [
                  CustomHeader(
                    title: 'Create a new password',
                    subTitle: 'Your new password must be different from the previous password',
                    subTitleColor: AppColors.textFieldValueColor,
                    padding: EdgeInsets.symmetric(horizontal: _style.scale * 25),
                    style: _style,
                  ),
                  Expanded(
                    child: CustomScrollableColumnLayout(
                      minHeight: 250 * _style.scale,
                      style: _style,
                      children: [
                        Spacer(flex: 1),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PasswordTextField(
                              key: ValueKey('p1'),
                              focusNode: _pwdFocusNode,
                              controller: _passwordCtrl,
                              textInputAction: TextInputAction.next,
                              errorText: _pwdErrorText,
                              onChanged: (_) {
                                if (_pwdErrorText != null) {
                                  setPwdError(null);
                                }
                              },
                              onSubmitted: (_) {
                                _cPwdFocusNode.requestFocus();
                              },
                              style: _style,
                            ),
                            SizedBox(height: size.height * 0.05),
                            PasswordTextField(
                              key: ValueKey('p2'),
                              focusNode: _cPwdFocusNode,
                              textInputAction: TextInputAction.done,
                              controller: _confirmPasswordCtrl,
                              labelText: 'Confirm Password',
                              errorText: _cnfPwdErrorText,
                              onChanged: (_) {
                                if (_cnfPwdErrorText != null) {
                                  setCnfPwdError(null);
                                }
                              },
                              style: _style,
                            ),
                          ],
                        ),
                        Spacer(flex: 3),
                        CustomNextButton(
                          text: 'Next',
                          onPressed: !authP.isLoading ? onNext : null,
                          style: _style,
                          inProgress: authP.isLoading,
                        ),
                        SizedBox(height: _style.scale * 20),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void onNext() {
    String password = _passwordCtrl.text.trim();
    String confirmPassword = _confirmPasswordCtrl.text.trim();
    if (password.isEmpty) {
      setPwdError('Please enter a Password');
      return;
    } else if (confirmPassword.isEmpty) {
      setCnfPwdError('Please enter a Confirm Password');
      return;
    } else if (password.length < AppConstants.PWD_MIN_LENGTH) {
      setPwdError('Password must be atleast ${AppConstants.PWD_MIN_LENGTH} character');
      return;
    } else if (password.length > AppConstants.PWD_MAX_LENGTH) {
      setPwdError(
          'Password length must be between ${AppConstants.PWD_MIN_LENGTH}-${AppConstants.PWD_MAX_LENGTH} character...');
      return;
    } else if (password.contains(RegExp(r'\s'))) {
      setPwdError('Password should not contain space...');
      return;
    } else if (confirmPassword.length < AppConstants.PWD_MIN_LENGTH) {
      setCnfPwdError('Password must be atleast ${AppConstants.PWD_MIN_LENGTH} character');
      return;
    } else if (confirmPassword.length > AppConstants.PWD_MAX_LENGTH) {
      setCnfPwdError(
          'Password length must be between ${AppConstants.PWD_MIN_LENGTH}-${AppConstants.PWD_MAX_LENGTH} character...');
      return;
    } else if (confirmPassword.contains(RegExp(r'\s'))) {
      setCnfPwdError('Password should not contain space...');
      return;
    } else if (password != confirmPassword) {
      setCnfPwdError('Both password must match');
      return;
    } else if (widget.phoneNo.isEmpty) {
      showCustomSnackBar(AppConstants.WENT_WRONG);
      context.go(RoutePath.signIn);
    } else {
      ref.read(authProvider).resetPassword(widget.phoneNo, password);
    }
  }
}
