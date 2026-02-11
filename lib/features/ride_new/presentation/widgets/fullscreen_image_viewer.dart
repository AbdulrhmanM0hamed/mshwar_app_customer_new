import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

/// Full Screen Image Viewer - Displays an image in full screen with zoom support
class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final File? imageFile;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        color: Colors.black,
        child: Hero(
          tag: imageUrl,
          child: PhotoView(
            imageProvider: imageFile == null
                ? NetworkImage(imageUrl)
                : Image.file(imageFile!).image,
          ),
        ),
      ),
    );
  }
}
