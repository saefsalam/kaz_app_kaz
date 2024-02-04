import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class VisitPage extends StatefulWidget {
  @override
  _VisitPageState createState() => _VisitPageState();
}

class _VisitPageState extends State<VisitPage> {
  List<Map<String, dynamic>> data = [];
  String? selectedValue;
  DateTime? lastAddTime;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool submitted = false;

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.190/project/getvis.php'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      setState(() {
        data = responseData.cast<Map<String, dynamic>>();
        data = data.toSet().toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> postData(
      String id, String name, String email, String reason) async {
    if (lastAddTime != null &&
        DateTime.now().difference(lastAddTime!) < const Duration(minutes: 1)) {
      print('لم يمر وقت كافي بين الإضافات. يرجى المحاولة لاحقًا.');
      return;
    }

    final String url = 'http://192.168.0.190/project/postvis.php';
    final Map<String, dynamic> postData = {
      'id': id,
      'name': name,
      'email': email,
      'visit_behalf_of': reason,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: postData,
      );

      if (response.statusCode == 200) {
        print('تم تحديث البيانات بنجاح');
        lastAddTime = DateTime.now();
      } else {
        print('فشل في تحديث البيانات');
      }
    } catch (error) {
      print('حدث خطأ: $error');
    }
  }

  Future<void> _showDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تم طلب الزيارة'),
          content: const Text('شكرًا لك، تم استلام طلب الزيارة بنجاح.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(toolbarHeight: 60,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('الزيارة ب الانابة ',style: TextStyle(fontFamily: "Cairo",), ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(height: 10000,
              child: ListView(
                children: [
                  const Text(
                    "1.هــي إحــدى الخدمات المعنوية التي تقدمها العتبة الكـاظمية المقدسة عن طريـق إداء مـراسم الـزيارة والـدعاء نيـابةً عـن الزائرين الكرام.",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: "Cairo",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "2.تتيح للــزائر الـكريم ان يتـبرك بالــزيارة عــنه او عن ذويــه وأرحامه.",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: "Cairo",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "3.يـرجى ملى جـميع الـحقول بـصورة صـحيحة لاتمـام الطلـب. ",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: "Cairo",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'الاسم',
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintStyle: const TextStyle(fontFamily: "Cairo", color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'البريد الاكتروني',
                      fillColor: Colors.grey[200],
                      filled: true,
                      labelStyle: const TextStyle(fontFamily: "Cairo",color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال عنوان البريد الإلكتروني';
                      } else if (!RegExp(
                              r'\b[A-Za-z0-9._%+-]+@[A-Za-z0.9.-]+\.[A-Z|a-z]{2,}\b')
                          .hasMatch(value)) {
                        return 'الرجاء إدخال عنوان بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: reasonController,
                    decoration: InputDecoration(
                      labelText: '...نيابةً عن ',
                      fillColor: Colors.grey[200],
                      filled: true,
                      labelStyle: const TextStyle(fontFamily: "Cairo",color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال سبب الزيارة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    items: data.map((Map<String, dynamic> item) {
                      return DropdownMenuItem<String>(
                        value: item['idco'].toString(),
                        child: Text(item['name']),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'الدولة',
                      fillColor: Colors.grey[200],
                      filled: true,
                      labelStyle: const TextStyle(fontFamily: "Cairo",color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText: submitted && selectedValue == null
                          ? 'الرجاء اختيار قيمة'
                          : null,
                      errorStyle: const TextStyle(fontFamily: "Cairo",color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        submitted = true;
                      });
                      if (selectedValue == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('املء جميع الحقول'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (_formKey.currentState!.validate()) {
                        await postData(
                          selectedValue!,
                          nameController.text,
                          emailController.text,
                          reasonController.text,
                        );
                        _showDialog();
                      }
                    },
                    child: const Text(
                      'طلب الزيارة ',
                      style: TextStyle(fontFamily: "Cairo",color: Colors.black),
                    ),
                  ),
                  const SizedBox(height:8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    
  }
}
