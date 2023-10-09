import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playListProvider = ChangeNotifierProvider<PlaylistNotifier>((ref) => PlaylistNotifier());

class PlaylistNotifier extends ChangeNotifier {

}