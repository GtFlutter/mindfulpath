// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/screen_paths.dart';
import 'package:meditation_app/main.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';
import 'package:meditation_app/ui/common/custom_next_button.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/util/string_extension.dart';
import 'package:pinput/pinput.dart';

enum OtpVerificationType {
  signIn,
  signUp,
  forgotPassword,
}

class TempOtpModel {
  final String countryCode;
  final String number;
  final OtpVerificationType type;

  TempOtpModel({required this.type, required this.countryCode, required this.number});
}

class OtpVerificationScreen extends StatefulWidget {
  final TempOtpModel model;
  const OtpVerificationScreen({super.key, required this.model});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: BackgroundImage(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: 'OTP has been sent to',
                  subTitle: '${widget.model.countryCode} ${widget.model.number.mask()}',
                ),
                Expanded(
                  child: CustomScrollableColumnLayout(
                    minHeight: 150 * $style.scale,
                    children: [
                      Spacer(flex: 1),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Pinput(
                            controller: _pinController,
                            defaultPinTheme: PinTheme(
                              width: $style.scale * 50,
                              height: $style.scale * 50,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.textFieldEnableBorderColor, width: $style.scale * 0.9),
                                shape: BoxShape.circle,
                              ),
                              textStyle: $style.text.font(mulishLight300, sizePx: 25, color: Colors.white),
                            ),
                            focusedPinTheme: PinTheme(
                              width: $style.scale * 50,
                              height: $style.scale * 50,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.textFieldEnableBorderColor, width: $style.scale * 0.9),
                                shape: BoxShape.circle,
                              ),
                              textStyle: $style.text.font(mulishLight300, sizePx: 25, color: Colors.white),
                            ),
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                          ),
                          SizedBox(height: $style.scale * 21.5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              runSpacing: $style.scale * 8,
                              children: [
                                Text('Didn\'t Receive the OTP?',
                                    style: $style.text.font(
                                      mulishMedium500,
                                      sizePx: 12,
                                      color: AppColors.otpMsgTextColor,
                                    )),
                                CupertinoButton(
                                  onPressed: () {},
                                  padding: EdgeInsets.zero,
                                  minSize: 10,
                                  child: Text(
                                    '  RESEND ',
                                    style: $style.text.font(mulishBold700, sizePx: 12, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: $style.scale * 10),
                        ],
                      ),
                      Spacer(flex: 3),
                      CustomNextButton(
                        text: 'Next',
                        onPressed: () {
                          String otp = _pinController.text.trim();
                          if (otp.isEmpty || otp.length < 4) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter a otp')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('OTP Verified')),
                            );
                            if (widget.model.type == OtpVerificationType.forgotPassword) {
                              context.pop();
                              context.pop();
                              context.go(ScreenPaths.createNewPasswordScreen);
                            } else {
                              context.go(ScreenPaths.splash);
                            }
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
