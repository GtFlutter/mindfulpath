import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/response/pdfs_response.dart';
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
  bool _isPdfDownloading = false;
  bool get isPdfDownloading => _isPdfDownloading;
  bool _isDownloadComplete = false;
  bool get isDownloadComplete => _isDownloadComplete;

  double _progress = 0.0;
  double get progress => _progress;

  VideoResponse? _model;
  VideoResponse? get model => _model;

  PdfResponse? _pdfModel;
  PdfResponse? get pdfModel => _pdfModel;

  void setProgress(double value) {
    if (_progress != value){
      _progress = value;
      notifyListeners();
    }
  }

  void pdfDownload({PdfResponse? model}) async{
    BuildContext? context = rootNavigator.currentContext;
    if (context == null) return;
    if (model == null) return;
    _pdfModel = model;
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
    if (false) {
      buyNow(context, categoryId: model.category!.id.toString());
      return;
    }
    await _checkDirectory(true);
    String path = await PathHelper.getDownloadDirectoryPath(true);
    debugPrint('File Path :: $path/${model.pdf!.fileName!}');
    bool result = await PathHelper.fileExists('$path/${model.pdf!.fileName!}');
    if (result) {
      debugPrint('True');
      _getSinglePdf('$path/${model.pdf!.fileName!}', model: model);
      showCustomSnackBar('File Already Exists', type: true);
      _pdfModel = null;
      notifyListeners();
    } else {
      debugPrint('False');
      await DownloadHelper.instance.download(
        model.pdfUrl!,
        '$path/${model.pdf!.fileName!}',
        onReceiveProgress: (count, total) {
          debugPrint('Count :: $count --*-- Total :: $total');
          if (total != -1) {
            tempProgress = ((count / total * 100).roundToDouble())/100;
            if (!_isDownloadComplete && !_isPdfDownloading) {
              _isPdfDownloading = true;
              notifyListeners();
            }
            if (tempProgress == 1.0) {
              if (!_isDownloadComplete) {
                _isDownloadComplete = true;
                _isPdfDownloading = false;
                debugPrint('Is Downloading == $_isDownloading --*-*-- Is Download Complete == $_isDownloadComplete');
                _saveCategoryAndVideo('$path/${model.pdf!.fileName!}', pdfModel: model, isPdf: true);//pdf download- download provider
                _pdfModel = null;
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

  void download({VideoResponse? model}) async {
    print("call----${model?.category?.isPurchased}");

    BuildContext? context = rootNavigator.currentContext;
    if (context == null) return;
    if (model == null) return;
    print("model----$model");
    _model = model;
    notifyListeners();
    double tempProgress = 0.0;
    if (!ref.read(authProvider).isUserLoggedIn) {
      _model=null;
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
    ///Temp comment for check download process
    // if (!model.category!.isPurchased!) {
    //   buyNow(context, categoryId: model.category!.id.toString());
    //   return;
    // }
    await _checkDirectory(false);
    print("check directory");
    String path = await PathHelper.getDownloadDirectoryPath(false);
    debugPrint('File Path :: $path/${model.video!.fileName!}');
    bool result = await PathHelper.fileExists('$path/${model.video!.fileName!}');
    if (result) {
      debugPrint('True');
      _getSingleVideo('$path/${model.video!.fileName!}', model: model);
      showCustomSnackBar('File Already Exists', type: true);
      _model = null;
      notifyListeners();
    } else {
      debugPrint('False');
      try{
        await DownloadHelper.instance.download(
          model.videoUrl!,
          '$path/${model.video!.fileName!}',
          onReceiveProgress: (count, total) async {
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
                  await _saveCategoryAndVideo('$path/${model.video!.fileName!}', model: model);//video download-download provider
                  _model = null;
                  notifyListeners();
                }
              }
              setProgress(tempProgress);
              debugPrint("Total Progress 1 :: $_progress%");
            }
          },
        );
      }catch(e){
        _model=null;
        showCustomSnackBar(e.toString());
      }

    }
  }

  Future<void> _checkDirectory(bool isPdf) async {
    String path = await PathHelper.getDownloadDirectoryPath(isPdf);
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
      _saveCategoryAndVideo(videoFile, model: model);//_getSingleVideo
    }
  }

  Future<void> _getSinglePdf(String pdfFile,{PdfResponse? model}) async {
    if (model == null) return;
    final dbHelper = ref.read(databaseProvider);
    PdfModel? res = await dbHelper.getSinglePdf(model.id!.toString());
    if (res == null) {
      _saveCategoryAndVideo(pdfFile, pdfModel: model);//_getSinglePdf
    }
  }

  Future<void> _saveCategoryAndVideo(String videoFile,{VideoResponse? model, PdfResponse? pdfModel, bool isPdf = false}) async {
    if (model == null) return;
    final dbHelper = ref.read(databaseProvider);
    print("_saveCategoryAndVideo-->${model.categoryId}");
    CategoryModal? res = await dbHelper.getSingleCategory(model.categoryId!.toString());
    print("_saveCategoryAndVideo getSingleCategory-->${res?.toJson()}");

    if (res != null) {
      print("if called....");
      if(isPdf){
        PdfModel vModal = PdfModel(categoryId: res.id, pdfId: pdfModel!.id!.toString(),pdfName: pdfModel.title, pdfFile: videoFile);
        int vRes = await dbHelper.savePDF(vModal);
        if (vRes == 1) showCustomSnackBar('PDF Save Successfully download');
      }else{
        VideoModal vModal = VideoModal(categoryId: res.id, videoId: model.id!.toString(),videoName: model.title, videoFile: videoFile, videoDuration: model.duration);
        int vRes = await dbHelper.saveVideo(vModal);
        if (vRes == 1) showCustomSnackBar('Video Save Successfully download');
      }
    } else {
      CategoryModal modal = CategoryModal(categoryId: model.categoryId!.toString(), categoryName: model.categoryTitle ?? model.category!.title, categoryImage: model.category!.imageResponse!.imageUrl);
      print("else called....${model.toJson()}");
      int cRes = await dbHelper.saveCategory(modal);
      if (cRes == 1) {
        CategoryModal? res = await dbHelper.getSingleCategory(model.categoryId!.toString());
        print("after category saved get single category--->${res?.toJson()}");
        if (res != null) {
          if(isPdf){
            PdfModel vModal = PdfModel(categoryId: res.id, pdfId: pdfModel!.id!.toString(),pdfName: pdfModel.title, pdfFile: videoFile);
            int vRes = await dbHelper.savePDF(vModal);
            if (vRes == 1) showCustomSnackBar('PDF Save Successfully download');
          }else{
            // VideoModal vModal = VideoModal(categoryId: res.id, videoId: model.id!.toString(),videoName: model.title, videoFile: videoFile, videoDuration: model.duration);
            VideoModal vModal = VideoModal(categoryId: int.parse(res.categoryId ?? "0"), videoId: model.id!.toString(),videoName: model.title, videoFile: videoFile, videoDuration: model.duration);
            int vRes = await dbHelper.saveVideo(vModal);
            if (vRes == 1) showCustomSnackBar('Video Save Successfully download');
          }
        }
      }
    }
  }


  bool _isAlreadyDownload = false;
  bool get isAlreadyDownload => _isAlreadyDownload;

  Future<bool> checkVideoIsDownload(String id, bool isPdf) async {
    final dbHelper = ref.read(databaseProvider);
    Object? res;
    if(isPdf){
      res = await dbHelper.getSingleVideo(id);
    }else{
      res = await dbHelper.getSinglePdf(id);
    }
    if (res == null) {
      _isAlreadyDownload = false;
      notifyListeners();
      return _isAlreadyDownload;
    }
    _isAlreadyDownload = true;
    notifyListeners();
    return _isAlreadyDownload;
  }
}
