import 'dart:math';
import 'package:flutter/material.dart';
import 'common.dart';

class FieldWidget extends StatelessWidget {
  final List<List<Arrow>> arrowsAll;
  final int selectedIndex;
  final Function(int) onSelectedIndexChanged;

  double simTime = 0;

  FieldWidget({
    required this.arrowsAll,
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0), // 余白を追加
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0, // 正方形に設定
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double gridSize =
                      min(constraints.maxWidth, constraints.maxHeight);
                  double cellSize = gridSize / MAZE_SIZE.toDouble();
                  return GestureDetector(
                    onPanUpdate: (details) {
                      // タッチされたマス目を特定
                      Offset position = details.localPosition;
                      int x = (position.dx / cellSize).floor();
                      int y = (position.dy / cellSize).floor();

                      // if ((x > 0 && x < 31 && y > 0 && y < 31)) { // 32サイズの場合は外周には描画しない
                      if ((x >= 0 &&
                          x < MAZE_SIZE &&
                          y >= 0 &&
                          y < MAZE_SIZE)) {
                        // 一度通過済みのセルの場合はそれ以降の経路をリセット
                        for (int i = 0; i < arrowsAll.length; i++) {
                          for (int j = 0; j < arrowsAll[i].length; j++) {
                            if (arrowsAll[i][j].x == x &&
                                arrowsAll[i][j].y == y) {
                              arrowsAll[i]
                                  .removeRange(j + 1, arrowsAll[i].length);
                              break;
                            }
                          }
                        }

                        // selectedIndexを特定
                        if (arrowsAll[0].last.x == x &&
                            arrowsAll[0].last.y == y) {
                          onSelectedIndexChanged(0);
                        } else if (arrowsAll[1].last.x == x &&
                            arrowsAll[1].last.y == y) {
                          onSelectedIndexChanged(1);
                        } else if (arrowsAll[2].last.x == x &&
                            arrowsAll[2].last.y == y) {
                          onSelectedIndexChanged(2);
                        } else if (arrowsAll[3].last.x == x &&
                            arrowsAll[3].last.y == y) {
                          onSelectedIndexChanged(3);
                        }

                        // 経路末尾と隣接するセルにのみ移動可能
                        Arrow lastArrow = arrowsAll[selectedIndex].last;
                        if ((x - lastArrow.x).abs() + (y - lastArrow.y).abs() ==
                            1) {
                          arrowsAll[selectedIndex]
                              .add(Arrow(x, y, details.delta));
                        }
                      }
                    },
                    child: CustomPaint(
                      size: Size(gridSize, gridSize),
                      painter: GridPainter(
                        cellSize: cellSize,
                        arrowsAll: arrowsAll,
                        selectedIndex: selectedIndex,
                        simTime: simTime,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
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

class Point {
  double x;
  double y;

  Point(this.x, this.y);
  void rotation(double theta) {
    double x = this.x;
    double y = this.y;
    this.x = x * cos(theta) - y * sin(theta);
    this.y = x * sin(theta) + y * cos(theta);
  }

  void add(Point p) {
    this.x = this.x + p.x;
    this.y = this.y + p.y;
  }
}

class GridPainter extends CustomPainter {
  final double cellSize;
  final List<List<Arrow>> arrowsAll;
  final int selectedIndex;
  final double simTime;

  GridPainter(
      {required this.cellSize,
      required this.arrowsAll,
      required this.selectedIndex,
      required this.simTime});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= MAZE_SIZE; i++) {
      double offset = i * cellSize;
      // 縦線を描画
      canvas.drawLine(Offset(offset, 0), Offset(offset, size.height), paint);
      // 横線を描画
      canvas.drawLine(Offset(0, offset), Offset(size.width, offset), paint);
    }

    // 外周を塗りつぶす
    if (MAZE_SIZE == 32) {
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
    }
    // 矢印を描画
    for (int i = 0; i < arrowsAll.length; i++) {
      final arrowPaint = Paint()
        ..color = mouceColors[i]
        ..style = PaintingStyle.fill;
      for (int j = 0; j < arrowsAll[i].length - 1; j++) {
        int dx = arrowsAll[i][j + 1].x - arrowsAll[i][j].x; // x方向の変化向き
        int dy = arrowsAll[i][j + 1].y - arrowsAll[i][j].y; // y方向の変化向き

        double arrowX = arrowsAll[i][j].x * cellSize; // セルのx座標原点(左上の点)
        double arrowY = arrowsAll[i][j].y * cellSize; // セルのy座標原点(左上の点)
        double theta = 0;
        Path path = Path();
        if (dx == 1 && dy == 0) {
          theta = 0;
        } else if (dx == 1 && dy == 1) {
          theta = pi / 4;
        } else if (dx == 0 && dy == 1) {
          theta = pi / 2;
        } else if (dx == -1 && dy == 1) {
          theta = 3 * pi / 4;
        } else if (dx == -1 && dy == 0) {
          theta = pi;
        } else if (dx == -1 && dy == -1) {
          theta = -3 * pi / 4;
        } else if (dx == 0 && dy == -1) {
          theta = -pi / 2;
        } else if (dx == 1 && dy == -1) {
          theta = -pi / 4;
        }
        Point p1 = Point(cellSize * (0.2 - 0.5), cellSize * (0.4 - 0.5));
        Point p2 = Point(cellSize * (0.6 - 0.5), cellSize * (0.4 - 0.5));
        Point p3 = Point(cellSize * (0.6 - 0.5), cellSize * (0.2 - 0.5));
        Point p4 = Point(cellSize * (0.8 - 0.5), cellSize * (0.5 - 0.5));
        Point p5 = Point(cellSize * (0.6 - 0.5), cellSize * (0.8 - 0.5));
        Point p6 = Point(cellSize * (0.6 - 0.5), cellSize * (0.6 - 0.5));
        Point p7 = Point(cellSize * (0.2 - 0.5), cellSize * (0.6 - 0.5));
        Point p8 = Point(cellSize * (0.2 - 0.5), cellSize * (0.4 - 0.5));
        p1.rotation(theta);
        p2.rotation(theta);
        p3.rotation(theta);
        p4.rotation(theta);
        p5.rotation(theta);
        p6.rotation(theta);
        p7.rotation(theta);
        p8.rotation(theta);
        p1.add(Point(cellSize * 0.5, cellSize * 0.5));
        p2.add(Point(cellSize * 0.5, cellSize * 0.5));
        p3.add(Point(cellSize * 0.5, cellSize * 0.5));
        p4.add(Point(cellSize * 0.5, cellSize * 0.5));
        p5.add(Point(cellSize * 0.5, cellSize * 0.5));
        p6.add(Point(cellSize * 0.5, cellSize * 0.5));
        p7.add(Point(cellSize * 0.5, cellSize * 0.5));
        p8.add(Point(cellSize * 0.5, cellSize * 0.5));
        path.moveTo(arrowX + p1.x, arrowY + p1.y);
        path.lineTo(arrowX + p2.x, arrowY + p2.y);
        path.lineTo(arrowX + p3.x, arrowY + p3.y);
        path.lineTo(arrowX + p4.x, arrowY + p4.y);
        path.lineTo(arrowX + p5.x, arrowY + p5.y);
        path.lineTo(arrowX + p6.x, arrowY + p6.y);
        path.lineTo(arrowX + p7.x, arrowY + p7.y);
        path.lineTo(arrowX + p8.x, arrowY + p8.y);
        path.close();
        canvas.drawPath(path, arrowPaint);
      }
      // 経路の末尾にダイヤを描画
      if (arrowsAll[i].isNotEmpty) {
        double arrowX = arrowsAll[i].last.x * cellSize; // セルのx座標原点(左上の点)
        double arrowY = arrowsAll[i].last.y * cellSize; // セルのy座標原点(左上の点)
        final diamondPaint = Paint()
          ..color = mouceColors[i]
          ..style = PaintingStyle.fill;
        Path path = Path();
        path.moveTo(arrowX + cellSize * 0.5, arrowY + cellSize * 0.2);
        path.lineTo(arrowX + cellSize * 0.8, arrowY + cellSize * 0.5);
        path.lineTo(arrowX + cellSize * 0.5, arrowY + cellSize * 0.8);
        path.lineTo(arrowX + cellSize * 0.2, arrowY + cellSize * 0.5);
        path.close();
        canvas.drawPath(path, diamondPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
