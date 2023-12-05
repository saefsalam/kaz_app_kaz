import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ImageDetailPage extends StatelessWidget {
  final String imageUrl;

  ImageDetailPage(this.imageUrl);

  Future<void> _saveImage(BuildContext context) async {
    try {
      // جلب بايتات الصورة
      var response = await http.get(Uri.parse(imageUrl));
      List<int> bytes = response.bodyBytes;

      // حفظ الصورة في المعرض
      await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));

      // عرض رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حفظ الصورة بنجاح!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // عرض رسالة خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء حفظ الصورة'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveImage(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
    );
  }
}
