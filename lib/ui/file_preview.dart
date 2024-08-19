import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:souq_aljomaa/main.dart';
import 'package:souq_aljomaa/utils.dart';

class FilePreview extends StatelessWidget {
  final String filePath;

  const FilePreview(this.filePath, {super.key});

  @override
  Widget build(BuildContext context) {
    if (isImage(filePath)) {
      if (isRemoteUrl(filePath)) {
        return Image(image: NetworkImage(filePath));
      } else if(isFileExist(filePath)) {
        return Image(image: FileImage(File(filePath)));
      }
      return Center(child: Text('Invalid Uri ($filePath)'));
    } else if (filePath.endsWith('.pdf')) {
      if (isRemoteUrl(filePath)) {
        return PdfViewer.uri(Uri.parse(filePath));
      } else if(isFileExist(filePath)) {
        return PdfViewer.file(filePath);
      }
      return Center(child: Text('Invalid Uri ($filePath)'));
    } else {
      return const Center(child: Text('Unsupported file type ()'));
    }
  }
}
