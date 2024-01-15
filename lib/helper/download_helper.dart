import 'package:dio/dio.dart';

class DownloadHelper {
  static final DownloadHelper instance = DownloadHelper.internal();
  factory DownloadHelper() => instance;
  DownloadHelper.internal();


  CancelToken? _cancelToken;

  Future<Response> download(
    String urlPath,
    String savePath,
    {
      ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? requestQueryParams,
      Map<String, String>? requestHeaders
    }) async {
    try {
      _cancelToken = CancelToken();
      return await Dio().download(
        urlPath,
        savePath,
        cancelToken: _cancelToken,
        queryParameters: requestQueryParams,
        options: Options(
          headers: requestHeaders,
          responseType: ResponseType.bytes
        ),
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw Exception('Something went wrong, click to restart download');
      }
      rethrow;
    }
  }

  void cancel() => _cancelToken?.cancel();
}