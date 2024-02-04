import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaz_app_kaz/screens/home.dart';
import 'package:kaz_app_kaz/screens/search.dart';
import 'package:kaz_app_kaz/colors.dart';

class TabBars extends StatelessWidget {
  const TabBars({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: LightMode,
      darkTheme: LightMode,
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Center(
              child: SvgPicture.asset(
                "assets/svg/ICON 33-01.svg",
                
              ),
            ),
            toolbarHeight: 60,
            bottom: const TabBar(
              tabs: [
                Tab(text: ' الاخبار '),
                Tab(text: '  مكتبة الصور '),
              ],
              labelColor: secondaryColor,
              labelStyle: TextStyle(
                  fontFamily: "Cairo",
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
            // Apply theming logic to set text color
            iconTheme: IconThemeData(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
            actionsIconTheme: IconThemeData(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
            toolbarTextStyle: Theme.of(context)
                .textTheme
                .copyWith(
                  titleLarge: TextStyle(
                    fontFamily: "Cairo",
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black // Text color in light mode
                        : Colors.white, // Text color in dark mode
                  ),
                )
                .bodyMedium,
            titleTextStyle: Theme.of(context)
                .textTheme
                .copyWith(
                  titleLarge: TextStyle(
                    fontFamily: "Cairo",
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black // Text color in light mode
                        : Colors.white, // Text color in dark mode
                  ),
                )
                .titleLarge,
          ),
          body: const TabBarView(
            children: [
              Home(),
              Search(),
            ],
          ),
        ),
      ),
    );
  }
}
