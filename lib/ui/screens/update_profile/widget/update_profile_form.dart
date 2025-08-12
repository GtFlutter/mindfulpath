// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/model/body/user_body.dart';
import 'package:meditation_app/helper/date_converter.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/update_profile/widget/chnage_password_sheet.dart';
import 'package:meditation_app/util/assets.dart';
import 'package:meditation_app/util/constants.dart';

import '../../../../data/model/response/user_response.dart';
import '../../../../provider/user_provider.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_field_style.dart';
import '../../../common/adaptive_date_picker.dart';

class OnNextController {
  void Function()? onNext;

  void dispose() => onNext = null;
}

class UpdateProfileForm extends ConsumerStatefulWidget {
  final UserResponse user;
  final OnNextController onNextController;

  const UpdateProfileForm({required this.onNextController, super.key, required this.user});

  @override
  ConsumerState<UpdateProfileForm> createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends ConsumerState<UpdateProfileForm> {
  static AppStyle _style = AppStyle();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _numberCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();

  final _disableField = false;

  late DateTime _dateOfBirth;
  String? _gender;

  final List<String> _genders = List.unmodifiable(['Male', 'Female', 'Other']);

  void onNext() {
    String name = _nameCtrl.text.trim();
    String email = _emailCtrl.text.trim().toLowerCase();
    DateTime dateTime = _dateOfBirth;
    String? gender;
    if (null == _gender) {
      gender = null;
    } else {
      gender = _gender!.trim();
    }

    if (name.isEmpty) {
      ref.read(userProvider).setNameError(error: 'Please enter a name');
      return;
    } else if (email.isEmpty) {
      ref.read(userProvider).setEmailError(error: 'Please enter an email');
      return;
    } else if (!email.isEmail) {
      ref.read(userProvider).setEmailError(error: 'Invalid email');
      return;
    } else if (gender == null || gender.isEmpty) {
      ref.read(userProvider).setGenderError(error: 'Please select gender');
      return;
    } else {
      FocusManager.instance.primaryFocus?.unfocus();

      ref.read(userProvider).updateUserProfile(
            UserBody.update(
              name,
              email,
              widget.user.phoneNo ?? "",
              dateTime,
              gender,
            ),
          );
    }
  }

  @override
  void initState() {
    if (widget.user.name == null ||
        // widget.user.phoneNo == null ||
        widget.user.email == null ||
        widget.user.birthDate == null ||
        widget.user.gender == null) {
      showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
      if (context.canPop()) {
        context.pop();
      }
      return;
    }
    ref.read(userProvider).clearAllErrorText(notifie: false);

    _nameCtrl.text = widget.user.name!;
    _numberCtrl.text = widget.user.phoneNo ?? "";
    _emailCtrl.text = widget.user.email!;
    _dateCtrl.text = widget.user.birthDate!.toStringFormat1;
    _dateOfBirth = widget.user.birthDate!;
    _gender = widget.user.gender!.capitalizeFirstLetter;

    widget.onNextController.onNext = onNext;
    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    _emailCtrl.dispose();
    _dateCtrl.dispose();

    super.dispose();
  }

  void changePassword() {
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_style.scaleX(15)),
          topRight: Radius.circular(_style.scaleX(15)),
        ),
      ),
      builder: (context) {
        return ChnagePasswordSheet();
      },
      context: context,
      enableDrag: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    var userP = ref.watch(userProvider);

    return AbsorbPointer(
      absorbing: userP.isLoading,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (userP.isLoading)
              LinearProgressIndicator(
                minHeight: _style.scaleX(1.5),
                backgroundColor: Colors.transparent,
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  _style.scaleX(25),
                  _style.scaleX(25),
                  _style.scaleX(25),
                  _style.scaleX(60),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameCtrl,
                      cursorColor: CustomeTextFieldStyle.cursorColor,
                      onChanged: (_) {
                        userP.setNameError();
                      },
                      textInputAction: TextInputAction.next,
                      decoration: CustomeTextFieldStyle.inputDecoration(style: _style).copyWith(
                        labelText: 'Name',
                        errorText: userP.nameErrorText,
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      style: CustomeTextFieldStyle.valueStyle(style: _style),
                    ),
                    if (ref.read(authProvider).socialUserData?.socialId?.isEmpty ?? true) ...[
                      SizedBox(height: _style.scale * 27.5),
                      TextField(
                        controller: _numberCtrl,
                        cursorColor: CustomeTextFieldStyle.cursorColor,
                        showCursor: _disableField,
                        magnifierConfiguration: TextMagnifierConfiguration.disabled,
                        decoration: CustomeTextFieldStyle.inputDecoration(
                          style: _style,
                          enabled: _disableField,
                        ).copyWith(
                          labelText: 'Number',
                          enabled: _disableField,
                        ),
                        keyboardType: TextInputType.none,
                        readOnly: !_disableField,
                        canRequestFocus: _disableField,
                        autofocus: _disableField,
                        style: CustomeTextFieldStyle.valueStyle(style: _style, enabled: _disableField),
                      ),
                    ],
                    SizedBox(height: _style.scale * 27.5),
                    TextField(
                      controller: _emailCtrl,
                      readOnly: ref.read(authProvider).socialUserData?.socialId?.isNotEmpty ?? false,
                      cursorColor: CustomeTextFieldStyle.cursorColor,
                      onChanged: (_) {
                        userP.setEmailError();
                      },
                      textInputAction: TextInputAction.done,
                      decoration: CustomeTextFieldStyle.inputDecoration(style: _style).copyWith(
                        labelText: 'Email',
                        errorText: userP.emailErrorText,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: CustomeTextFieldStyle.valueStyle(style: _style),
                    ),
                    SizedBox(height: _style.scale * 27.5),
                    TextField(
                      controller: _dateCtrl,
                      readOnly: true,
                      canRequestFocus: false,
                      onTap: selectDate,
                      decoration: CustomeTextFieldStyle.inputDecoration(style: _style).copyWith(
                        labelText: 'Date of birth',
                        errorText: userP.dateErrorText,
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: _style.scale * 25),
                          child: SvgPicture.asset(SvgPaths.calendar),
                        ),
                        suffixIconConstraints: BoxConstraints(
                          maxWidth: (_style.scale * 20) + (_style.scale * 25),
                          maxHeight: _style.scale * 20,
                        ),
                      ),
                      style: CustomeTextFieldStyle.valueStyle(style: _style),
                    ),
                    SizedBox(height: _style.scale * 27.5),
                    DropdownButtonFormField(
                      value: _gender,
                      style: CustomeTextFieldStyle.valueStyle(style: _style),
                      borderRadius: BorderRadius.circular(_style.scale * 10),
                      dropdownColor: Color.fromARGB(255, 93, 53, 20),
                      alignment: Alignment.bottomCenter,
                      decoration: CustomeTextFieldStyle.inputDecoration(style: _style).copyWith(
                        errorText: userP.genderErrorText,
                        labelText: 'Gender',
                      ),
                      icon: SvgPicture.asset(SvgPaths.arrowDown),
                      iconSize: _style.scale * 20,
                      items: List.generate(_genders.length, (index) {
                        return DropdownMenuItem(
                          child: Text(_genders[index]),
                          value: _genders[index],
                        );
                      }).toList(),
                      onChanged: (value) {
                        userP.setGenderError();
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    SizedBox(height: _style.scale * 27.5),
                    if (ref.read(authProvider).socialUserData?.socialId?.isEmpty ?? true)
                      TextField(
                        readOnly: !_disableField,
                        canRequestFocus: _disableField,
                        showCursor: _disableField,
                        magnifierConfiguration: TextMagnifierConfiguration.disabled,
                        onTap: changePassword,
                        keyboardType: TextInputType.none,
                        decoration: CustomeTextFieldStyle.inputDecoration(style: _style).copyWith(
                          labelText: 'Change Password',
                          suffixIcon: UnconstrainedBox(
                            child: SvgPicture.asset(
                              SvgPaths.arrowRight,
                              height: _style.scaleX(20),
                              width: _style.scaleX(20),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        style: CustomeTextFieldStyle.valueStyle(style: _style),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectDate() async {
    DateTime? result = await AdaptiveDatePicker.pick(context, initialDate: _dateOfBirth);
    if (result != null) {
      _dateCtrl.text = result.toStringFormat1;
      ref.read(userProvider).setDateError();
      setState(() {
        _dateOfBirth = result;
      });
    }
  }
}
