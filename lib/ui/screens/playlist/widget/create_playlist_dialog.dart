import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/theme/text_field_style.dart';

import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';

class CreatePlaylistDialog extends ConsumerWidget {
  CreatePlaylistDialog(this.style, {super.key});

  final AppStyle style;

  final TextEditingController _playlistCtrl = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AbsorbPointer(
      absorbing: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: style.scaleX(400)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            style.scaleX(16.5),
            style.scaleX(26.5),
            style.scaleX(16.5),
            style.scaleX(18),
          ),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create Playlist',
                    style: style.text.font(mulishSemiBold600, sizePx: 20),
                  ),
                  SizedBox(height: style.scaleX(10)),
                  TextField(
                    controller: _playlistCtrl,
                    cursorColor: CustomeTextFieldStyle.cursorColor,
                    textInputAction: TextInputAction.next,
                    decoration: CustomeTextFieldStyle.inputDecoration(style: style).copyWith(
                      labelText: 'Enter Playlist Name',
                      counterText: ''
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    style: CustomeTextFieldStyle.valueStyle(style: style),
                    maxLength: 30,
                  ),
                  SizedBox(height: style.scaleX(37.5)),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            textStyle: style.text.font(mulishSemiBold600, sizePx: 15),
                            padding: EdgeInsets.symmetric(vertical: style.scaleX(10)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: style.scaleX(21)),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            textStyle: style.text.font(mulishSemiBold600, sizePx: 15),
                            padding: EdgeInsets.symmetric(vertical: style.scaleX(10)),
                          ),
                          child: const Text('Create'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
