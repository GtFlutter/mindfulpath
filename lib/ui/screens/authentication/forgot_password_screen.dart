// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/main.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';
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

  final String initCountryCode = '+91';
  String _countryCode = '+91';

  void setCountryCode(String code) {
    if (code != _countryCode) {
      setState(() {
        _countryCode = code;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
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
                    CustomAppBar(
                      title: 'Forgot password',
                      subTitle: 'Please enter your number to request a password reset.',
                      subTitleColor: AppColors.textFieldValueColor,
                      padding: EdgeInsets.symmetric(horizontal: $style.scale * 25),
                    ),
                  ],
                ),
                Expanded(
                  child: CustomScrollableColumnLayout(
                    // testScreenHeight: 100,
                    minHeight: 250 * $style.scale,
                    children: [
                      Spacer(flex: 1),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ContactNumberTextField(
                            onCountryCodeChanged: setCountryCode,
                            controller: _numberCtrl,
                            initialCountryCodeSelection: initCountryCode,
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
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter a number')),
                            );
                          } else if (code.isEmpty) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select country code')),
                            );
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
