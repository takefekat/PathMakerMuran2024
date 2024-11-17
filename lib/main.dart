import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

const int mouceNum = 3;
const List<Color> mouceColors = [Colors.red, Colors.blue, Colors.green];

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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('電光石火ぴかぴかクリーナーズ'),
        ),
        body: Column(
          children: [
            // 色選択ボタンの行
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
              flex: 5, // 左右の幅を3:1に設定
              child: Padding(
                padding: const EdgeInsets.all(16.0), // 余白を追加 16px
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double gridSize =
                        min(constraints.maxWidth, constraints.maxHeight);
                    double cellSize = gridSize / 32;
                    return GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          // 初期位置を設定
                          if (arrowsAll[0].isEmpty) {
                            arrowsAll[0].add(Arrow(1, 1, details.delta));
                          }
                          if (arrowsAll[1].isEmpty) {
                            arrowsAll[1].add(Arrow(1, 30, details.delta));
                          }
                          if (arrowsAll[2].isEmpty) {
                            arrowsAll[2].add(Arrow(30, 1, details.delta));
                          }
                          // タッチされたマス目を特定
                          Offset position = details.localPosition;
                          int x = (position.dx / cellSize).floor();
                          int y = (position.dy / cellSize).floor();
                          // selectedIndexを特定
                          if (arrowsAll[0].last.x == x &&
                              arrowsAll[0].last.y == y) {
                            selectedIndex = 0;
                          } else if (arrowsAll[1].last.x == x &&
                              arrowsAll[1].last.y == y) {
                            selectedIndex = 1;
                          } else if (arrowsAll[2].last.x == x &&
                              arrowsAll[2].last.y == y) {
                            selectedIndex = 2;
                          }

                          // 外周には描画しない
                          if (x > 0 && x < 31 && y > 0 && y < 31) {
                            // 最終地点と隣接するセルにのみ移動可能
                            Arrow lastArrow = arrowsAll[selectedIndex].last;
                            if ((x != lastArrow.x || y != lastArrow.y) &&
                                (x - lastArrow.x).abs() <= 1 &&
                                (y - lastArrow.y).abs() <= 1) {
                              arrowsAll[selectedIndex]
                                  .add(Arrow(x, y, details.delta));
                              //セルの中心からの距離が0.5倍未満の場合のみ矢印を描画
                              double cellX = position.dx - (x + 0.5) * cellSize;
                              double cellY = position.dy - (y + 0.5) * cellSize;
                              if (cellX * cellX + cellY * cellY <
                                  cellSize * cellSize * 0.5 * 0.5) {
                                // 変化量が小さすぎる場合は無視
                                print(details.delta);
                                if (details.delta.dx.abs() > 1.5 ||
                                    details.delta.dy.abs() > 1.5) {
                                  arrowsAll[selectedIndex]
                                      .add(Arrow(x, y, details.delta));
                                }
                              }
                            }
                          }
                        });
                      },
                      child: CustomPaint(
                        size: Size(gridSize, gridSize),
                        painter: GridPainter(
                            cellSize: cellSize,
                            arrowsAll: arrowsAll,
                            selectedIndex: selectedIndex),
                      ),
                    );
                  },
                ),
              ),
            ),
            // リセット & スタートボタン
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
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
                      // スタートボタン
                      ElevatedButton(
                        onPressed: () {
                          // スタートボタンが押されたときの処理
                          print('Start button pressed');
                          sendArrows();
                        },
                        child: Text('スタート'),
                      ),
                    ],
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
    final ip = '192.168.251.3'; // ここにIPアドレスを入力
    final port = 1235; // ここにポート番号を入力
    try {
      final socket =
          await Socket.connect(ip, port, timeout: Duration(seconds: 5));
      final body = jsonEncode(
          arrowsAll.map((arrow) => arrow[selectedIndex].toJson()).toList());

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

class Arrow {
  final int x;
  final int y;
  final Offset direction;

  Arrow(this.x, this.y, this.direction);
  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'dx': direction.dx,
        'dy': direction.dy,
      };
}

class GridPainter extends CustomPainter {
  final double cellSize;
  final List<List<Arrow>> arrowsAll;
  final int selectedIndex;

