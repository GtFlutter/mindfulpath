// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/ui/screens/authentication/widget/contact_number_text_field.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_auth_app_bar.dart';
import 'package:meditation_app/ui/screens/authentication/widget/password_text_field.dart';
import 'package:meditation_app/util/assets.dart';
import 'package:meditation_app/util/constants.dart';

import '../../../helper/screen_paths.dart';
import '../../../theme/styles.dart';
import '../../common/custom_next_button.dart';
import 'otp_verification_screen.dart';

class SignInUpScreen extends StatefulWidget {
  final bool isSignIn;
  const SignInUpScreen({super.key, required this.isSignIn});

  @override
  State<SignInUpScreen> createState() => _SignInUpScreenState();
}

class _SignInUpScreenState extends State<SignInUpScreen> {
  static AppStyle _style = AppStyle();
  final TextEditingController _numberCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final FocusNode _pwdFocusNode = FocusNode();

  final String initCountryCode = '+91';
  String _countryCode = '+91';

  String? _numberErrorText;
  String? _pwdErrorText;

  void setCountryCode(String code) {
    if (code != _countryCode) {
      setState(() => _countryCode = code);
    }
  }

  void setNumberErrorText([String? error]) {
    setState(() => _numberErrorText = error);
  }

  void setPwdErrorText([String? error]) {
    setState(() => _pwdErrorText = error);
  }

  @override
  void dispose() {
    _pwdFocusNode.dispose();
    _numberCtrl.dispose();
    _passwordCtrl.dispose();
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
      appBar: CustomAuthAppBar(
        title: widget.isSignIn ? 'Sign in' : 'Sign up',
        centerTitle: false,
        automaticallyImplyLeading: false,
        screenSize: size,
        style: _style,
      ),
      body: BackgroundImage(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: CustomScrollableColumnLayout(
              minHeight: 440 * _style.scale,
              style: _style,
              children: [
                Spacer(flex: 2),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MobileNumberTextField(
                      onCountryCodeChanged: setCountryCode,
                      controller: _numberCtrl,
                      initialCountryCodeSelection: initCountryCode,
                      errorText: _numberErrorText,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) {
                        setNumberErrorText();
                      },
                      style: _style,
                    ),
                    SizedBox(height: size.height * 0.05),
                    PasswordTextField(
                      key: ValueKey('siusp1'),
                      focusNode: _pwdFocusNode,
                      controller: _passwordCtrl,
                      errorText: _pwdErrorText,
                      onChanged: (_) {
                        setPwdErrorText();
                      },
                      style: _style,
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
                            style: _style.text.font(mulishSemiBold600, sizePx: 12, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: _style.scale * 20),
                    ] else ...[
                      SizedBox(height: size.height * 0.05),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          runSpacing: _style.scale * 8,
                          children: [
                            Text('By signing, you agree to Calm oasis',
                                style: _style.text.font(mulishSemiBold600, sizePx: 13, color: AppColors.tcppTextColor)),
                            CupertinoButton(
                              onPressed: () {
                                context.push(ScreenPaths.tCPpScreen, extra: false);
                              },
                              padding: EdgeInsets.zero,
                              minSize: 10,
                              child: Text(
                                ' Privacy Policy ',
                                style: _style.text.font(mulishRegular400, sizePx: 13, color: AppColors.tcppBtnColor),
                              ),
                            ),
                            Text('and',
                                style: _style.text.font(mulishSemiBold600, sizePx: 13, color: AppColors.tcppTextColor)),
                            CupertinoButton(
                                onPressed: () {
                                  context.push(ScreenPaths.tCPpScreen, extra: true);
                                },
                                padding: EdgeInsets.zero,
                                minSize: 10,
                                child: Text(
                                  ' Terms & Conditions',
                                  style: _style.text.font(mulishRegular400, sizePx: 13, color: AppColors.tcppBtnColor),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: _style.scale * 10),
                    ],
                  ],
                ),
                Spacer(flex: 2),
                Row(
                  children: [
                    Flexible(
                        child: Divider(
                      color: AppColors.dividerColor,
                      endIndent: _style.scale * 15,
                      indent: _style.scale * 15,
                    )),
                    Text(
                      'OR SIGN UP WITH',
                      style: _style.text.font(
                        mulishSemiBold600,
                        sizePx: 13,
                      ),
                    ),
                    Flexible(
                        child: Divider(
                      color: AppColors.dividerColor,
                      indent: _style.scale * 15,
                      endIndent: _style.scale * 15,
                    )),
                  ],
                ),
                // SizedBox(height: _style.scale * 28),
                SizedBox(height: size.height * 0.05),
                Row(
                  children: [
                    Spacer(),
                    IconButton.outlined(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        SvgPaths.googleLogo,
                        width: _style.scale * 36,
                        height: _style.scale * 36,
                      ),
                    ),
                    SizedBox(width: _style.scale * 40),
                    IconButton.outlined(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        SvgPaths.facebookLogo,
                        width: _style.scale * 36,
                        height: _style.scale * 36,
                      ),
                    ),
                    ...[
                      SizedBox(width: _style.scale * 40),
                      TextButton(
                        onPressed: () {
                          context.go(ScreenPaths.signInUp, extra: !widget.isSignIn);
                        },
                        child: Text(widget.isSignIn ? 'Sign Up' : 'Sign In'),
                      ),
                    ],
                    Spacer(),
                  ],
                ),
                Spacer(flex: 2),
                CustomNextButton(
                  text: 'Next',
                  onPressed: () {
                    String number = _numberCtrl.text.trim();
                    String code = _countryCode.trim();
                    String password = _passwordCtrl.text.trim();
                    if (number.isEmpty) {
                      setNumberErrorText('Please enter a number');
                      return;
                    } else if (code.isEmpty) {
                      setNumberErrorText('Please select country code');
                      return;
                    } else if (password.isEmpty) {
                      setPwdErrorText('Please enter a password');
                      return;
                    }

                    /// This is For Sign Up
                    else if (!widget.isSignIn && password.length < AppConstants.PWD_MIN_LENGTH) {
                      setPwdErrorText('Password must be atleast ${AppConstants.PWD_MIN_LENGTH} character');
                      return;
                    }

                    /// TODO IF this is sign then get error from api and show
                    else if (widget.isSignIn) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login Successfully')),
                      );
                      context.go(ScreenPaths.discoverScreen);
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
                  },
                  style: _style,
                ),

                SizedBox(height: _style.scale * 20),
              ],
            ),
          )),
    );
  }
}
