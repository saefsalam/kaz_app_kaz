import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue, // Light mode primary color
       
        // Add more colors as needed
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.teal, // Dark mode primary color
        
      ),
      home: MyApp21(),
    ),
  );
}

class MyApp21 extends StatefulWidget {
  const MyApp21({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp21> {
  List<String> videoUrls = [
    'https://live.aljawadain.org/live/broadcast/playlist.m3u8',
    'https://live.aljawadain.org/live/aljawadaintv/playlist.m3u8',
    // Add more video URLs as needed
  ];

  int currentVideoIndex = 0;

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(
      videoUrls[currentVideoIndex],
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    chewieController = ChewieController(
      errorBuilder: (context, errorMessage) => Text("حاول  مرة اخرى "),
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        videoPlayerController.pause();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          title: const Center(
            child: Text("البث المباشر"),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Chewie(controller: chewieController),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: videoUrls.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          index == 0 ? 'بث الجوادين' : 'قناة الجوادين',
                          style: TextStyle(
                            fontFamily: "Cairo",
                            color: Theme.of(context).textTheme.bodyText1!.color, // Use the text color from the current theme
                            fontSize: 20,
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          currentVideoIndex = index;
                          videoPlayerController = VideoPlayerController.network(
                            videoUrls[currentVideoIndex],
                            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
                          );
                          chewieController.dispose();
                          chewieController = ChewieController(
                            videoPlayerController: videoPlayerController,
                            aspectRatio: 3 / 2,
                            autoPlay: true,
                            looping: true,
                          );
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