  GridPainter(
      {required this.cellSize,
      required this.arrowsAll,
      required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 32; i++) {
      double offset = i * cellSize;
      // 縦線を描画
      canvas.drawLine(Offset(offset, 0), Offset(offset, size.height), paint);
      // 横線を描画
      canvas.drawLine(Offset(0, offset), Offset(size.width, offset), paint);
    }

    // 外周を塗りつぶす
    final fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // 上辺
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, cellSize), fillPaint);
    // 下辺
    canvas.drawRect(
        Rect.fromLTWH(0, size.height - cellSize, size.width, cellSize),
        fillPaint);
    // 左辺
    canvas.drawRect(Rect.fromLTWH(0, 0, cellSize, size.height), fillPaint);
    // 右辺
    canvas.drawRect(
        Rect.fromLTWH(size.width - cellSize, 0, cellSize, size.height),
        fillPaint);

    // 矢印を描画
    for (int i = 0; i < arrowsAll.length; i++) {
      final arrowPaint = Paint()
        ..color = mouceColors[i]
        ..style = PaintingStyle.fill;
      for (int j = 0; j < arrowsAll[i].length - 1; j++) {
        if (arrowsAll[i][j].direction.dx.abs() > 1.0 ||
            arrowsAll[i][j].direction.dy.abs() > 1.0) {
          double arrowX = arrowsAll[i][j].x * cellSize;
          double arrowY = arrowsAll[i][j].y * cellSize;

          Path path = Path();
          if (arrowsAll[i][j].direction.dx.abs() >
              arrowsAll[i][j].direction.dy.abs()) {
            // 水平方向の矢印
            if (arrowsAll[i][j].direction.dx > 0) {
              // 右向き
              path.moveTo(arrowX + cellSize * 0.2, arrowY + cellSize * 0.4);
              path.lineTo(arrowX + cellSize * 0.6, arrowY + cellSize * 0.4);
              path.lineTo(arrowX + cellSize * 0.6, arrowY + cellSize * 0.2);
              path.lineTo(arrowX + cellSize * 0.8, arrowY + cellSize * 0.5);
              path.lineTo(arrowX + cellSize * 0.6, arrowY + cellSize * 0.8);
              path.lineTo(arrowX + cellSize * 0.6, arrowY + cellSize * 0.6);
              path.lineTo(arrowX + cellSize * 0.2, arrowY + cellSize * 0.6);
              path.lineTo(arrowX + cellSize * 0.2, arrowY + cellSize * 0.4);
            } else {
              // 左向き
              path.moveTo(arrowX + cellSize * 0.8, arrowY + cellSize * 0.4);
              path.lineTo(arrowX + cellSize * 0.4, arrowY + cellSize * 0.4);
              path.lineTo(arrowX + cellSize * 0.4, arrowY + cellSize * 0.2);
              path.lineTo(arrowX + cellSize * 0.2, arrowY + cellSize * 0.5);
              path.lineTo(arrowX + cellSize * 0.4, arrowY + cellSize * 0.8);
              path.lineTo(arrowX + cellSize * 0.4, arrowY + cellSize * 0.6);
              path.lineTo(arrowX + cellSize * 0.8, arrowY + cellSize * 0.6);
              path.lineTo(arrowX + cellSize * 0.8, arrowY + cellSize * 0.4);
            }
          } else {
            // 垂直方向の矢印
            if (arrowsAll[i][j].direction.dy > 0) {
              // 下向き
              path.moveTo(arrowX + cellSize * 0.4, arrowY + cellSize * 0.2);
              path.lineTo(arrowX + cellSize * 0.4, arrowY + cellSize * 0.6);
              path.lineTo(arrowX + cellSize * 0.2, arrowY + cellSize * 0.6);
              path.lineTo(arrowX + cellSize * 0.5, arrowY + cellSize * 0.8);
              path.lineTo(arrowX + cellSize * 0.8, arrowY + cellSize * 0.6);
              path.lineTo(arrowX + cellSize * 0.6, arrowY + cellSize * 0.6);
              path.lineTo(arrowX + cellSize * 0.6, arrowY + cellSize * 0.2);
              path.lineTo(arrowX + cellSize * 0.4, arrowY + cellSize * 0.2);
            } else {
              // 上向き
              path.moveTo(arrowX + cellSize * 0.4, arrowY + cellSize * 0.8);
              path.lineTo(arrowX + cellSize * 0.4, arrowY + cellSize * 0.4);
              path.lineTo(arrowX + cellSize * 0.2, arrowY + cellSize * 0.4);
              path.lineTo(arrowX + cellSize * 0.5, arrowY + cellSize * 0.2);
              path.lineTo(arrowX + cellSize * 0.8, arrowY + cellSize * 0.4);
              path.lineTo(arrowX + cellSize * 0.6, arrowY + cellSize * 0.4);
              path.lineTo(arrowX + cellSize * 0.6, arrowY + cellSize * 0.8);
              path.lineTo(arrowX + cellSize * 0.4, arrowY + cellSize * 0.8);
            }
          }
          path.close();
          canvas.drawPath(path, arrowPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
