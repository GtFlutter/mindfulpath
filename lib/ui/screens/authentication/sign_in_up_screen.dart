// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/main.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_field_style.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/ui/screens/authentication/widget/contact_number_text_field.dart';
import 'package:meditation_app/ui/screens/authentication/widget/password_text_field.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../helper/screen_paths.dart';
import 'widget/custom_country_code_picker.dart';
import '../../common/custom_next_button.dart';
import 'otp_verification_screen.dart';

class SignInUpScreen extends StatefulWidget {
  final bool isSignIn;
  const SignInUpScreen({super.key, required this.isSignIn});

  @override
  State<SignInUpScreen> createState() => _SignInUpScreenState();
}

class _SignInUpScreenState extends State<SignInUpScreen> {
  final TextEditingController _numberCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        title: Text(widget.isSignIn ? 'Sign in' : 'Sign up'),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: BackgroundImage(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: CustomScrollableColumnLayout(
              minHeight: 500 * $style.scale,
              children: [
                Spacer(flex: 2),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ContactNumberTextField(
                      onCountryCodeChanged: setCountryCode,
                      controller: _numberCtrl,
                      initialCountryCodeSelection: initCountryCode,
                    ),
                    SizedBox(height: size.height * 0.05),
                    PasswordTextField(
                      controller: _passwordCtrl,
                    ),
                    if (widget.isSignIn) ...[
                      SizedBox(height: size.height * 0.015),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CupertinoButton(
                          onPressed: () {
                            context.push(ScreenPaths.forgotPasswordScreen, extra: !widget.isSignIn);
                          },
                          padding: EdgeInsets.zero,
                          minSize: 10,
                          child: Text(
                            'Forgot Password ?',
                            style: $style.text.font(mulishSemiBold600, sizePx: 12, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: $style.scale * 20),
                    ] else ...[
                      SizedBox(height: size.height * 0.05),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          runSpacing: $style.scale * 8,
                          children: [
                            Text('By signing, you agree to Calm oasis',
                                style: $style.text.font(mulishSemiBold600, sizePx: 13, color: AppColors.tcppTextColor)),
                            CupertinoButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              minSize: 10,
                              child: Text(
                                ' Privacy Policy ',
                                style: $style.text.font(mulishRegular400, sizePx: 13, color: AppColors.tcppBtnColor),
                              ),
                            ),
                            Text('and',
                                style: $style.text.font(mulishSemiBold600, sizePx: 13, color: AppColors.tcppTextColor)),
                            CupertinoButton(
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                minSize: 10,
                                child: Text(
                                  ' Terms & Conditions',
                                  style: $style.text.font(mulishRegular400, sizePx: 13, color: AppColors.tcppBtnColor),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: $style.scale * 10),
                    ],
                  ],
                ),
                Spacer(flex: 2),
                Row(
                  children: [
                    Flexible(
                        child: Divider(
                      color: AppColors.dividerColor,
                      endIndent: $style.scale * 15,
                      indent: $style.scale * 15,
                    )),
                    Text(
                      'OR SIGN UP WITH',
                      style: $style.text.font(
                        mulishSemiBold600,
                        sizePx: 13,
                      ),
                    ),
                    Flexible(
                        child: Divider(
                      color: AppColors.dividerColor,
                      indent: $style.scale * 15,
                      endIndent: $style.scale * 15,
                    )),
                  ],
                ),
                // SizedBox(height: $style.scale * 28),
                SizedBox(height: size.height * 0.05),
                Row(
                  children: [
                    Spacer(),
                    IconButton.outlined(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        SvgPaths.googleLogo,
                        width: $style.scale * 36,
                        height: $style.scale * 36,
                      ),
                    ),
                    SizedBox(width: $style.scale * 40),
                    IconButton.outlined(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        SvgPaths.facebookLogo,
                        width: $style.scale * 36,
                        height: $style.scale * 36,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(flex: 2),
                CustomNextButton(
                  text: 'Next',
                  onPressed: () {
                    if (widget.isSignIn) {
                      context.push(ScreenPaths.signInUp, extra: !widget.isSignIn);
                    } else {
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
                            type: OtpVerificationType.signUp,
                          ),
                        );
                      }
                    }
                  },
                ),

                SizedBox(height: $style.scale * 20),
              ],
            ),
          )),
    );
  }
}
