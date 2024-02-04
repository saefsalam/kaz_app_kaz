// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

 

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaz_app_kaz/colors.dart';
import 'package:kaz_app_kaz/screens/addpost.dart';
import 'package:kaz_app_kaz/screens/profile.dart';

import 'package:kaz_app_kaz/screens/tabs/tabbar.dart';
import 'package:kaz_app_kaz/screens/visitpage.dart';

// import 'package:instagram_app/screens/add_post.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class MobileScerren extends StatefulWidget {
  const MobileScerren({Key? key}) : super(key: key);

  @override
  State<MobileScerren> createState() => _MobileScerrenState();
}

class _MobileScerrenState extends State<MobileScerren> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).colorScheme.primary,
      bottomNavigationBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onTap: (index) {
            // navigate to the tabed page
            _pageController.jumpToPage(index);
            setState(() {
              currentPage = index;
            });

            // print(   "---------------    $index "  );
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: currentPage == 0 ? secondaryColor : primaryColor1,
                ),
                label: "الرىيسية",),
            
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.live_tv_outlined,
                  color: currentPage == 1 ? secondaryColor : primaryColor1,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu_book_outlined,
                  color: currentPage == 2 ? secondaryColor : primaryColor1,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: currentPage == 3 ? secondaryColor : primaryColor1,
                ),
                label: ""),
          ]),
      body: PageView(
        onPageChanged: (index) {
          print("------- $index");
        },
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          TabBars(),
          MyApp21(),
          VisitPage(),
          SettingsPage(),
        ],
      ),
    );
  }
}
