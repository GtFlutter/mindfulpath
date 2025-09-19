import 'dart:developer';
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

  bool complate = false;
  bool Pdfcomplate = false;

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
    if (_progress != value) {
      _progress = value;
      notifyListeners();
    }
  }

  void pdfDownload({PdfResponse? model}) async {
  log("----->model for pdf download--->$model");
    BuildContext? context = await rootNavigator.currentContext;
    if (context == null) return;
    if (model == null) return;
    _pdfModel = await model;
    notifyListeners();
    double tempProgress = 0.0;
    if (!ref.read(authProvider).isUserLoggedIn) {
      showCustomSnackBar(
        'Please Sign in to download a Pdf.',
        action: SnackBarAction(
          label: 'Log In',
          backgroundColor: AppColors.primaryColor.withOpacity(0.8),
          textColor: Colors.brown.shade800,
          onPressed: () => appRouter.go(RoutePath.signIn),
        ),
        duration: const Duration(seconds: 5),
      );
      _pdfModel = null;
      return;
    }
    await _checkDirectory(true);

    String path = await PathHelper.getDownloadDirectoryPath(false);
    debugPrint('File Path :: $path/${model.pdf!.fileName!}');
    bool result = await PathHelper.fileExists('$path/${model.pdf!.fileName!}');
    //if (result) {
    //  debugPrint('True');

    //  //'$path/${model.pdf!.fileName!}'
    //  _getSinglePdf(model.pdf?.url ?? "", model: model);
    //  showCustomSnackBar('File Already Exists', type: true);
    //  _pdfModel = null;
    //  notifyListeners();
    //} else {
    final res=await DownloadHelper.instance.download(
      model.pdfUrl!,
      '$path/${model.pdf!.fileName!}',
      onReceiveProgress: (count, total) async {
        print("model category id-->${model.categoryId}");
        debugPrint('Count :: $count --*-- Total :: $total');
        if (total != -1) {
          tempProgress = ((count / total * 100).roundToDouble()) / 100;
          if (!_isDownloadComplete && !_isPdfDownloading) {
            _isPdfDownloading = true;
            notifyListeners();
          }
          if (tempProgress == 1.0) {
            if (!_isDownloadComplete) {
              _isDownloadComplete = true;
              _isPdfDownloading = false;
              debugPrint('Is Downloading == $_isPdfDownloading --*-*-- Is Download Complete == $_isDownloadComplete');
             // await _saveCategoryAndVideo(model.pdf?.url ?? "", pdfModel: model, isPdf: true); //pdf download- download provider
             await _saveCategoryAndVideo(model.pdfUrl ?? "", pdfModel: model, isPdf: true); //pdf download- download provider
              _pdfModel = null;
              notifyListeners();
            }
          }
          setProgress(tempProgress);
          debugPrint("Total Progress 1 :: $_progress%");
        } else {
          _pdfModel = null;
        }
      },
    );
    // }
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
      _model = null;
      showCustomSnackBar(
        'Please Sign in to download a video.',
        action: SnackBarAction(
          label: 'Sign in',
          backgroundColor: AppColors.primaryColor.withOpacity(0.8),
          textColor: Colors.brown.shade800,
          onPressed: () => appRouter.go(RoutePath.signIn),
        ),
        duration: const Duration(seconds: 5),
      );
      return;
    }

    await _checkDirectory(false);
    print("check directory");
    String path = await PathHelper.getDownloadDirectoryPath(false);
    debugPrint('File Path for video download :: $path/${model.video!.fileName!}');
    bool result = await PathHelper.fileExists('$path/${model.video!.fileName!}');
    // if (result) {
    //   debugPrint('True');
    //   _getSingleVideo('$path/${model.video!.fileName!}', model: model);
    //   showCustomSnackBar('File Already Exists', type: true);
    //   _model = null;
    //   notifyListeners();
    // } else {
    debugPrint('False');
    try {
      await DownloadHelper.instance.download(
        model.videoUrl!,
        '$path/${model.video!.fileName!}',
        onReceiveProgress: (count, total) async {
          debugPrint('Count :: $count --*-- Total :: $total');
          if (total != -1) {
            tempProgress = ((count / total * 100).roundToDouble()) / 100;
            if (!_isDownloadComplete && !_isDownloading) {
              _isDownloading = true;
              notifyListeners();
            }
            if (tempProgress == 1.0) {
              if (!_isDownloadComplete) {
                _isDownloadComplete = true;
                _isDownloading = false;
                debugPrint('Is Downloading == $_isDownloading --*-*-- Is Download Complete == $_isDownloadComplete');
                await _saveCategoryAndVideo('$path/${model.video?.fileName}', //video download-download provider
                    model: model); //video download-download provider
                _model = null;
                notifyListeners();
              }
            }
            setProgress(tempProgress);
            debugPrint("Total Progress of video :: $_progress%");
          }
        },
      );
    } catch (e) {
      _model = null;
      showCustomSnackBar(e.toString());
    }
    // }
  }

  ///download audio
  void downloadAudio({VideoResponse? model}) async {
    print("call---downloadAudio-${model?.category?.isPurchased}");
    BuildContext? context = rootNavigator.currentContext;
    if (context == null) return;
    if (model == null) return;
    print("audio model----$model");
    _model = model;
    notifyListeners();
    double tempProgress = 0.0;
    if (!ref.read(authProvider).isUserLoggedIn) {
      _model = null;
      showCustomSnackBar(
        'Please Sign in to download a Audio.',
        action: SnackBarAction(
          label: 'Sign in',
          backgroundColor: AppColors.primaryColor.withOpacity(0.8),
          textColor: Colors.brown.shade800,
          onPressed: () => appRouter.go(RoutePath.signIn),
        ),
        duration: const Duration(seconds: 5),
      );
      return;
    }

    await _checkDirectory(false, isAudio: true);
    print("check directory to download audio");
    String path = await PathHelper.getDownloadDirectoryPath(false, isAudio: true);
    String fileName = Uri.parse(model.videoUrl ?? "").pathSegments.last;
    print("File name: $fileName");
    bool result = await PathHelper.fileExists('$path/$fileName');
    debugPrint('False');
    try {
      await DownloadHelper.instance.download(
        model.videoUrl!,
        '$path/$fileName',
        onReceiveProgress: (count, total) async {
          debugPrint('Count :: $count --*-- Total :: $total');
          if (total != -1) {
            tempProgress = ((count / total * 100).roundToDouble()) / 100;
            if (!_isDownloadComplete && !_isDownloading) {
              _isDownloading = true;
              notifyListeners();
            }
            if (tempProgress == 1.0) {
              if (!_isDownloadComplete) {
                _isDownloadComplete = true;
                _isDownloading = false;
                debugPrint('Is Downloading == $_isDownloading --*-*-- Is Download Complete == $_isDownloadComplete');
                await _saveCategoryAndVideo('$path/$fileName', //audio download-download provider
                    model: model,
                    isAudio: true);
                _model = null;
                notifyListeners();
              }
            }
            setProgress(tempProgress);
            debugPrint("Total Progress 1 :: $_progress%");
          }
        },
      );
    } catch (e) {
      _model = null;
      showCustomSnackBar(e.toString());
    }
    // }
  }

  ///non usable method
  void downloadPlayList({VideoResponse? model}) async {
    print("call----${model?.category?.isPurchased}");

    BuildContext? context = rootNavigator.currentContext;
    if (context == null) return;
    if (model == null) return;
    print("model----$model");
    _model = model;
    notifyListeners();
    double tempProgress = 0.0;
    if (!ref.read(authProvider).isUserLoggedIn) {
      _model = null;
      showCustomSnackBar(
        'Please Sign in to bookmark.',
        action: SnackBarAction(
          label: 'Sign in',
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
    // if (result) {
    //   debugPrint('True');
    //   _getSingleVideo('$path/${model.video!.fileName!}', model: model);
    //   showCustomSnackBar('File Already Exists', type: true);
    //   _model = null;
    //   notifyListeners();
    // } else {
    debugPrint('False');
    try {
      await DownloadHelper.instance.download(
        model.videoUrl!,
        '$path/${model.video!.fileName!}',
        onReceiveProgress: (count, total) async {
          debugPrint('Count :: $count --*-- Total :: $total');
          if (total != -1) {
            tempProgress = ((count / total * 100).roundToDouble()) / 100;
            if (!_isDownloadComplete && !_isDownloading) {
              _isDownloading = true;
              notifyListeners();
            }
            if (tempProgress == 1.0) {
              if (!_isDownloadComplete) {
                _isDownloadComplete = true;
                _isDownloading = false;
                debugPrint('Is Downloading == $_isDownloading --*-*-- Is Download Complete == $_isDownloadComplete');
                await _saveCategoryAndVideo('$path/${model.video!.fileName!}', model: model); //video download-download provider
                _model = null;
                notifyListeners();
              }
            }
            setProgress(tempProgress);
            debugPrint("Total Progress 1 :: $_progress%");
          }
        },
      );
    } catch (e) {
      _model = null;
      showCustomSnackBar(e.toString());
    }
    // }
  }

  Future<void> _checkDirectory(bool isPdf, {bool? isAudio = false}) async {
    String path = await PathHelper.getDownloadDirectoryPath(isPdf, isAudio: isAudio);
    debugPrint('Path :: $path');
    bool result = await PathHelper.directoryExits(path);
    if (!result) {
      Directory directory = await PathHelper.createDirectory(path, recursive: true);
      debugPrint('Directory Path :: ${directory.path}');
    }
  }

  Future<void> _getSingleVideo(String videoFile, {VideoResponse? model}) async {
    if (model == null) return;
    final dbHelper = ref.read(databaseProvider);
    VideoModal? res = await dbHelper.getSingleVideo(model.id!.toString());
    if (res == null) {
      _saveCategoryAndVideo(videoFile, model: model); //_getSingleVideo
    }
  }

  Future<void> _getSinglePdf(String pdfFile, {PdfResponse? model}) async {
    if (model == null) return;
    final dbHelper = ref.read(databaseProvider);
    PdfModel? res = await dbHelper.getSinglePdf(model.id!.toString());
    if (res == null) {
      _saveCategoryAndVideo(pdfFile, pdfModel: model); //_getSinglePdf
    }
  }

  ///save category vedio ,pdf,audio
  Future<void> _saveCategoryAndVideo(String videoFile, {VideoResponse? model, PdfResponse? pdfModel, bool isPdf = false, bool isAudio = false}) async {
    print('-------audio or video model------++++${model}');
    print('-------pdf download model------++++${pdfModel?.toJson()}');
    print('-------file url------++++${videoFile}');
    CategoryModal? res;
    CategoryModal? Pdfres;
    final dbHelper = ref.read(databaseProvider);
    print("-------pdfModel?.categoryId------++++${pdfModel?.categoryId}");
    if (isPdf) {
      Pdfres = await dbHelper.getSinglePdfCategory(pdfModel?.categoryId?.toString() ?? "");
    } else if (isAudio) {
      res = await dbHelper.getAudioSingleCategory(model?.categoryId?.toString() ?? "");
    } else {
      res = await dbHelper.getSingleCategory(model?.categoryId?.toString() ?? "");
    }
    print("-------348------++++${res?.toJson()}");

    if (isPdf) {
      if (Pdfres != null) {
        print("-------pdf response when download------++++${Pdfres.toJson()}");

        PdfModel vModal = PdfModel(categoryId: pdfModel?.categoryId, pdfId: pdfModel?.id.toString(), pdfName: pdfModel?.title, categoryTitle: pdfModel?.categoryTitle, pdfFile: videoFile);
        int vRes = await dbHelper.savePDF(vModal);
        if (vRes > 0) {
          Pdfcomplate = true;
          _isPdfDownloading = false;
          showCustomSnackBar('PDF downloaded Successfully');
          _isDownloadComplete = false;
          _pdfModel = null;
          Pdfres = null;
          notifyListeners();
        }
      } else {
        print("-------pdf response when download when category not avail------++++${Pdfres?.toJson()}");
        CategoryModal modal = CategoryModal(categoryId: pdfModel?.categoryId?.toString(), categoryName: pdfModel?.categoryTitle ?? pdfModel?.category?.title, categoryImage: pdfModel?.category?.imageResponse?.imageUrl);
        int cRes = await dbHelper.savePdfCategory(modal);
        print("-------374------++++$cRes");
        if (cRes > 0) {
          CategoryModal? res = await dbHelper.getSinglePdfCategory(pdfModel?.categoryId?.toString() ?? "");
          PdfModel vModal = PdfModel(categoryId: pdfModel?.categoryId, pdfId: pdfModel?.id.toString(), pdfName: pdfModel?.title, categoryTitle: pdfModel?.categoryTitle, pdfFile: videoFile);
          print("-------383------++++$res");
          print(vModal.toJson());
          int vRes = await dbHelper.savePDF(vModal);
          print("--------386-----++++$vRes");
          if (vRes > 0) {
            Pdfcomplate = true;
            _isPdfDownloading = false;
            showCustomSnackBar('PDF downloaded Successfully');
            _isDownloadComplete = false;
            _pdfModel = null;
            Pdfres = null;
            notifyListeners();
          }
        }
      }
    } else if (isAudio) {
      if (res != null) {
        if (model == null) return;
        VideoModal vModal = VideoModal(categoryId: model.categoryId, videoId: model.id.toString(), videoThumbnail: model.thumbnailImageUrlSrc, videoName: model.title, videoFile: videoFile, videoDuration: model.duration);
        int vRes = await dbHelper.saveAudio(vModal);
        if (vRes > 0) {
          complate = true;
          showCustomSnackBar('Audio downloaded Successfully');
          _isDownloadComplete = false;
          res = null;
          notifyListeners();
        }
      } else {
        CategoryModal modal = CategoryModal(categoryId: model?.categoryId?.toString(), categoryName: model?.categoryTitle ?? model?.category?.title, categoryImage: model?.category?.imageResponse?.imageUrl);
        int cRes = await dbHelper.saveAudioCategory(modal);
        CategoryModal? res = await dbHelper.getAudioSingleCategory(model?.categoryId?.toString() ?? "");
        print("after category s--->${cRes}");
        if (cRes > 0) {
          VideoModal vModal = VideoModal(categoryId: int.parse(res?.categoryId ?? ""), videoId: model?.id.toString(), videoThumbnail: model?.thumbnailImageUrlSrc ?? "", videoName: model?.title, videoFile: videoFile, videoDuration: model?.duration);
          int vRes = await dbHelper.saveAudio(vModal);
          if (vRes > 0) {
            complate = true;
            showCustomSnackBar('Audio downloaded Successfully');
            _isDownloadComplete = false;
            res = null;
            notifyListeners();
          }
        }
      }
    } else {
      if (res != null) {
        if (model == null) return;
        VideoModal vModal = VideoModal(categoryId: model.categoryId, videoId: model.video?.id.toString(), videoThumbnail: model.thumbnailImageUrlSrc, videoName: model.title, videoFile: videoFile, videoDuration: model.duration);
        int vRes = await dbHelper.saveVideo(vModal);
        if (vRes > 0) {
          complate = true;
          showCustomSnackBar('Video downloaded Successfully');
          _isDownloadComplete = false;
          res = null;
          notifyListeners();
        }
      } else {
        CategoryModal modal = CategoryModal(categoryId: model?.categoryId?.toString(), categoryName: model?.categoryTitle ?? model?.category?.title, categoryImage: model?.category?.imageResponse?.imageUrl);
        int cRes = await dbHelper.saveCategory(modal);
        CategoryModal? res = await dbHelper.getSingleCategory(model?.categoryId?.toString() ?? "");
        print("after category s--->${cRes}");
        if (cRes > 0) {
          VideoModal vModal =
              VideoModal(categoryId: int.parse(res?.categoryId ?? ""), videoId: model?.video?.id.toString(), videoThumbnail: model?.thumbnailImageUrlSrc ?? "", videoName: model?.title, videoFile: videoFile, videoDuration: model?.duration);
          int vRes = await dbHelper.saveVideo(vModal);
          if (vRes > 0) {
            complate = true;
            showCustomSnackBar('Video downloaded Successfully');
            _isDownloadComplete = false;
            res = null;
            notifyListeners();
          }
        }
      }
    }

    //cRes==1 first time insert ni condition
  }

  bool _isAlreadyDownload = false;

  bool get isAlreadyDownload => _isAlreadyDownload;

  ///check video,audio or pdf download or not
  Future<bool> checkVideoIsDownload(String id, bool isPdf, bool isAudio) async {
    final dbHelper = ref.read(databaseProvider);
    Object? res;
    if (isPdf) {
      res = await dbHelper.getSinglePdf(id);
    } else if (isAudio) {
      res = await dbHelper.getSingleAudio(id);
    } else {
      res = await dbHelper.getSingleVideo(id);
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
