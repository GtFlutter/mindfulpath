// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/repositories/auth_repo.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_auth_app_bar.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_header.dart';
import 'package:meditation_app/ui/common/custom_next_button.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/ui/screens/authentication/widget/contact_number_text_field.dart';

import '../../../theme/colors.dart';
import '../../../theme/styles.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  static AppStyle _style = AppStyle();

  final TextEditingController _numberCtrl = TextEditingController();

  final String _initCountryCode = '+91';
  String _countryCode = '+91';

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
    _numberCtrl.dispose();
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
          leadingWidth: _style.scale * 65,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: _style.scale * 15),
                child: IconButton.outlined(
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
                        subTitle: 'Please enter your number to request a password reset.',
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
                        Spacer(flex: 1),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MobileNumberTextField(
                              onCountryCodeChanged: setCountryCode,
                              controller: _numberCtrl,
                              initialCountryCodeSelection: _initCountryCode,
                              errorText: _numberErrorText,
                              onChanged: (_) {
                                setNumberErrorText();
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
    String number = _numberCtrl.text.trim();
    String code = _countryCode;
    if (number.isEmpty) {
      setNumberErrorText('Please enter a number');
      return;
    } else if (code.isEmpty) {
      setNumberErrorText('Please select country code');
      return;
    } else {
      ref.read(authProvider).requestOTP(
            countryCode: code,
            phoneNo: number,
            type: SendOTP.forgotPwd,
          );
    }
  }
}
