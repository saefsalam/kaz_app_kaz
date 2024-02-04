// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kaz_app_kaz/get%20post%20frome%20data/links.dart';
import 'package:kaz_app_kaz/screens/imgPetailPage.dart';
import 'package:logging/logging.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List posts = [];
  int currentPage = 1; // Track the current page of posts
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> loadData() async {
    try {
      List<dynamic> newPosts = await fetchPosts(currentPage);
      if (newPosts.isNotEmpty) {
        posts.addAll(newPosts);
        currentPage++;
      }
    } catch (error) {
      print("Error loading data: $error");
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<List<dynamic>> fetchPosts(int page) async {
    final response = await http
        .get(Uri.parse("http://192.168.0.190/project/getposts.php?page=$page"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  Future<void> fetchPostDetails(dynamic postId) async {
    try {
      Map<String, dynamic> post = await fetchPost(postId);

      showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.primary,
        context: context,
        builder: (BuildContext context) {
          return ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'تفاصيل المنشور',
                      style: TextStyle(fontFamily: "Cairo",
                        fontSize: 24.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      '  ${post['news_title_ar'] ?? ''}',
                      style: const TextStyle(fontFamily: "Cairo",fontSize: 18.0),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '  ${post['news_desc_ar'] ?? ''}',
                      style: const TextStyle(fontFamily: "Cairo",fontSize: 18.0),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '  ${post['news_date'] ?? ''}',
                      style: const TextStyle(fontFamily: "Cairo",fontSize: 18.0),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 16.0),
                    CarouselSlider(
                      items: (post['news_covers'] as List<dynamic>?)
                              ?.map<Widget>((coverPath) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewImageScreen(
                                      imagePaths: post['news_covers'],
                                      initialIndex: post['news_covers']
                                          .indexOf(coverPath),
                                    ),
                                  ),
                                );
                              },
                              child: Container(height: double.infinity,width: double.infinity,decoration: BoxDecoration( border: Border.all(width: 1),borderRadius: BorderRadius.circular(8)),
                                child: Image.network(
                                  'http://192.168.0.190/project/imgges/' +
                                      (coverPath ?? ''),
                                  fit: BoxFit.cover,
                                ),
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
                    ),
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
    final response =
        await http.get(Uri.parse("http://192.168.0.190/project/getposts.php"));

    if (response.statusCode == 200) {
      List<dynamic> postsList = json.decode(response.body);

      Map<String, dynamic>? post = postsList.firstWhere(
        (element) => element['news_id'] == id.toString(),
        orElse: () => null,
      );

      if (post != null) {
        return Map<String, dynamic>.from(post);
      } else {
        throw Exception('لم يتم العثور على المنشور');
      }
    } else {
      throw Exception('فشل في استرجاع المنشور');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Reached the end of the list, load the next set of posts
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });

        fetchPosts(currentPage).then((newPosts) {
          if (newPosts.isNotEmpty) {
            posts.addAll(newPosts);
            currentPage++;
          }
          setState(() {
            isLoading = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> postData = posts[index];
             return InkWell(
  onTap: () {
    fetchPostDetails(postData['news_id']);
  },
  child: Card(
    margin: const EdgeInsets.all(13.0),
    color: Theme.of(context).colorScheme.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: postData.isEmpty // التحقق مما إذا كانت بيانات المنشور فارغة
        ? Center(
           child: Container(height: 450,width:double.infinity ,margin: const EdgeInsets.all(16),color: Colors.grey.shade700,decoration: const BoxDecoration(  borderRadius: BorderRadius.all(Radius.circular(100),)),),// عرض مؤشر التحميل
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  IMG + postData['news_cover'],
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    Logger.root.severe('Error loading image: $error',);
                    return Center(
                      child: Image.asset(
                        "assets/icon.PNG",
                        height: 200,
                        width: 200,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      postData['news_title_ar'] ?? '',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontFamily: "Cairo",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      postData['news_desc_ar'] ?? '',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontFamily: "Cairo",fontSize: 16.0),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      postData['news_date'] ?? '',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontFamily: "Cairo",
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 8,)
                  ],
                ),
              ),
            ],
          ),
  ),
);


          },
        ),
      ),
    );
  }
}
