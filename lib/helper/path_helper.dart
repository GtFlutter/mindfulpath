import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PathHelper {
  static Future<String> getDownloadDirectoryPath(bool isPdf) async {
    Directory directory = await getApplicationSupportDirectory();
    if(isPdf){
      return '${directory.path}/PDF';
    }
    return '${directory.path}/Video';
  }

  static Future<Directory> createDirectory(String directoryPath, {bool recursive = false}) async => Directory(directoryPath).create(recursive: recursive);

  static Future<bool> directoryExits(String directoryPath) async => Directory(directoryPath).exists();

  static Future<bool> fileExists(String fileDir) async => File(fileDir).exists();

  // static Future<FileSystemEntity> deleteDirectory(String directoryPath, {bool recursive = false}) async => Directory(directoryPath).delete(recursive: recursive);
}