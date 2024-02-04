
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.background,
      toolbarHeight: 60,
        title: const Text(
          'الاعدادات ',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // اللوجو في الأعلى
            SvgPicture.asset(
              'assets/svg/icon.svg',
              height: 150,
              width: 150,
            ),
            const Spacer(),
            // إصدار التطبيق
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'إصدار التطبيق: 1.0.0',
                style: TextStyle(fontSize: 18 ,fontFamily: "Cairo",),
              ),
            ),

            // تقييم التطبيق
            const Padding(
              padding: EdgeInsets.all(16.0),
              
            ),

            // تواصل معنا
            ElevatedButton(
              onPressed: () {
                // يمكنك هنا إضافة الشيفرة لفتح شاشة الاتصال بنا
                // مثلاً Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsScreen()));
              },
              child: const Text('تواصل معنا'),
            ),
            const Spacer(),
            // أيقونات وروابط التواصل الاجتماعي
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSocialIcon(
                      'assets/svg/facebook.svg', 'https://www.facebook.com/Aljawadain.IQ/'),
                  buildSocialIcon(
                      'assets/svg/twitter.svg', 'https://twitter.com/AlJawadainiq'),
                  buildSocialIcon('assets/svg/youtube.svg',
                      'http://www.youtube.com/c/AljawadainHolyShrine'),
                  buildSocialIcon('assets/svg/instagram.svg',
                      'http://www.instagram.com/aljawadain.iq/'),
                ],
              ),
            ),
            const Spacer(),
             
          ],
        ),
      ),
    );
  }

  Widget buildSocialIcon(String svgPath, String url) {
    return InkWell(
      onTap: () {
        // يمكنك هنا إضافة الشيفرة لفتح الرابط المقابل لكل أيقونة
        launchURL(url);
      },
      child: SvgPicture.asset(svgPath, height: 50, width: 50),
    );
  }

 void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceWebView: false,
      enableJavaScript: true, // يمكنك تعيين معلمات أخرى حسب الحاجة
    );
  } else {
    throw 'تعذر فتح $url';
  }
}

}
