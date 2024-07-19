import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

abstract class FileManager {

  static Future<String> get appDir async {
    final appDataDir = await getApplicationSupportDirectory();
    return path.join(appDataDir.path, 'SouqAljomaa');
  }

  static Future<String> get imagesDir async {
    return path.join(await appDir, 'images');
  }

  static Future<bool> isFileExists(String path) async {
    return File(path).exists();
  }

  static Future<String> create(final String path) async {
    if(await isFileExists(path)) return path;
    final dir = await Directory(path).create(recursive: true);
    return dir.path;
  }


  static Future<String> saveImage(String imageDir) async {
    final imagesDirectory = await create(await imagesDir);
    final fileName = path.basename(imageDir);
    final newPath = path.join(imagesDirectory,fileName);
    await File(imageDir).copy(newPath);
    return newPath;
  }
}