// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:io';

import 'package:flutter/cupertino.dart' show showCupertinoModalPopup;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/date_converter.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/cupertino_date_picker.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../theme/styles.dart';
import '../../../theme/text_field_style.dart';
import '../../../theme/text_style.dart';
import '../../../util/constants.dart';
import '../../common/common_bottom_sheet_widget.dart';
import '../../common/custom_app_bar.dart';
import '../authentication/widget/password_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static AppStyle _style = AppStyle();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _numberCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();

  final _disableField = false;

  DateTime? _date;
  String? _gender;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  String? _nameErrorText;
  String? _emailErrorText;
  String? _dateErrorText;
  String? _genderErrorText;

  @override
  void initState() {
    _dateCtrl.text = DateTime.now().toStringFormat1;
    _nameCtrl.text = 'Yashvant Chavda';
    _numberCtrl.text = '+919858535652';
    _emailCtrl.text = 'yashvant@gmail.com';
    _gender = _genders.first;
    super.initState();
  }

  void setNameError([String? error]) {
    if (error == null && _nameErrorText == null) {
      return;
    }
    setState(() => _nameErrorText = error);
  }

  void setEmailError([String? error]) {
    if (error == null && _emailErrorText == null) {
      return;
    }
    setState(() => _emailErrorText = error);
  }

  void setDateError([String? error]) {
    if (error == null && _dateErrorText == null) {
      return;
    }
    setState(() => _dateErrorText = error);
  }

  void setGenderError([String? error]) {
    if (error == null && _genderErrorText == null) {
      return;
    }
    setState(() => _genderErrorText = error);
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
      isScrollControlled: true,
      isDismissible: false,
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      // resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: 'Edit Profile',
        onDonePressed: () {},
      ),
      body: BackgroundImage(
        alignment: Alignment.topCenter,
        child: SafeArea(
          bottom: false,
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
                    setNameError();
                  },
                  textInputAction: TextInputAction.next,
                  decoration: CustomeTextFieldStyle.inputDecoration(style: _style).copyWith(
                    labelText: 'Name',
                    errorText: _nameErrorText,
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  style: CustomeTextFieldStyle.valueStyle(style: _style),
                ),
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
                SizedBox(height: _style.scale * 27.5),
                TextField(
                  controller: _emailCtrl,
                  cursorColor: CustomeTextFieldStyle.cursorColor,
                  onChanged: (_) {
                    setEmailError();
                  },
                  textInputAction: TextInputAction.done,
                  decoration: CustomeTextFieldStyle.inputDecoration(style: _style).copyWith(
                    labelText: 'Email',
                    errorText: _emailErrorText,
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
                    errorText: _dateErrorText,
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
                  decoration: CustomeTextFieldStyle.inputDecoration(style: _style).copyWith(
                    errorText: _genderErrorText,
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
                    setGenderError();
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
                SizedBox(height: _style.scale * 27.5),
                TextField(
                  readOnly: !_disableField,
                  canRequestFocus: _disableField,
                  showCursor: _disableField,
                  magnifierConfiguration: TextMagnifierConfiguration.disabled,
                  onTap: () {
                    changePassword();
                  },
                  keyboardType: TextInputType.none,
                  decoration: CustomeTextFieldStyle.inputDecoration(style: _style).copyWith(
                    labelText: 'Change password',
                    errorText: _dateErrorText,
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
      ),
    );
  }

  void onNext() {
    String name = _nameCtrl.text.trim();
    String email = _emailCtrl.text.trim().toLowerCase();
    DateTime? dateTime = _date;
    String? gender = _gender == null ? null : _gender!.trim();

    if (name.isEmpty) {
      setNameError('Please enter a name');
      return;
    } else if (email.isEmpty) {
      setEmailError('Please enter an email');
      return;
    } else if (!email.isEmail) {
      setEmailError('Invalid email');
      return;
    } else if (dateTime == null) {
      setDateError('Please select date of birth');
      return;
    } else if (gender == null || gender.isEmpty) {
      setGenderError('Please select gender');
      return;
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile Created Successfully')),
      );
    }
  }

  void selectDate() async {
    const int minAge = 16;
    const int maxAge = 150;

    DateTime currentDate = DateTime.now();
    DateTime lastDate = DateTime(currentDate.year - minAge, currentDate.month, currentDate.day);
    DateTime firstDate = DateTime(currentDate.year - maxAge, currentDate.month, currentDate.day);
    DateTime initialDate = lastDate;

    DateTime? result = Platform.isAndroid
        ? await androidDateTimePicker(initialDate, firstDate, lastDate)
        : await iosDateTimePicker(initialDate, firstDate, lastDate);
    if (result != null) {
      _dateCtrl.text = result.toStringFormat1;
      setDateError();
      setState(() {
        _date = result;
      });
    }
  }

  Future<DateTime?> androidDateTimePicker(
    DateTime initialDate,
    DateTime firstDate,
    DateTime lastDate,
  ) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  Future<DateTime?> iosDateTimePicker(
    DateTime initialDate,
    DateTime firstDate,
    DateTime lastDate,
  ) async {
    return await showCupertinoModalPopup<DateTime?>(
      context: context,
      builder: (BuildContext context) => CupertinoDatePickerWidget(
        firstDate: firstDate,
        lastDate: lastDate,
        initialDate: initialDate,
        style: _style,
      ),
    );
  }
}

class ChnagePasswordSheet extends StatefulWidget {
  const ChnagePasswordSheet({super.key});

  @override
  State<ChnagePasswordSheet> createState() => _ChnagePasswordSheetState();
}

class _ChnagePasswordSheetState extends State<ChnagePasswordSheet> {
  static AppStyle _style = AppStyle();

  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  final FocusNode _pwdFocusNode = FocusNode();
  final FocusNode _cPwdFocusNode = FocusNode();

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
  void dispose() {
    _pwdFocusNode.dispose();
    _cPwdFocusNode.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    _style = AppStyle(screenSize: size);

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Color(0xFF2D251F),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonBottomSheetWidget(
              style: _style,
              title: 'Change password',
              doneLable: 'Save',
              onCancle: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
              onDone: onSave,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: _style.scaleX(25),
                right: _style.scaleX(25),
                bottom: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PasswordTextField(
                    key: ValueKey('p1'),
                    focusNode: _pwdFocusNode,
                    controller: _passwordCtrl,
                    textInputAction: TextInputAction.next,
                    errorText: _pwdErrorText,
                    onChanged: (_) {
                      if (_pwdErrorText != null) {
                        setPwdError(null);
                      }
                    },
                    onSubmitted: (_) {
                      _cPwdFocusNode.requestFocus();
                    },
                    style: _style,
                  ),
                  SizedBox(height: _style.scaleX(40)),
                  PasswordTextField(
                    key: ValueKey('p2'),
                    focusNode: _cPwdFocusNode,
                    textInputAction: TextInputAction.done,
                    controller: _confirmPasswordCtrl,
                    labelText: 'Confirm Password',
                    errorText: _cnfPwdErrorText,
                    onChanged: (_) {
                      if (_cnfPwdErrorText != null) {
                        setCnfPwdError(null);
                      }
                    },
                    style: _style,
                  ),
                  if (MediaQuery.of(context).viewInsets.bottom == 0) SizedBox(height: _style.scaleX(100)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSave() {
    String password = _passwordCtrl.text.trim();
    String confirmPassword = _confirmPasswordCtrl.text.trim();
    if (password.isEmpty) {
      setPwdError('Please enter a Password');
      return;
    } else if (confirmPassword.isEmpty) {
      setCnfPwdError('Please enter a Confirm Password');
      return;
    } else if (password.length < AppConstants.PWD_MIN_LENGTH) {
      setPwdError('Password must be atleast ${AppConstants.PWD_MIN_LENGTH} character');
      return;
    } else if (password.length > AppConstants.PWD_MAX_LENGTH) {
      setPwdError(
          'Password length must be between ${AppConstants.PWD_MIN_LENGTH}-${AppConstants.PWD_MAX_LENGTH} character...');
      return;
    } else if (confirmPassword.length < AppConstants.PWD_MIN_LENGTH) {
      setCnfPwdError('Password must be atleast ${AppConstants.PWD_MIN_LENGTH} character');
      return;
    } else if (confirmPassword.length > AppConstants.PWD_MAX_LENGTH) {
      setCnfPwdError(
          'Password length must be between ${AppConstants.PWD_MIN_LENGTH}-${AppConstants.PWD_MAX_LENGTH} character...');
      return;
    } else if (password != confirmPassword) {
      setCnfPwdError('Both password must match');
      return;
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password Changed Successfully')),
      );
      if (context.canPop()) {
        context.pop();
      }
    }
  }
}
