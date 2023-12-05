// في ملف links.dart

// في ملف getimgcontroller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaz_app_kaz/get%20post%20frome%20data/links.dart';

// تأكيد تعديل المسار حسب مكان الملف

class GetImgController {
  Future getimg() async {
    var url = GETIMG1;

    // إجراء طلب HTTP GET إلى السكريبت PHP
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      // فك تشفير الاستجابة JSON
      var data1 = jsonDecode(res.body);

      // طباعة البيانات
      print(data1);
      
      return data1;
    }
  }
}
