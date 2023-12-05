import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageDetailPage extends StatelessWidget {
  final String imageUrl;

  ImageDetailPage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.transparent, // جعل الخلفية شفافة
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 16.0, // ضبط الهوامش اليسرى حسب الحاجة
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: PhotoViewGallery.builder(
                scrollPhysics: BouncingScrollPhysics(),
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(imageUrl),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                itemCount: 1,
                backgroundDecoration: BoxDecoration(
                  color: Colors.black,
                ),
                pageController: PageController(),
                enableRotation: false,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
