import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

Future<File> compressImage(File file) async {
  if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
    // Compression not supported; return the original file
    return file;
  }

  final dir = await getTemporaryDirectory();
  final targetPath =
      "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

  final compressedFile = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 70,
  );

  return compressedFile != null ? File(compressedFile.path): file;
}

