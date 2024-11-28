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

class CleanerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.loose,
                children: [
                  Image.asset('images/Cleaner.png'),
                  Align(
                    alignment: Alignment(0.0, 0.6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // スタートボタン
                        SizedBox(
                          width: 450, // Cleaner.pngの幅に合わせて設定
                          height: 100, // Cleaner.pngの高さに合わせて設定
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              print('Start button pressed');
                              sendMsg('start');
                            },
                            child: Image.asset('images/StartButton.png'),
                          ),
                        ),
                        const SizedBox(width: 32), // ボタン間のスペース
                        // ストップボタン
                        SizedBox(
                          width: 450, // Cleaner.pngの幅に合わせて設定
                          height: 100, // Cleaner.pngの高さに合わせて設定
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              print('Stop button pressed');
                              sendMsg('stop');
                            },
                            child: Image.asset('images/StopButton.png'),
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
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        ).then((value) {
                          print("mode:cleaner");
                          sendMsg("mode:cleaner");
                        });
                      },
                      child: Image.asset('images/FinishButton.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
