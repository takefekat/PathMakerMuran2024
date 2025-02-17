import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'fieldWidget.dart';
import 'dropDownButton.dart';
import 'common.dart';
import 'dart:async'; // Timerクラスを使用するために必要
import 'dart:convert';
import 'dart:typed_data';
import 'screenObjRcg.dart';
import 'package:video_player/video_player.dart';
import 'config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/home.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          print("mode:objRcg");
          sendMsg("mode:objRcg");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ObjectRecognition()),
          ).then((value) {
            print("mode:home");
            sendMsg("mode:home");
          });
        },
        child: Center(
          child: DESIGN_MODE == MODE_DN
              ? (_controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                  : CircularProgressIndicator())
              : Stack(
                  children: [
                    // 背景画像
                    Positioned.fill(
                      child: Image.asset(
                        'images/06.jpg',
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.3), // 透明度を設定
                        colorBlendMode: BlendMode.dstATop, // ブレンドモードを設定
                      ),
                    ),
                    // 中央に配置されたアイコン
                    Center(
                      child: Image.asset(
                        'images/icon.png',
                        //width: 100, // アイコンの幅を指定
                        //height: 100, // アイコンの高さを指定
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
