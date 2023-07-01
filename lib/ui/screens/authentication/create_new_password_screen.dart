// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/main.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';
import 'package:meditation_app/ui/common/custom_next_button.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/ui/screens/authentication/widget/password_text_field.dart';

import '../../../helper/screen_paths.dart';
import '../../../theme/colors.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  String? _pwdErrorText;
  String? _cnfPwdErrorText;

  void setPwdError(String? error) {
    setState(() {
      _pwdErrorText = error;
    });
  }

  void setCnfPwdError(String? error) {
    setState(() {
      _cnfPwdErrorText = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(),
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
                      title: 'Create a new password',
                      subTitle: 'Your new password must be different from the previous password',
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
                          PasswordTextField(
                            key: ValueKey('np'),
                            controller: _passwordCtrl,
                            errorText: _pwdErrorText,
                            onChanged: (value) {
                              if (_pwdErrorText != null) {
                                setPwdError(null);
                              }
                            },
                          ),
                          SizedBox(height: size.height * 0.05),
                          PasswordTextField(
                            key: ValueKey('cnp'),
                            controller: _confirmPasswordCtrl,
                            errorText: _cnfPwdErrorText,
                            onChanged: (value) {
                              if (_cnfPwdErrorText != null) {
                                setCnfPwdError(null);
                              }
                            },
                          ),
                        ],
                      ),
                      Spacer(flex: 3),
                      CustomNextButton(
                        text: 'Next',
                        onPressed: () {
                          String password = _passwordCtrl.text.trim();
                          String confirmPassword = _confirmPasswordCtrl.text.trim();
                          if (password.isEmpty || password.length < 8) {
                            setPwdError('Password must be atleast 8 character');
                            return;
                          } else if (confirmPassword.isEmpty || confirmPassword.length < 8) {
                            setCnfPwdError('Password must be atleast 8 character');
                            return;
                          } else if (password != confirmPassword) {
                            setCnfPwdError('Both password must match');
                            return;
                          } else {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Password Changed Successfully')),
                            );
                            context.go(ScreenPaths.splash);
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
