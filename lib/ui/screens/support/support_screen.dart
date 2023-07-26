import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/screen_paths.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../theme/styles.dart';
import '../../../theme/text_field_style.dart';
import '../../../theme/text_style.dart';
import '../../common/custom_app_bar.dart';
import '../../common/custom_next_button.dart';
import '../../common/custom_scrollable_column_layout.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  static AppStyle _style = AppStyle();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();

  final _disableField = false;

  String? _nameErrorText;
  String? _emailErrorText;
  String? _descriptionErrorText;

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

  void setDescriptionError([String? error]) {
    if (error == null && _descriptionErrorText == null) {
      return;
    }
    setState(() => _descriptionErrorText = error);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _descriptionCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    return Scaffold(
      extendBodyBehindAppBar: true,
      // resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: 'Support',
      ),
      body: BackgroundImage(
        alignment: Alignment.topCenter,
        child: SafeArea(
          bottom: false,
          child: CustomScrollableColumnLayout(
            padding: EdgeInsets.only(
              left: _style.scaleX(25),
              right: _style.scaleX(25),
            ),
            minHeight: 550,
            style: _style,
            children: [
              SizedBox(height: _style.scaleX(25)),
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
                    decoration: CustomeTextFieldStyle.inputDecoration(
                      style: _style,
                      labelSize: 15,
                      floatingLabelSize: 15,
                    ).copyWith(
                      labelText: 'Name',
                      errorText: _nameErrorText,
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    style: CustomeTextFieldStyle.valueStyle(style: _style, valueSize: 12.5),
                  ),
                  SizedBox(height: _style.scale * 27.5),
                  TextField(
                    controller: _emailCtrl,
                    cursorColor: CustomeTextFieldStyle.cursorColor,
                    onChanged: (_) {
                      setEmailError();
                    },
                    textInputAction: TextInputAction.next,
                    decoration: CustomeTextFieldStyle.inputDecoration(
                      style: _style,
                      labelSize: 15,
                      floatingLabelSize: 15,
                    ).copyWith(
                      labelText: 'Email',
                      errorText: _emailErrorText,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: CustomeTextFieldStyle.valueStyle(style: _style, valueSize: 12.5),
                  ),
                  SizedBox(height: _style.scale * 27.5),
                  TextField(
                    controller: _descriptionCtrl,
                    cursorColor: CustomeTextFieldStyle.cursorColor,
                    onChanged: (_) {
                      setDescriptionError();
                    },
                    decoration: CustomeTextFieldStyle.inputDecoration(
                      style: _style,
                      labelSize: 15,
                      floatingLabelSize: 15,
                    ).copyWith(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                      errorText: _descriptionErrorText,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    maxLength: 200,
                    textAlignVertical: TextAlignVertical.top,
                    style: CustomeTextFieldStyle.valueStyle(style: _style, valueSize: 12.5),
                  ),
                  SizedBox(height: _style.scale * 27.5),
                  TextField(
                    readOnly: !_disableField,
                    canRequestFocus: _disableField,
                    showCursor: _disableField,
                    magnifierConfiguration: TextMagnifierConfiguration.disabled,
                    onTap: () {
                      context.go(ScreenPaths.supportSectionScreenPath);
                    },
                    keyboardType: TextInputType.none,
                    decoration: CustomeTextFieldStyle.inputDecoration(
                      style: _style,
                      labelSize: 15,
                      floatingLabelSize: 15,
                    ).copyWith(
                      labelText: 'Support section',
                      labelStyle: _style.text.font(
                        mulishSemiBold600,
                        sizePx: 15,
                        color: Colors.white,
                      ),
                      suffixIcon: UnconstrainedBox(
                        child: SvgPicture.asset(
                          SvgPaths.arrowRight,
                          height: _style.scaleX(20),
                          width: _style.scaleX(20),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    style: CustomeTextFieldStyle.valueStyle(style: _style, valueSize: 12.5),
                  ),
                ],
              ),
              const Spacer(),
              CustomNextButton(
                text: 'Submit',
                onPressed: onNext,
                style: _style,
              ),
              SizedBox(height: _style.scale * 20),
            ],
          ),
        ),
      ),
    );
  }

  void onNext() {
    String name = _nameCtrl.text.trim();
    String email = _emailCtrl.text.trim().toLowerCase();
    String description = _descriptionCtrl.text.trim();

    if (name.isEmpty) {
      setNameError('Please enter a name');
      return;
    } else if (email.isEmpty) {
      setEmailError('Please enter an email');
      return;
    } else if (!email.isEmail) {
      setEmailError('Invalid email');
      return;
    } else if (description.isEmpty) {
      setEmailError('Please enter an description');
      return;
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submited Successfully')),
      );
    }
  }
}
