import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';
import 'package:meditation_app/database/database_helper.dart';
import 'package:meditation_app/database/database_model.dart';
import 'package:meditation_app/helper/download_helper.dart';
import 'package:meditation_app/helper/path_helper.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/settings/widget/logout_dialog.dart';

final downloadProvider = ChangeNotifierProvider<DownloadNotifier>((ref) => DownloadNotifier(ref));

class DownloadNotifier extends ChangeNotifier {

  final ChangeNotifierProviderRef<DownloadNotifier> ref;
  DownloadNotifier(this.ref);

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;
  bool _isDownloadComplete = false;
  bool get isDownloadComplete => _isDownloadComplete;

  double _progress = 0.0;
  double get progress => _progress;

  VideoResponse? _model;
  VideoResponse? get model => _model;

  void setProgress(double value) {
    if (_progress != value){
      _progress = value;
      notifyListeners();
    }
  }

  void download({VideoResponse? model}) async {
    BuildContext? context = rootNavigator.currentContext;
    if (context == null) return;
    if (model == null) return;
    _model = model;
    notifyListeners();
    double tempProgress = 0.0;
    if (!ref.read(authProvider).isUserLoggedIn) {
      showCustomSnackBar(
        'Please log in to bookmark.',
        action: SnackBarAction(
          label: 'Log In',
          backgroundColor: AppColors.primaryColor.withOpacity(0.8),
          textColor: Colors.brown.shade800,
          onPressed: () => appRouter.go(RoutePath.signIn),
        ),
        duration: const Duration(seconds: 5),
      );
      return;
    }
    if (!model.category!.isPurchased!) {
      buyNow(context, categoryId: model.category!.id.toString());
      return;
    }
    await _checkDirectory();
    String path = await PathHelper.getDownloadDirectoryPath();
    debugPrint('File Path :: $path/${model.video!.fileName!}');
    bool result = await PathHelper.fileExists('$path/${model.video!.fileName!}');
    if (result) {
      debugPrint('True');
      _getSingleVideo('$path/${model.video!.fileName!}');
      showCustomSnackBar('File Already Exists', type: true);
      _model = null;
      notifyListeners();
    } else {
      debugPrint('False');
      await DownloadHelper.instance.download(
        model.videoUrl!,
        '$path/${model.video!.fileName!}',
        onReceiveProgress: (count, total) {
          debugPrint('Count :: $count --*-- Total :: $total');
          if (total != -1) {
            tempProgress = ((count / total * 100).roundToDouble())/100;
            if (!_isDownloadComplete && !_isDownloading) {
              _isDownloading = true;
              notifyListeners();
            }
            if (tempProgress == 1.0) {
              if (!_isDownloadComplete) {
                _isDownloadComplete = true;
                _isDownloading = false;
                debugPrint('Is Downloading == $_isDownloading --*-*-- Is Download Complete == $_isDownloadComplete');
                _saveCategoryAndVideo('$path/${model.video!.fileName!}', model: model);
                _model = null;
                notifyListeners();
              }
            }
            setProgress(tempProgress);
            debugPrint("Total Progress 1 :: $_progress%");
          }
        },
      );
    }
  }

  Future<void> _checkDirectory() async {
    String path = await PathHelper.getDownloadDirectoryPath();
    debugPrint('Path :: $path');
    bool result = await PathHelper.directoryExits(path);
    if (!result) {
      Directory directory = await PathHelper.createDirectory(path, recursive: true);
      debugPrint('Directory Path :: ${directory.path}');
    }
  }

  Future<void> _getSingleVideo(String videoFile,{VideoResponse? model}) async {
    if (model == null) return;
    final dbHelper = ref.read(databaseProvider);
    VideoModal? res = await dbHelper.getSingleVideo(model.id!.toString());
    if (res == null) {
      _saveCategoryAndVideo(videoFile, model: model);
    }
  }

  Future<void> _saveCategoryAndVideo(String videoFile,{VideoResponse? model}) async {
    if (model == null) return;
    final dbHelper = ref.read(databaseProvider);
    CategoryModal? res = await dbHelper.getSingleCategory(model.categoryId!.toString());
    if (res != null) {
      VideoModal vModal = VideoModal(categoryId: res.id, videoId: model.id!.toString(),videoName: model.title, videoFile: videoFile, videoDuration: model.duration);
      int vRes = await dbHelper.saveVideo(vModal);
      if (vRes == 1) showCustomSnackBar('Video Save Successfully download');
    } else {
      CategoryModal modal = CategoryModal(categoryId: model.categoryId!.toString(), categoryName: model.categoryTitle, categoryImage: model.category!.imageResponse!.imageUrl);
      int cRes = await dbHelper.saveCategory(modal);
      if (cRes == 1) {
        CategoryModal? res = await dbHelper.getSingleCategory(model.categoryId!.toString());
        if (res != null) {
          VideoModal vModal = VideoModal(categoryId: res.id, videoId: model.id!.toString(),videoName: model.title, videoFile: videoFile, videoDuration: model.duration);
          int vRes = await dbHelper.saveVideo(vModal);
          if (vRes == 1) showCustomSnackBar('Video Save Successfully download');
        }
      }
    }
  }
}
