// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/model/body/user_body.dart';
import 'package:meditation_app/helper/date_converter.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/notification_services.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/provider/user_provider.dart';
import 'package:meditation_app/ui/common/adaptive_date_picker.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_next_button.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_auth_app_bar.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_header.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../theme/styles.dart';
import '../../../theme/text_field_style.dart';
import '../../../util/constants.dart';

class CreateProfileScreen extends ConsumerStatefulWidget {
   String? phoneNo;
   String? password;

  /// First Variable [PhoneNo] and Second Variable [Password]
  CreateProfileScreen({
    super.key,
     (String, String)? value,
  })  : phoneNo = value?.$1 ?? "",
        password = value?.$2 ?? "";

  @override
  ConsumerState<CreateProfileScreen> createState() =>
      _CreateNewProfileScreenState();
}

class _CreateNewProfileScreenState extends ConsumerState<CreateProfileScreen> {
  static AppStyle _style = AppStyle();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  DateTime? _dateOfBirth;
  String? _gender;
  String? fcm;

  final List<String> _genderList =
      List.unmodifiable(['Male', 'Female', 'Other']);

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref.read(userProvider).clearAllErrorText(notifie: false);
      final socialUserData = ref.read(authProvider).socialUserData;
      if(socialUserData!=null){
        print("callleeddddd social data");
        _nameCtrl.text=socialUserData.userName ?? "";
        _emailCtrl.text=socialUserData.mobileOrEmail ?? "";
      }
      getFirebaseNotification();
    });
    super.initState();
  }

  getFirebaseNotification() async {
    NotificationServices notificationServices = NotificationServices();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    await notificationServices.forgroundMessage();
    await notificationServices.setupInteractMessage();
    notificationServices.getDeviceToken().then((value) {
      print("device token");
      print(value);
      fcm = value;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _dateCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    var userP = ref.watch(userProvider);

    return AbsorbPointer(
      absorbing: userP.isLoading,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: CustomAuthAppBar(
          surfaceTintColor: Colors.transparent,
          screenSize: size,
          style: _style,
          automaticallyImplyLeading: false,
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
                        title: 'Create a new profile',
                        padding: EdgeInsets.only(
                          left: _style.scale * 25,
                          right: _style.scale * 25,
                          bottom: _style.scale * 5,
                        ),
                        style: _style,
                      ),
                    ],
                  ),
                  Expanded(
                    child: CustomScrollableColumnLayout(
                      minHeight: 400 * _style.scale,
                      style: _style,
                      children: [
                        Spacer(flex: 1),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _nameCtrl,
                              cursorColor: CustomeTextFieldStyle.cursorColor,
                              onChanged: (_) {
                                userP.setNameError();
                              },
                              textInputAction: TextInputAction.next,
                              decoration: CustomeTextFieldStyle.inputDecoration(
                                      style: _style)
                                  .copyWith(
                                labelText: 'Full name',
                                errorText: userP.nameErrorText,
                              ),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              style: CustomeTextFieldStyle.valueStyle(
                                  style: _style),
                            ),
                            SizedBox(height: _style.scale * 27.5),
                            TextField(
                              controller: _emailCtrl,
                              cursorColor: CustomeTextFieldStyle.cursorColor,
                              onChanged: (_) {
                                userP.setEmailError();
                              },
                              textInputAction: TextInputAction.done,
                              decoration: CustomeTextFieldStyle.inputDecoration(
                                      style: _style)
                                  .copyWith(
                                labelText: 'Email',
                                errorText: userP.emailErrorText,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: CustomeTextFieldStyle.valueStyle(
                                  style: _style),
                            ),
                            SizedBox(height: _style.scale * 27.5),
                            TextField(
                              controller: _dateCtrl,
                              readOnly: true,
                              canRequestFocus: false,
                              onTap: selectDate,
                              decoration: CustomeTextFieldStyle.inputDecoration(
                                      style: _style)
                                  .copyWith(
                                labelText: 'Date of birth',
                                errorText: userP.dateErrorText,
                                suffixIcon: Padding(
                                  padding:
                                      EdgeInsets.only(right: _style.scale * 25),
                                  child: SvgPicture.asset(SvgPaths.calendar),
                                ),
                                suffixIconConstraints: BoxConstraints(
                                  maxWidth:
                                      (_style.scale * 20) + (_style.scale * 25),
                                  maxHeight: _style.scale * 20,
                                ),
                              ),
                              style: CustomeTextFieldStyle.valueStyle(
                                  style: _style),
                            ),
                            SizedBox(height: _style.scale * 27.5),
                            DropdownButtonFormField(
                              value: _gender,
                              style: CustomeTextFieldStyle.valueStyle(
                                  style: _style),
                              borderRadius:
                                  BorderRadius.circular(_style.scale * 10),
                              dropdownColor: Color.fromARGB(255, 93, 53, 20),
                              decoration: CustomeTextFieldStyle.inputDecoration(
                                      style: _style)
                                  .copyWith(
                                errorText: userP.genderErrorText,
                                labelText: 'Gender',
                              ),
                              icon: SvgPicture.asset(SvgPaths.arrowDown),
                              iconSize: _style.scale * 20,
                              items: List.generate(_genderList.length, (index) {
                                return DropdownMenuItem(
                                  child: Text(_genderList[index]),
                                  value: _genderList[index],
                                );
                              }).toList(),
                              onChanged: (value) {
                                userP.setGenderError();
                                setState(() {
                                  _gender = value;
                                });
                              },
                            )
                          ],
                        ),
                        Spacer(flex: 3),
                        CustomNextButton(
                          text: 'Next',
                          onPressed: !userP.isLoading ? onNext : null,
                          style: _style,
                          inProgress: userP.isLoading,
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
    String name = _nameCtrl.text.trim();
    String email = _emailCtrl.text.trim();
    DateTime? dateOfBirth = _dateOfBirth;
    String? gender;
    if (_gender == null) {
      gender = null;
    } else {
      gender = _gender!.trim();
    }
    String phoneNo = widget.phoneNo?.trim() ?? "";
    String password = widget.password?.trim() ?? "";

    // if (phoneNo.isEmpty ||
    //     password.isEmpty ||
    //     password.contains(RegExp(r'\s')) ||
    //     password.length < AppConstants.PWD_MIN_LENGTH ||
    //     password.length > AppConstants.PWD_MAX_LENGTH) {
    //   showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
    //   if (context.canPop()) {
    //     context.pop();
    //   }
    //   return;
    // }
    if ((ref.read(authProvider).socialUserData?.socialId?.isEmpty ?? false) &&(phoneNo.isEmpty ||
        password.isEmpty ||
        password.contains(RegExp(r'\s')) ||
        password.length < AppConstants.PWD_MIN_LENGTH ||
        password.length > AppConstants.PWD_MAX_LENGTH)) {
      showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
      if (context.canPop()) {
        context.pop();
      }
      return;
    }
    else if (name.isEmpty) {
      ref.read(userProvider).setNameError(error: 'Please Enter Your Full Name');
      return;
    } else if (email.isEmpty) {
      ref.read(userProvider).setEmailError(error: 'Please Enter Your Email');
      return;
    } else if (!email.isEmail) {
      ref
          .read(userProvider)
          .setEmailError(error: 'Please Enter Your Valid Email');
      return;
    } else if (dateOfBirth == null) {
      ref
          .read(userProvider)
          .setDateError(error: 'Please Select Your Date of Birth');
      return;
    } else if (gender == null || gender.isEmpty) {
      ref.read(userProvider).setGenderError(error: 'Please Select Your Gender');
      return;
    } else {
      print('------------>${fcm}');
      final authPro= ref.read(authProvider);
      ref.read(userProvider).createUserProfile(
            UserBody.register(
                name, email, phoneNo, dateOfBirth, gender, password, fcm ?? "",googleId: (authPro.socialUserData?.isGoogleLogin ?? false) ? authPro.socialUserData?.socialId ?? "":"",facebookId:  !(authPro.socialUserData?.isGoogleLogin ??
                false) ? authPro.socialUserData?.socialId ?? "":""),
          );
    }
  }

  void selectDate() async {
    DateTime? result = await AdaptiveDatePicker.pick(context);

    if (result != null) {
      _dateCtrl.text = result.toStringFormat1;
      ref.read(userProvider).setDateError();
      setState(() {
        _dateOfBirth = result;
      });
    }
  }
}
