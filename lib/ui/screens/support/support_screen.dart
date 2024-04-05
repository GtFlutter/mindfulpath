import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/model/support_ticket_body_model.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/provider/support_provider.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../theme/styles.dart';
import '../../../theme/text_field_style.dart';
import '../../../theme/text_style.dart';
import '../../common/custom_app_bar.dart';
import '../../common/custom_next_button.dart';
import '../../common/custom_scrollable_column_layout.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  static AppStyle _style = AppStyle();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  final _disableField = false;

  @override
  void initState() {
    ref.read(supportProvider).clearAllErrorText(notifie: false);

    super.initState();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _descriptionCtrl.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    var supportP = ref.watch(supportProvider);
    print('--------------->${supportP.name}');
    _nameCtrl.text = supportP.name ?? "";
    _emailCtrl.text = supportP.email ?? "";
    _descriptionCtrl.text = supportP.descr ?? "";

    return AbsorbPointer(
      absorbing: supportP.isLoading,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: CustomAppBar(
          screenSize: size,
          style: _style,
          title: 'Support',
          dataBackMng:
              supportP.name == null || supportP.name == "" ? false : true,
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
                      focusNode: _nameFocusNode,
                      enabled: supportP.name != null ? false : true,
                      controller: _nameCtrl,
                      cursorColor: CustomeTextFieldStyle.cursorColor,
                      onChanged: (_) {
                        supportP.setNameError();
                      },
                      textInputAction: TextInputAction.next,
                      decoration: CustomeTextFieldStyle.inputDecoration(
                        style: _style,
                        labelSize: 15,
                        floatingLabelSize: 15,
                      ).copyWith(
                        labelText: 'Name',
                        errorText: supportP.nameErrorText,
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      style: CustomeTextFieldStyle.valueStyle(
                          style: _style, valueSize: 12.5),
                    ),
                    SizedBox(height: _style.scale * 27.5),
                    TextField(
                      focusNode: _emailFocusNode,
                      controller: _emailCtrl,
                      enabled: supportP.email != null ? false : true,
                      cursorColor: CustomeTextFieldStyle.cursorColor,
                      onChanged: (_) {
                        supportP.setEmailError();
                      },
                      textInputAction: TextInputAction.next,
                      decoration: CustomeTextFieldStyle.inputDecoration(
                        style: _style,
                        labelSize: 15,
                        floatingLabelSize: 15,
                      ).copyWith(
                        labelText: 'Email',
                        errorText: supportP.emailErrorText,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: CustomeTextFieldStyle.valueStyle(
                          style: _style, valueSize: 12.5),
                    ),
                    SizedBox(height: _style.scale * 27.5),
                    TextField(
                      focusNode: _descriptionFocusNode,
                      controller: _descriptionCtrl,
                      enabled: supportP.descr != null ? false : true,
                      cursorColor: CustomeTextFieldStyle.cursorColor,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) {
                        supportP.setDescriptionError();
                      },
                      decoration: CustomeTextFieldStyle.inputDecoration(
                        style: _style,
                        labelSize: 15,
                        floatingLabelSize: 15,
                      ).copyWith(
                        labelText: 'Description',
                        alignLabelWithHint: true,
                        errorText: supportP.descriptionErrorText,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      maxLength: 200,
                      textAlignVertical: TextAlignVertical.top,
                      style: CustomeTextFieldStyle.valueStyle(
                          style: _style, valueSize: 12.5),
                    ),
                    SizedBox(height: _style.scale * 27.5),
                    supportP.name == null || supportP.name == ""
                        ? TextField(
                            readOnly: !_disableField,
                            canRequestFocus: _disableField,
                            showCursor: _disableField,
                            magnifierConfiguration:
                                TextMagnifierConfiguration.disabled,
                            onTap: () {
                              context.go(RoutePath.supportSectionScreenPath);
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
                            style: CustomeTextFieldStyle.valueStyle(
                                style: _style, valueSize: 12.5),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                const Spacer(),
                supportP.name == null || supportP.name == ""
                    ? CustomNextButton(
                        text: 'Submit',
                        onPressed: !supportP.isLoading ? onNext : null,
                        style: _style,
                        inProgress: supportP.isLoading,
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: _style.scale * 20),
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
    String description = _descriptionCtrl.text.trim();

    if (name.isEmpty) {
      ref.read(supportProvider).setNameError(error: 'Please Enter Your Name');
      return;
    } else if (email.isEmpty) {
      ref.read(supportProvider).setEmailError(error: 'Please Enter Your Email');
      return;
    } else if (!email.isEmail) {
      ref
          .read(supportProvider)
          .setEmailError(error: 'Please Enter Your Valid Email');
      return;
    } else if (description.isEmpty) {
      ref
          .read(supportProvider)
          .setDescriptionError(error: 'Please Enter Your Description');
      return;
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      ref.read(supportProvider).raiseSupportTicket(
            SupportTicket.body(
              name: name,
              email: email,
              description: description,
            ),
            nameCtrl: _nameCtrl,
            emailCtrl: _emailCtrl,
            descriptionCtrl: _descriptionCtrl,
          );
    }
  }
}
