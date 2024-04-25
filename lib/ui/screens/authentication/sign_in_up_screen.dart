// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/repositories/auth_repo.dart';
import 'package:meditation_app/notification_services.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/ui/screens/authentication/widget/contact_number_text_field.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_auth_app_bar.dart';
import 'package:meditation_app/ui/screens/authentication/widget/password_text_field.dart';
import 'package:meditation_app/util/assets.dart';
import 'package:meditation_app/util/constants.dart';
import 'package:meditation_app/util/dimensions.dart';

import '../../../helper/route/route_paths.dart';
import '../../../theme/styles.dart';
import '../../common/custom_next_button.dart';

class SignInUpScreen extends ConsumerStatefulWidget {
  final bool isSignIn;
  const SignInUpScreen({super.key, required this.isSignIn});

  @override
  ConsumerState<SignInUpScreen> createState() => _SignInUpScreenState();
}

class _SignInUpScreenState extends ConsumerState<SignInUpScreen> {
  static AppStyle _style = AppStyle();
  final TextEditingController _numberCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final FocusNode _pwdFocusNode = FocusNode();

  final String initCountryCode = '+91';
  String _countryCode = '+91';
  String? fcm;

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
  void initState() {
    Future.delayed(Duration.zero, () {
      getFirebaseNotification();
    });
    super.initState();
  }

  getFirebaseNotification() async {
    NotificationServices notificationServices = NotificationServices();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    await notificationServices.forgroundMessage();
    await notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value) {
      print("device token");
      print(value);
      fcm = value;
    });
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
    Orientation orientation = MediaQuery.orientationOf(context);
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    var authP = ref.watch(authProvider);
    return AbsorbPointer(
      absorbing: authP.isLoading,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: orientation == Orientation.landscape,
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
                minHeight: _style.scaleX(500),
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
                              context.push(RoutePath.forgotPasswordScreen, extra: !widget.isSignIn);
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
                                  style:
                                      _style.text.font(mulishSemiBold600, sizePx: 13, color: AppColors.tcppTextColor)),
                              CupertinoButton(
                                onPressed: () {
                                  context.push(RoutePath.tCPpScreen, extra: false);
                                },
                                padding: EdgeInsets.zero,
                                minSize: 10,
                                child: Text(
                                  ' Privacy Policy ',
                                  style: _style.text.font(mulishRegular400, sizePx: 13, color: AppColors.tcppBtnColor),
                                ),
                              ),
                              Text('and',
                                  style:
                                      _style.text.font(mulishSemiBold600, sizePx: 13, color: AppColors.tcppTextColor)),
                              CupertinoButton(
                                  onPressed: () {
                                    context.push(RoutePath.tCPpScreen, extra: true);
                                  },
                                  padding: EdgeInsets.zero,
                                  minSize: 10,
                                  child: Text(
                                    ' Terms & Conditions',
                                    style:
                                        _style.text.font(mulishRegular400, sizePx: 13, color: AppColors.tcppBtnColor),
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
                        onPressed: (){
                          ref.read(authProvider).googleLogin();
                        },
                        icon: SvgPicture.asset(
                          SvgPaths.googleLogo,
                          width: _style.scale * 36,
                          height: _style.scale * 36,
                        ),
                      ),
                      SizedBox(width: _style.scale * 40),
                      IconButton.outlined(
                        onPressed: onFacebookLogin,
                        icon: SvgPicture.asset(
                          SvgPaths.facebookLogo,
                          width: _style.scale * 36,
                          height: _style.scale * 36,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Spacer(flex: 2),
                  // Don't have an account? Sign up
                  Text.rich(
                    TextSpan(
                      text: '${widget.isSignIn ? 'Don\'t' : 'Already'} have an account?',
                      style: _style.text.font(mulishRegular400, sizePx: 13, color: AppColors.tcppTextColor),
                      children: [
                        TextSpan(
                            text: widget.isSignIn ? ' Sign Up' : ' Sign In ',
                            recognizer: TapGestureRecognizer()..onTap = onSign,
                            style: _style.text.font(mulishSemiBold600, sizePx: 13, color: AppColors.primaryColor)),
                      ],
                    ),
                  ),
                  SizedBox(height: _style.scaleX(Dimensions.PADDING_SIZE_DEFAULT)),
                  CustomNextButton(
                    text: widget.isSignIn ? 'Sign In' : 'Next',
                    onPressed: !authP.isLoading ? onNext : null,
                    style: _style,
                    inProgress: authP.isLoading,
                  ),

                  SizedBox(height: _style.scale * 20),
                ],
              ),
            )),
      ),
    );
  }

  void onNext() {
    String number = _numberCtrl.text.trim();
    String code = _countryCode.trim();
    String password = _passwordCtrl.text.trim();
    if (number.isEmpty) {
      setNumberErrorText('Please Enter Your Number');
      return;
    } else if (code.isEmpty) {
      setNumberErrorText('Please Select Your Country Code');
      return;
    } else if (password.isEmpty) {
      setPwdErrorText('Please Enter Your Password');
      return;
    } else if (password.length < AppConstants.PWD_MIN_LENGTH) {
      if (widget.isSignIn) {
        setPwdErrorText('Invalid Password');
      } else {
        setPwdErrorText('Password must be at least ${AppConstants.PWD_MIN_LENGTH} character');
      }
      return;
    } else if (password.length > AppConstants.PWD_MAX_LENGTH) {
      setPwdErrorText(
          'Password length must be between ${AppConstants.PWD_MIN_LENGTH}-${AppConstants.PWD_MAX_LENGTH} character...');
      return;
    } else if (!widget.isSignIn && password.contains(RegExp(r'\s'))) {
      setPwdErrorText('Password should not contain space...');
      return;
    }

    /// TODO IF this is sign then get error from api and show
    else if (widget.isSignIn) {
      ref.read(authProvider).loginUser(code + number, password,fcm??"");
    } else {
      ref.read(authProvider).requestOTP(
            countryCode: code,
            phoneNo: number,
            type: SendOTP.register,
            password: password,
          );
    }
  }

  void onSign() {
    context.go(widget.isSignIn ? RoutePath.signUp : RoutePath.signIn);
  }

  void onGoogleLogin() {}

  void onFacebookLogin() {}
}
