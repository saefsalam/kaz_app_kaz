import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kaz_app_kaz/get%20post%20frome%20data/getimgcontroller.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List posts1 = [];
  String baseUrl = 'http://192.168.0.190/project/';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      posts1 = await GetImgController().getimg();
    } catch (error) {
      print("Error loading data: $error");
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).colorScheme.background,
      
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: posts1.length,
        itemBuilder: (context, index) {
          String? imagePath = posts1[index]['image_path'];

          if (imagePath != null && imagePath is String) {
            String imageUrl = '$baseUrl/$imagePath';
            return InkWell(
              onTap: () {
                _openImage(context, imageUrl);
              },
              child: Image.network(imageUrl, fit: BoxFit.cover),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void _openImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageGalleryPage(
          images: [imageUrl],
        ),
      ),
    );
  }
}

class FullScreenImageGalleryPage extends StatefulWidget {
  final List<String> images;

  FullScreenImageGalleryPage({required this.images});

  @override
  _FullScreenImageGalleryPageState createState() =>
      _FullScreenImageGalleryPageState();
}

class _FullScreenImageGalleryPageState
    extends State<FullScreenImageGalleryPage> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text(" الصورة"),centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              await _saveImage(context, widget.images[pageController.page!.round()]);
            },
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        itemCount: widget.images.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.images[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        pageController: pageController,
      ),
    );
  }

  Future<void> _saveImage(BuildContext context, String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      Uint8List bytes = response.bodyBytes;
      await Image.network(imageUrl, fit: BoxFit.cover);  // لتظهر الصورة قبل السناك بار
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم حفظ الصورة في المعرض"),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      print("حدث خطأ أثناء حفظ الصورة: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("حدث خطأ أثناء حفظ الصورة"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: Search(),
  ));
}
