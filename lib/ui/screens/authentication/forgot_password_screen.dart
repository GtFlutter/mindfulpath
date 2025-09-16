// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/repositories/auth_repo.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_next_button.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/ui/screens/authentication/widget/contact_number_text_field.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_auth_app_bar.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_header.dart';

import '../../../provider/user_provider.dart';
import '../../../theme/colors.dart';
import '../../../theme/styles.dart';
import '../../../theme/text_field_style.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  static AppStyle _style = AppStyle();

  final TextEditingController _emailCtrl = TextEditingController();

  final String _initCountryCode = '+1';
  String _countryCode = '+1';

  String? _numberErrorText;

  void setCountryCode(String code) {
    if (code != _countryCode) {
      setState(() {
        _countryCode = code;
      });
    }
  }

  void setNumberErrorText([String? error]) {
    setState(() => _numberErrorText = error);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    var userP = ref.watch(userProvider);
    var authP = ref.watch(authProvider);

    return AbsorbPointer(
      absorbing: authP.isLoading,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: CustomAuthAppBar(
          leadingWidth: _style.scale * 72,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: _style.scale * 15),
                child: IconButton.outlined(
                  padding: EdgeInsets.all(5),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  iconSize: _style.scale * 15,
                  constraints: BoxConstraints(maxWidth: _style.scale * 30, maxHeight: _style.scale * 30),
                ),
              ),
            ],
          ),
          screenSize: size,
          style: _style,
        ),
        body: BackgroundImage(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomHeader(
                        title: 'Forgot password',
                        subTitle: 'Please enter your Email to request a password reset.',
                        subTitleColor: AppColors.textFieldValueColor,
                        padding: EdgeInsets.symmetric(horizontal: _style.scale * 25),
                        style: _style,
                      ),
                    ],
                  ),
                  Expanded(
                    child: CustomScrollableColumnLayout(
                      minHeight: 200 * _style.scale,
                      style: _style,
                      children: [
                        SizedBox(height: _style.scale * 100),
                        // Spacer(flex: 1),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // MobileNumberTextField(
                            //   textInputAction: TextInputAction.done,
                            //   onCountryCodeChanged: setCountryCode,
                            //   controller: _numberCtrl,
                            //   initialCountryCodeSelection: _initCountryCode,
                            //   errorText: _numberErrorText,
                            //   onChanged: (_) {
                            //     setNumberErrorText();
                            //   },
                            //   onTap: () {},
                            //   style: _style,
                            // ),
                            TextField(
                              controller: _emailCtrl,
                              readOnly: ref.read(authProvider).socialUserData?.socialId?.isNotEmpty ?? false,
                              cursorColor: CustomeTextFieldStyle.cursorColor,
                              onChanged: (_) {
                                userP.setEmailError();
                              },
                              textInputAction: TextInputAction.done,
                              decoration: CustomeTextFieldStyle.inputDecoration(style: _style).copyWith(
                                labelText: 'Email',
                                errorText: userP.emailErrorText,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: CustomeTextFieldStyle.valueStyle(style: _style),
                            ),
                          ],
                        ),
                        // Spacer(flex: 3),
                        SizedBox(height: _style.scale * 30),
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
    FocusManager.instance.primaryFocus?.unfocus();
    String email = _emailCtrl.text.trim();
    String code = _countryCode;
     if (email.isEmpty) {
    ref.read(userProvider).setEmailError(error: 'Please enter an email');
    return;
    } else if (!email.isEmail) {
    ref.read(userProvider).setEmailError(error: 'Invalid email');
    return;
    }  else {
      ref.read(authProvider).requestOTP(
           email: _emailCtrl.text.trim(),
            type: SendOTP.forgotPwd,
          );
    }
  }
}
