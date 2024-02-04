import 'package:flutter/material.dart';
import 'package:kaz_app_kaz/colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
  import 'package:http/http.dart' as http;

class ViewImageScreen extends StatelessWidget {
  final List<dynamic> imagePaths;
  final int initialIndex;

  ViewImageScreen({required this.imagePaths, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor:Theme.of(context).colorScheme.background,
        title: const Text('عرض الصورة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveImage(context, imagePaths[initialIndex]);
            },
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        itemCount: imagePaths.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
              'http://192.168.0.190/project/imgges/' + (imagePaths[index] ?? ''),
            ),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color:Theme.of(context).colorScheme.background,
        ),
        pageController: PageController(initialPage: initialIndex),
        onPageChanged: (index) {
          // صفحة تغيير المنظر
        },
      ),
    );
  }

  Future<void> _saveImage(BuildContext context, String imagePath) async {
    try {
      var response = await http.get(
        Uri.parse('http://192.168.0.190/project/imgges/$imagePath'),
      );

      final result = await ImageGallerySaver.saveImage(
        response.bodyBytes,
        quality: 100,
      );

      if (result != null && result.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ الصورة في الهاتف')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل حفظ الصورة في الهاتف')),
        );
      }
    } catch (e) {
      print('Error saving image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء حفظ الصورة في الهاتف')),
      );
    }
  }
}
