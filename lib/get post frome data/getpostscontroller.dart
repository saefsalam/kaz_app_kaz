import 'dart:convert';
import 'package:kaz_app_kaz/get%20post%20frome%20data/links.dart';
import 'package:http/http.dart' as http;

class GetPostsController {
  Future<List<dynamic>> getPosts() async {
    try {
      var url = GETPOSTS; // قم بتغييره بعنوان الخادم الفعلي

      var res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print(data);
        return data;
      } else {
        print('فشل في جلب المنشورات. الرمز: ${res.statusCode}');
        print('الرسالة: ${res.body}');
        throw Exception('فشل في جلب المنشورات');
      }
    } catch (error) {
      print('حدث خطأ أثناء جلب المنشورات: $error');
      throw Exception('فشل في جلب المنشورات');
    }
  }
}
