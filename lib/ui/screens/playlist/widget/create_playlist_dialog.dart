import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/provider/playlist_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_field_style.dart';

import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';

class CreatePlaylistDialog extends ConsumerStatefulWidget {
  CreatePlaylistDialog(this.style, {super.key, this.videoId});

  final AppStyle style;
  final String? videoId;
  @override
  ConsumerState<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}
class _CreatePlaylistDialogState extends ConsumerState<CreatePlaylistDialog> {

  late final TextEditingController _playlistCtrl;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _playlistCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _playlistCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playlistP = ref.watch(playListProvider);
    final style = widget.style;
    final outlineBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.textFieldEnableBorderColor,
        width: style.scale * 0.9,
      ),
      borderRadius: BorderRadius.circular(style.scale * 50),
      gapPadding: style.scale * 12,
    );
    return AbsorbPointer(
      absorbing: playlistP.isCreatePlaylistLoading,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: style.scaleX(400)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            style.scaleX(16.5),
            style.scaleX(26.5),
            style.scaleX(16.5),
            style.scaleX(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Playlist',
                style: style.text.font(mulishSemiBold600, sizePx: 20),
              ),
              SizedBox(height: style.scaleX(25)),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _playlistCtrl,
                  cursorColor: CustomeTextFieldStyle.cursorColor,
                  textInputAction: TextInputAction.next,
                  decoration: CustomeTextFieldStyle.inputDecoration(style: style).copyWith(
                    labelText: 'Enter Playlist Name',
                    counterText: '',
                    border: const OutlineInputBorder(),
                    enabledBorder: outlineBorder,
                    focusedBorder: outlineBorder,
                    errorBorder: outlineBorder,
                    focusedErrorBorder: outlineBorder,
                    disabledBorder: outlineBorder,
                    enabled: !playlistP.isCreatePlaylistLoading
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Playlist Name';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  style: CustomeTextFieldStyle.valueStyle(style: style),
                  maxLength: 30,
                ),
              ),
              SizedBox(height: style.scaleX(37.5)),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: style.scaleX(200)
                ),
                child: Row(
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
                      child: playlistP.isCreatePlaylistLoading ? Center(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: style.scaleX(10)),
                          constraints: BoxConstraints(maxHeight: style.scaleX(20), maxWidth: style.scaleX(20)),
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: style.scaleX(2),
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation(Colors.green.shade900),
                          ),
                        ),
                      ) : FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await playlistP.createPlaylist(_playlistCtrl.text.trim(), videoId: widget.videoId);
                            if (context.mounted && context.canPop()) context.pop();
                          }
                        },
                        style: FilledButton.styleFrom(
                          textStyle: style.text.font(mulishSemiBold600, sizePx: 15),
                          padding: EdgeInsets.symmetric(vertical: style.scaleX(10)),
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

