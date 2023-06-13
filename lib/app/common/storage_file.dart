import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageFile {
  Future<String>? saveFile({required File fileData}) async {
    try {
      //await Permission.manageExternalStorage.request();

      await requestPermission(Permission.manageExternalStorage);

      Directory? directory;

      directory = await getExternalStorageDirectory();

      String newPath = "";
      List<String> folders = directory!.path.split("/");
      for (int x = 1; x < folders.length; x++) {
        String folder = folders[x];
        if (folder != "Android") {
          newPath += "/$folder";
        } else {
          break;
        }
      }

      newPath = "$newPath/ImagesApp";
      directory = Directory(newPath);
      final fileAndPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await fileData.copy(fileAndPath);
      }
      return fileAndPath;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> removeFile({required String path}) async {
    try {
      await File(path).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
