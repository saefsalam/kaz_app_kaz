import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kaz_app_kaz/colors.dart';
import 'package:kaz_app_kaz/get%20post%20frome%20data/links.dart';
import 'package:kaz_app_kaz/screens/ImageNewsDetail.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;


class GetPostsController {
  Future<List<dynamic>> getPosts() async {
  try {
    var url = "http://localhost/project/getposts.php";

    var response = await http.get(Uri.parse(url));

    print('استجابة الخادم: ${response.body}');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('فشل في جلب المنشورات');
    }
  } catch (error) {
    print('حدث خطأ أثناء جلب المنشورات: $error');
    throw Exception('فشل في جلب المنشورات');
  }
}

}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List posts = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      var controller = GetPostsController();
      posts = await controller.getPosts();
    } catch (error) {
      Logger.root.severe('حدث خطأ أثناء تحميل البيانات: $error');
      print("حدث خطأ أثناء تحميل البيانات: $error");
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> fetchPostDetails(dynamic postId) async {
    try {
      Map<String, dynamic> post = await fetchPost(postId);
      print('ID المنشور: ${post['news_id']}');

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تفاصيل المنشور',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'عنوان المنشور: ${post['news_title_ar']}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'وصف المنشور: ${post['news_desc_ar']}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'تاريخ المنشور: ${post['news_date']}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 16.0),
                    CarouselSlider(
                      items: (post['news_covers'] as List?)
                          ?.map<Widget>((coverPath) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageDetailPage(IMG + (coverPath ?? '')),
                              ),
                            );
                          },
                          child: Image.network(
                            IMG + (coverPath ?? ''),
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList() ??
                          <Widget>[],
                      options: CarouselOptions(
                        height: 200.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: true,
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('حدث خطأ: $e');
    }
  }

  Future<Map<String, dynamic>> fetchPost(dynamic id) async {
    try {
      var controller = GetPostsController();
      List<dynamic> postsList = await controller.getPosts();
      Map<String, dynamic>? post = postsList.firstWhere(
        (element) => element['news_id'] == id.toString(),
        orElse: () => null,
      );

      if (post != null) {
        return Map<String, dynamic>.from(post);
      } else {
        throw Exception('لم يتم العثور على المنشور');
      }
    } catch (e) {
      print('حدث خطأ: $e');
      throw Exception('فشل في جلب المنشور');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.messenger_outline,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.logout,
            ),
          ),
        ],
        backgroundColor: mobileBackgroundColor,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> postData = posts[index];
          return InkWell(
            onTap: () {
              fetchPostDetails(postData['news_id']);
            },
            child: Card(
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postData['news_title_ar'],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      postData['news_desc_ar'],
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      postData['news_date'],
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
