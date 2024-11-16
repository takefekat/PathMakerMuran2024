import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Arrow> arrows = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('電光石火ぴかぴかクリーナーズ'),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1, // 左右の幅を3:1に設定

              child: Row(
                children: [
                  ElevatedButton(
                    child: const Text(''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    child: const Text(''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    child: const Text(''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    onPressed: () {},
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
                          Offset position = details.localPosition;
                          int x = (position.dx / cellSize).floor();
                          int y = (position.dy / cellSize).floor();
                          if (x >= 0 && x < 32 && y >= 0 && y < 32) {
                            arrows.add(Arrow(x, y, details.delta));
                          }
                        });
                      },
                      child: CustomPaint(
                        size: Size(gridSize, gridSize),
                        painter:
                            GridPainter(cellSize: cellSize, arrows: arrows),
                      ),
                    );
                  },
                ),
              ),
            ),
            // 下側のスタートボタン
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            arrows.clear();
                          });
                        },
                        child: Text('リセット'),
                      ),
                      SizedBox(width: 16), // ボタン間のスペース
                      ElevatedButton(
                        onPressed: () {
                          // スタートボタンが押されたときの処理
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
}

class Arrow {
  final int x;
  final int y;
  final Offset direction;

  Arrow(this.x, this.y, this.direction);
}

class GridPainter extends CustomPainter {
  final double cellSize;
  final List<Arrow> arrows;

  GridPainter({required this.cellSize, required this.arrows});

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
    final arrowPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    for (Arrow arrow in arrows) {
      double arrowX = arrow.x * cellSize;
      double arrowY = arrow.y * cellSize;

      Path path = Path();
      if (arrow.direction.dx.abs() > arrow.direction.dy.abs()) {
        // 水平方向の矢印
        if (arrow.direction.dx > 0) {
          // 右向き
          path.moveTo(arrowX + cellSize * 0.2, arrowY + cellSize * 0.5);
          path.lineTo(arrowX + cellSize * 0.8, arrowY + cellSize * 0.5);
          path.lineTo(arrowX + cellSize * 0.6, arrowY + cellSize * 0.3);
          path.lineTo(arrowX + cellSize * 0.6, arrowY + cellSize * 0.7);
        } else {
          // 左向き
          path.moveTo(arrowX + cellSize * 0.8, arrowY + cellSize * 0.5);
          path.lineTo(arrowX + cellSize * 0.2, arrowY + cellSize * 0.5);
          path.lineTo(arrowX + cellSize * 0.4, arrowY + cellSize * 0.3);
          path.lineTo(arrowX + cellSize * 0.4, arrowY + cellSize * 0.7);
        }
      } else {
        // 垂直方向の矢印
        if (arrow.direction.dy > 0) {
          // 下向き
          path.moveTo(arrowX + cellSize * 0.5, arrowY + cellSize * 0.2);
          path.lineTo(arrowX + cellSize * 0.5, arrowY + cellSize * 0.8);
          path.lineTo(arrowX + cellSize * 0.3, arrowY + cellSize * 0.6);
          path.lineTo(arrowX + cellSize * 0.7, arrowY + cellSize * 0.6);
        } else {
          // 上向き
          path.moveTo(arrowX + cellSize * 0.5, arrowY + cellSize * 0.8);
          path.lineTo(arrowX + cellSize * 0.5, arrowY + cellSize * 0.2);
          path.lineTo(arrowX + cellSize * 0.3, arrowY + cellSize * 0.4);
          path.lineTo(arrowX + cellSize * 0.7, arrowY + cellSize * 0.4);
        }
      }
      path.close();
      canvas.drawPath(path, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
