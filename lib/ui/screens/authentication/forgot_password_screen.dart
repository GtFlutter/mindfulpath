// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/main.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_auth_app_bar.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_header.dart';
import 'package:meditation_app/ui/common/custom_next_button.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/ui/screens/authentication/widget/contact_number_text_field.dart';

import '../../../helper/screen_paths.dart';
import '../../../theme/colors.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: CustomAuthAppBar(
        leadingWidth: $style.scale * 65,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: $style.scale * 15),
              child: IconButton.outlined(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                iconSize: $style.scale * 15,
                constraints: BoxConstraints(maxWidth: $style.scale * 30, maxHeight: $style.scale * 30),
              ),
            ),
          ],
        ),
        screenSize: size,
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
                      padding: EdgeInsets.symmetric(horizontal: $style.scale * 25),
                    ),
                  ],
                ),
                Expanded(
                  child: CustomScrollableColumnLayout(
                    minHeight: 200 * $style.scale,
                    children: [
                      Spacer(flex: 1),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MobileNumberTextField(
                            onCountryCodeChanged: setCountryCode,
                            controller: _numberCtrl,
                            initialCountryCodeSelection: _initCountryCode,
                          ),
                        ],
                      ),
                      Spacer(flex: 3),
                      CustomNextButton(
                        text: 'Next',
                        onPressed: () {
                          String number = _numberCtrl.text.trim();
                          String code = _countryCode;
                          if (number.isEmpty) {
                            setNumberErrorText('Please enter a number');
                            return;
                          } else if (code.isEmpty) {
                            setNumberErrorText('Please select country code');
                            return;
                          } else {
                            context.push(
                              ScreenPaths.otpVerificationScreen,
                              extra: TempOtpModel(
                                countryCode: code,
                                number: number,
                                type: OtpVerificationType.forgotPassword,
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: $style.scale * 20),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
