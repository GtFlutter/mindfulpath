// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/screen_paths.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_header.dart';
import 'package:meditation_app/ui/common/custom_next_button.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:pinput/pinput.dart';

import '../../../theme/styles.dart';
import '../../../util/constants.dart';

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
  static AppStyle _style = AppStyle();
  final TextEditingController _pinController = TextEditingController();

  String? _pinErrorText;

  void setPinErrorText([String? error]) {
    setState(() => _pinErrorText = error);
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
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
                CustomHeader(
                  title: 'OTP has been sent to',
                  subTitle: '${widget.model.countryCode} ${widget.model.number.mask()}',
                  style: _style,
                ),
                Expanded(
                  child: CustomScrollableColumnLayout(
                    minHeight: 150 * _style.scale,
                    style: _style,
                    children: [
                      Spacer(flex: 1),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Pinput(
                            controller: _pinController,
                            errorTextStyle: _style.text.font(mulishRegular400, sizePx: 11, color: Colors.white),
                            errorText: _pinErrorText,
                            forceErrorState: true,
                            onChanged: (_) {
                              setPinErrorText();
                            },
                            defaultPinTheme: PinTheme(
                              width: _style.scale * 50,
                              height: _style.scale * 50,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.textFieldEnableBorderColor, width: _style.scale * 0.9),
                                shape: BoxShape.circle,
                              ),
                              textStyle: _style.text.font(mulishLight300, sizePx: 25, color: Colors.white),
                            ),
                            focusedPinTheme: PinTheme(
                              width: _style.scale * 50,
                              height: _style.scale * 50,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.textFieldEnableBorderColor, width: _style.scale * 0.9),
                                shape: BoxShape.circle,
                              ),
                              textStyle: _style.text.font(mulishLight300, sizePx: 25, color: Colors.white),
                            ),
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                          ),
                          SizedBox(height: _style.scale * 21.5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              runSpacing: _style.scale * 8,
                              children: [
                                Text('Didn\'t Receive the OTP?',
                                    style: _style.text.font(
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
                                    style: _style.text.font(mulishBold700, sizePx: 12, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: _style.scale * 10),
                        ],
                      ),
                      Spacer(flex: 3),
                      CustomNextButton(
                        text: 'Next',
                        onPressed: () {
                          String otp = _pinController.text.trim();
                          if (otp.isEmpty) {
                            setPinErrorText('Please enter an otp');
                            return;
                          } else if (otp.length < AppConstants.OTP_LENGTH) {
                            setPinErrorText('OTP must be atleast ${AppConstants.OTP_LENGTH} digit');
                            return;
                          } else {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('OTP Verified Successfully')),
                            );
                            if (widget.model.type == OtpVerificationType.forgotPassword) {
                              context.pop();
                              context.pop();
                              context.push(ScreenPaths.createNewPasswordScreen);
                            } else if (widget.model.type == OtpVerificationType.signUp) {
                              context.pop();
                              context.push(ScreenPaths.createNewProfileScreen);
                            } else {
                              context.go(ScreenPaths.splash);
                            }
                          }
                        },
                        style: _style,
                      ),
                      SizedBox(height: _style.scale * 20),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
