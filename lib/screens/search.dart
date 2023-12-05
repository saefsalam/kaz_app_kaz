import 'package:flutter/material.dart';
import 'package:kaz_app_kaz/get%20post%20frome%20data/getimgcontroller.dart';
import 'package:logging/logging.dart';


class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}


class _SearchState extends State<Search> {
  List posts1 = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      posts1 = await GetImgController().getimg();
    } catch (error) {
      Logger.root.severe('Error loading data: $error');
      print("Error loading data: $error");
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              print(posts1);
            },
            icon: Icon(Icons.abc),
          )
        ],
        title: Text("Search Screen"),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: posts1.length,
        itemBuilder: (context, index) {
          // افترض أن لديك خاصية تحمل مسار الصورة في الكائن
          String? imagePath = posts1[index]['image_path'];

          // التحقق من أن imagePath ليست قيمة null قبل استخدامها
          if (imagePath != null && imagePath is String) {
            return Image.asset(imagePath, fit: BoxFit.cover);
          } else {
            // يمكنك التعامل مع الحالة عندما imagePath يكون null
            return Container(); // أو أي عنصر بديل تريده
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Search(),
  ));
}
