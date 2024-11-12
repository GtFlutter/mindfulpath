// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/repositories/auth_repo.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_next_button.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_header.dart';
import 'package:pinput/pinput.dart';

import '../../../provider/auth_provider.dart';
import '../../../theme/styles.dart';
import '../../../util/constants.dart';

class OTPModel {
  final String countryCode;
  final String phoneNo;
  final SendOTP type;
  final String? password;
  final int otp;

  OTPModel({
    required this.otp,
    required this.type,
    required this.countryCode,
    required this.phoneNo,
    this.password,
  });
}

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final OTPModel model;
  OtpVerificationScreen({super.key, required this.model})
      : assert(!(model.type == SendOTP.register && model.password == null));

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
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

    var authP = ref.watch(authProvider);

    return AbsorbPointer(
      absorbing: authP.isLoading,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // resizeToAvoidBottomInset: false,
        extendBody: true,
        body: BackgroundImage(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomHeader(
                    title: 'OTP has been sent to ${widget.model.otp}',
                    subTitle: '${widget.model.countryCode} ${widget.model.phoneNo.mask()}',
                    style: _style,
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
                                  border: Border.all(
                                      color: AppColors.textFieldEnableBorderColor, width: _style.scale * 0.9),
                                  shape: BoxShape.circle,
                                ),
                                textStyle: _style.text.font(mulishLight300, sizePx: 25, color: Colors.white),
                              ),
                              focusedPinTheme: PinTheme(
                                width: _style.scale * 50,
                                height: _style.scale * 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.textFieldEnableBorderColor, width: _style.scale * 0.9),
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
                                    onPressed: () {
                                      ref.read(authProvider).requestOTP(
                                            countryCode: widget.model.countryCode,
                                            phoneNo: widget.model.phoneNo,
                                            type: widget.model.type,
                                            password: widget.model.password,
                                            shouldReplace: true,
                                          );
                                    },
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
    String otp = _pinController.text.trim();
    if (otp.isEmpty) {
      setPinErrorText('Please Enter Your OTP');
      return;
    } else if (otp.length < AppConstants.OTP_LENGTH) {
      setPinErrorText('OTP must be at least ${AppConstants.OTP_LENGTH} digit');
      return;
    } else {
      ref.read(authProvider).verifyOTP(
            countryCode: widget.model.countryCode,
            phoneNo: widget.model.phoneNo,
            type: widget.model.type,
            otp: int.parse(otp),
            password: widget.model.password,
          );
    }
  }
}
