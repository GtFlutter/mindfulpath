// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/main.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_field_style.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/util/assets.dart';

class SignInUpScreen extends StatefulWidget {
  const SignInUpScreen({super.key});

  @override
  State<SignInUpScreen> createState() => _SignInUpScreenState();
}

class _SignInUpScreenState extends State<SignInUpScreen> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: BackgroundImage(
          // alignment: AlignmentDirectional.center,
          child: SafeArea(
        child: SingleChildScrollView(
          // physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: size.height > 700 ? size.height * 0.15 : size.height * 0.05),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    cursorColor: CustomeTextFieldStyle.cursorColor,
                    decoration: CustomeTextFieldStyle.inputDecoration().copyWith(
                      labelText: 'Number',
                    ),
                    keyboardType: TextInputType.phone,
                    style: CustomeTextFieldStyle.valueStyle(),
                  ),
                  // SizedBox(height: $style.scale * 48.5),
                  SizedBox(height: size.height * 0.05),
                  TextField(
                    cursorColor: CustomeTextFieldStyle.cursorColor,
                    decoration: CustomeTextFieldStyle.inputDecoration().copyWith(
                      labelText: 'Password',
                      suffix: MaterialButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: SvgPicture.asset(
                          _obscureText ? SvgPaths.passwordHide : SvgPaths.passwordVisible,
                          width: $style.scale * 20,
                          height: $style.scale * 20,
                        ),
                        shape: CircleBorder(),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minWidth: $style.scale * 30,
                      ),
                    ),
                    style: CustomeTextFieldStyle.valueStyle(spacingPc: 50),
                    obscureText: _obscureText,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  // SizedBox(height: $style.scale * 52),
                  SizedBox(height: size.height * 0.05),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      runSpacing: $style.scale * 8,
                      children: [
                        Text('By signing, you agree to Calm oasis ',
                            style: $style.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.tcppTextColor)),
                        CupertinoButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          minSize: 10,
                          child: Text(
                            'Privacy Policy',
                            style: $style.text.font(mulishRegular400, sizePx: 12, color: AppColors.tcppBtnColor),
                          ),
                        ),
                        Text(' and ',
                            style: $style.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.tcppTextColor)),
                        CupertinoButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            minSize: 10,
                            child: Text(
                              'Terms & Conditions',
                              style: $style.text.font(mulishRegular400, sizePx: 12, color: AppColors.tcppBtnColor),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: $style.scale * 10),
                ],
              ),
              SizedBox(height: size.height > 700 ? size.height * 0.15 : size.height * 0.05),
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
                      sizePx: 12,
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
              SizedBox(height: size.height * 0.04),
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
              // SizedBox(height: $style.scale * 55),
              SizedBox(height: size.height * 0.05),
              SizedBox(
                width: size.width * 0.55,
                child: FilledButton(
                  onPressed: () {},
                  child: Text('Next'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.fieldButtonBgColor,
                    textStyle: $style.text.font(mulishBold700, sizePx: 15),
                  ),
                ),
              ),
              // SizedBox(height: $style.scale * 20),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      )),
    );
  }
}
