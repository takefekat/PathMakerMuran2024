import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'fieldWidget.dart';
import 'dropDownButton.dart';
import 'common.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<List<Arrow>> arrowsAll = List.generate(MOUSE_NUM, (_) => []);
  List<int> moucePathMode = List.generate(MOUSE_NUM, (_) => 0);
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    // 初期位置を設定
    if (arrowsAll[0].isEmpty) {
      arrowsAll[0].add(Arrow(0, 0, const Offset(0, 0)));
      // arrowsAll[0].add(Arrow(1, 1, const Offset(0, 0))); // 32x32の場合
    }
    if (arrowsAll[1].isEmpty) {
      arrowsAll[1].add(Arrow(0, MAZE_SIZE - 1, const Offset(0, 0)));
    }
    if (arrowsAll[2].isEmpty) {
      arrowsAll[2].add(Arrow(MAZE_SIZE - 1, 0, const Offset(0, 0)));
    }
    if (arrowsAll[3].isEmpty) {
      arrowsAll[3].add(Arrow(MAZE_SIZE - 1, MAZE_SIZE - 1, const Offset(0, 0)));
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
              // マス目状の盤面
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
                  CustomDropdown(
                    selectedValue: moucePathMode[0],
                    mouceIndex: 0,
                    onChanged: (int? value) {
                      setState(() {
                        moucePathMode[0] = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 32), // ボタン間のスペース
                  CustomDropdown(
                    selectedValue: moucePathMode[1],
                    mouceIndex: 1,
                    onChanged: (int? value) {
                      setState(() {
                        moucePathMode[1] = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 32), // ボタン間のスペース
                  CustomDropdown(
                    selectedValue: moucePathMode[2],
                    mouceIndex: 2,
                    onChanged: (int? value) {
                      setState(() {
                        moucePathMode[2] = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 32), // ボタン間のスペース
                  CustomDropdown(
                    selectedValue: moucePathMode[3],
                    mouceIndex: 3,
                    onChanged: (int? value) {
                      setState(() {
                        moucePathMode[3] = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 32), // ボタン間のスペース
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
                  const SizedBox(height: 32), // ボタン間のスペース
                  // 決定ボタン
                  ElevatedButton(
                    onPressed: () {
                      // 決定ボタンが押されたときの処理
                      print('決定 button pressed');
                      sendArrows();
                    },
                    child: Text('経路決定'),
                  ),
                  const SizedBox(height: 32), // ボタン間のスペース
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
              flex: 2, // Column 1:6:1の比率で分割
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomDropdown(
                    selectedValue: moucePathMode[0],
                    mouceIndex: 0,
                    onChanged: (int? value) {
                      setState(() {
                        moucePathMode[0] = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 16), // ボタン間のスペース
                  CustomDropdown(
                    selectedValue: moucePathMode[1],
                    mouceIndex: 1,
                    onChanged: (int? value) {
                      setState(() {
                        moucePathMode[1] = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 16), // ボタン間のスペース
                  CustomDropdown(
                    selectedValue: moucePathMode[2],
                    mouceIndex: 2,
                    onChanged: (int? value) {
                      setState(() {
                        moucePathMode[2] = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 16), // ボタン間のスペース
                  CustomDropdown(
                    selectedValue: moucePathMode[3],
                    mouceIndex: 3,
                    onChanged: (int? value) {
                      setState(() {
                        moucePathMode[3] = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            // 32x32のマス目状の盤面
            Expanded(
              flex: 7,
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
                        for (int i = 0; i < MOUSE_NUM; i++)
                          arrowsAll[i].clear();
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
    try {
      final socket =
          await Socket.connect(ip, port, timeout: const Duration(seconds: 5));
      // 各マウスの経路を送信
      List<Map<String, dynamic>> paths = [];
      for (int i = 0; i < MOUSE_NUM; i++) {
        List<int> path = [];
        for (Arrow arrow in arrowsAll[i]) {
          path.add(arrow.x);
          path.add(MAZE_SIZE - arrow.y - 1);
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
