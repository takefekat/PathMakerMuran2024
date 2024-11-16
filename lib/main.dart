import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
                    return CustomPaint(
                      size: Size(gridSize, gridSize),
                      painter: GridPainter(cellSize: cellSize),
                    );
                  },
                ),
              ),
            ),
            // 右側のスタートボタン
            Expanded(
              flex: 1, // 左右の幅を3:1に設定
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // スタートボタンが押されたときの処理
                  },
                  child: Text('スタート'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double cellSize;

  GridPainter({required this.cellSize});

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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
