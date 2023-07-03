import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../main.dart';
import '../../../../theme/text_field_style.dart';
import '../../../../util/assets.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;

  /// Default [labelText] is 'Password'
  final String? labelText;

  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void changePwdVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      textAlignVertical: TextAlignVertical.bottom,
      controller: widget.controller,
      onChanged: widget.onChanged,
      cursorColor: CustomeTextFieldStyle.cursorColor,
      textInputAction: widget.textInputAction,
      decoration: CustomeTextFieldStyle.inputDecoration().copyWith(
        labelText: widget.labelText ?? 'Password',
        errorText: widget.errorText,
        suffix: MaterialButton(
          onPressed: changePwdVisibility,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          visualDensity: const VisualDensity(vertical: -4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minWidth: $style.scale * 30,
          child: SvgPicture.asset(
            _obscureText ? SvgPaths.passwordHide : SvgPaths.passwordVisible,
            width: $style.scale * 20,
            height: $style.scale * 20,
          ),
        ),
      ),
      style: CustomeTextFieldStyle.valueStyle(spacingPc: 50),
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      onSubmitted: widget.onSubmitted,
    );
  }
}
