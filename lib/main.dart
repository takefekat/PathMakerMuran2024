import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'fieldWidget.dart';
import 'common.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<List<Arrow>> arrowsAll = List.generate(3, (_) => []);
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    // 初期位置を設定
    if (arrowsAll[0].isEmpty) {
      arrowsAll[0].add(Arrow(1, 1, const Offset(0, 0)));
    }
    if (arrowsAll[1].isEmpty) {
      arrowsAll[1].add(Arrow(1, 30, const Offset(0, 0)));
    }
    if (arrowsAll[2].isEmpty) {
      arrowsAll[2].add(Arrow(30, 1, const Offset(0, 0)));
    }
    return MaterialApp(
      home: Scaffold(
        // フィールドが小さくなるので、消す。
        // appBar: AppBar(
        //   title: Text('電光石火ぴかぴかクリーナーズ'),
        // ),
        body: orientation == Orientation.portrait
            ? _buildPortraitLayout()
            : _buildLandscapeLayout(),
      ),
    );
  }

  // 横向きのレイアウト
  Widget _buildLandscapeLayout() {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 3,
              // 32x32のマス目状の盤面
              child: FieldWidget(
                arrowsAll: arrowsAll,
                selectedIndex: selectedIndex,
                onSelectedIndexChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
            // リセット & スタートボタン
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // リセットボタン
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        arrowsAll[0].clear();
                        arrowsAll[1].clear();
                        arrowsAll[2].clear();
                      });
                    },
                    child: const Text('リセット'),
                  ),
                  const SizedBox(width: 16), // ボタン間のスペース
                  // 決定ボタン
                  ElevatedButton(
                    onPressed: () {
                      // 決定ボタンが押されたときの処理
                      print('決定 button pressed');
                      sendArrows();
                    },
                    child: Text('経路決定'),
                  ),
                  const SizedBox(width: 16), // ボタン間のスペース
                  // スタートボタン
                  ElevatedButton(
                    onPressed: () {
                      // スタートボタンが押されたときの処理
                      print('Start button pressed');
                      sendMsg('start');
                    },
                    child: Text('スタート'),
                  ),
                  const SizedBox(width: 16), // ボタン間のスペース
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 縦向きのレイアウト
  Widget _buildPortraitLayout() {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            // Auto / ボタンの行
            Expanded(
              flex: 1, // Column 1:5:1の比率で分割
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mouceColors[0],
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    onPressed: () {
                      selectedIndex = 0;
                    },
                    child: const Text(''),
                  ),
                  const SizedBox(width: 16), // ボタン間のスペース
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mouceColors[1],
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    onPressed: () {
                      selectedIndex = 1;
                    },
                    child: const Text(''),
                  ),
                  const SizedBox(width: 16), // ボタン間のスペース
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mouceColors[2],
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    onPressed: () {
                      selectedIndex = 2;
                    },
                    child: const Text(''),
                  ),
                ],
              ),
            ),
            // 32x32のマス目状の盤面
            Expanded(
              flex: 6,
              child: FieldWidget(
                arrowsAll: arrowsAll,
                selectedIndex: selectedIndex,
                onSelectedIndexChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
            // リセット & スタートボタン
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // リセットボタン
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        arrowsAll[0].clear();
                        arrowsAll[1].clear();
                        arrowsAll[2].clear();
                      });
                    },
                    child: const Text('リセット'),
                  ),
                  const SizedBox(width: 16), // ボタン間のスペース
                  // 決定ボタン
                  ElevatedButton(
                    onPressed: () {
                      // 決定ボタンが押されたときの処理
                      print('決定 button pressed');
                      sendArrows();
                    },
                    child: Text('経路決定'),
                  ),
                  const SizedBox(width: 16), // ボタン間のスペース
                  // スタートボタン
                  ElevatedButton(
                    onPressed: () {
                      // スタートボタンが押されたときの処理
                      print('Start button pressed');
                      sendMsg('start');
                    },
                    child: Text('スタート'),
                  ),
                  const SizedBox(width: 16), // ボタン間のスペース
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendArrows() async {
    final ip = '192.168.251.3'; // PCのIPアドレス
    final port = 1250; // PCのポート
    try {
      final socket =
          await Socket.connect(ip, port, timeout: Duration(seconds: 5));
      // 各マウスの経路を送信
      List<Map<String, dynamic>> paths = [];
      for (int i = 0; i < mouceNum; i++) {
        List<int> path = [];
        for (Arrow arrow in arrowsAll[i]) {
          path.add(arrow.x);
          path.add(arrow.y);
        }
        paths.add({
          'mouse_id': i,
          'path': path,
        });
      }
      final body = json.encode({'paths': paths});
      try {
        socket.write(body);
        await socket.flush();
        socket.close();
        print('Data sent successfully');
      } catch (e) {
        print('Error while sending data: $e');
      }
    } catch (e) {
      print('Error connecting to server: $e');
    }
  }

  void sendMsg(String msg) async {
    final ip = '192.168.251.3'; // PCのIPアドレス
    final port = 1250; // PCのポート
    try {
      final socket =
          await Socket.connect(ip, port, timeout: Duration(seconds: 5));

      final body = json.encode({'signal': msg});
      try {
        socket.write(body);
        await socket.flush();
        socket.close();
        print('Data sent successfully');
      } catch (e) {
        print('Error while sending data: $e');
      }
    } catch (e) {
      print('Error connecting to server: $e');
    }
  }
}
