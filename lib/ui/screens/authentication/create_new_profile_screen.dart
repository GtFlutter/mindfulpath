// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:io';

import 'package:flutter/cupertino.dart' show showCupertinoModalPopup;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/helper/date_converter.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/cupertino_date_picker.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_auth_app_bar.dart';
import 'package:meditation_app/ui/screens/authentication/widget/custom_header.dart';
import 'package:meditation_app/ui/common/custom_next_button.dart';
import 'package:meditation_app/ui/common/custom_scrollable_column_layout.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../theme/styles.dart';
import '../../../theme/text_field_style.dart';

class CreateNewProfileScreen extends StatefulWidget {
  const CreateNewProfileScreen({super.key});

  @override
  State<CreateNewProfileScreen> createState() => _CreateNewProfileScreenState();
}

class _CreateNewProfileScreenState extends State<CreateNewProfileScreen> {
  static AppStyle _style = AppStyle();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  DateTime? _date;
  String? _gender;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  String? _nameErrorText;
  String? _emailErrorText;
  String? _dateErrorText;
  String? _genderErrorText;

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
    _emailCtrl.dispose();
    _dateCtrl.dispose();

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
        surfaceTintColor: Colors.transparent,
        screenSize: size,
        style: _style,
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
                              setNameError();
                            },
                            textInputAction: TextInputAction.next,
                            decoration: CustomeTextFieldStyle.inputDecoration(style: _style).copyWith(
                              labelText: 'Full name',
                              errorText: _nameErrorText,
                            ),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: CustomeTextFieldStyle.valueStyle(style: _style),
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
                          )
                        ],
                      ),
                      Spacer(flex: 3),
                      CustomNextButton(
                        text: 'Next',
                        onPressed: onNext,
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

  void onNext() {
    String name = _nameCtrl.text.trim();
    String email = _emailCtrl.text.trim().toLowerCase();
    DateTime? dateTime = _date;
    String? gender = _gender == null ? null : _gender!.trim();

    if (name.isEmpty) {
      setNameError('Please enter a full name');
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
