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
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Image.asset('images/Cleaner.png'),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          // スタートボタン
                          ElevatedButton(
                            onPressed: () {
                              // スタートボタンが押されたときの処理
                              print('Start button pressed');
                              sendMsg('start');
                            },
                            child: Text('スタート'),
                          ),
                          const SizedBox(height: 32), // ボタン間のスペース
                          // ストップボタン
                          ElevatedButton(
                            onPressed: () {
                              // ストップボタンが押されたときの処理
                              print('Start button pressed');
                              sendMsg('stop');
                            },
                            child: Text('ストップ'),
                          ),
                        ],
                      )),
                  /*
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    PathFind(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(-1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Image.asset('images/BackButton.png'),
                    ),
                  ),
                  */
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      child: Image.asset('images/FinishButton.png'),
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