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
import 'main.dart';
import 'screenPathFind.dart';
import 'config.dart';

class CleanerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: DESIGN_MODE == MODE_DN
                ? AssetImage('images/BackGround.png')
                : AssetImage('images/06.jpg'), // 画像のパスを指定
            fit: BoxFit.cover, // 画面いっぱいに表示
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // 透明度を設定
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.loose,
                  children: [
                    DESIGN_MODE == MODE_DN
                        ? Image.asset('images/Cleaner.png')
                        : Image.asset('images/CleanerJQ.png'),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height *
                          0.05, // 画面の高さの10%を指定
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // スタートボタン
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () {
                                print('Start button pressed');
                                sendMsg('start');
                              },
                              child: DESIGN_MODE == MODE_DN
                                  ? Image.asset('images/StartButton.png')
                                  : Image.asset('images/StartButtonJQ.png'),
                            ),
                          ),
                          const SizedBox(width: 32), // ボタン間のスペース
                          // ストップボタン
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () {
                                print('Stop button pressed');
                                sendMsg('stop');
                              },
                              child: DESIGN_MODE == MODE_DN
                                  ? Image.asset('images/StopButton.png')
                                  : Image.asset('images/StopButtonJQ.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          print("mode:home");
                          sendMsg("mode:home");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          ).then((value) {
                            print("mode:cleaner");
                            sendMsg("mode:cleaner");
                          });
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: DESIGN_MODE == MODE_DN
                              ? Image.asset('images/FinishButton.png')
                              : Image.asset('images/DOneJQ.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
