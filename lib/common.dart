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

List<Arrow> initPos = [
  Arrow(0, 0, DIR_RGT),
  Arrow(0, MAZE_SIZE - 1, DIR_UP),
  Arrow(MAZE_SIZE - 1, 0, DIR_DWN),
  Arrow(MAZE_SIZE - 1, MAZE_SIZE - 1, DIR_LFT),
];

const int MOUSE_NUM = 4;
const List<Color> mouceColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow
];

const int PORT = 1251;

const int PATH_MODE_MANUAL = 0;
const int PATH_MODE_AUTO = 1;
const int PATH_MODE_RANDOM = 2;
const int PATH_MODE_OFF = 255;

const int MAZE_SIZE = 16;

const int DIR_RGT = 0;
const int DIR_DWN = 1;
const int DIR_LFT = 2;
const int DIR_UP = 3;
const int DIR_NUM = 4;
const List<int> dxs = [1, 0, -1, 0]; // 右、下、左、上
const List<int> dys = [0, 1, 0, -1]; // 右、下、左、上

const ip = '192.168.251.3'; // PCのIPアドレス
const port = PORT; // PCのポート

class Arrow {
  final int x;
  final int y;
  final int lastdir;

  Arrow(this.x, this.y, this.lastdir);
}

int calcDir(Arrow a1, Arrow a2) {
  if (a1.x == a2.x) {
    if (a1.y < a2.y) {
      return DIR_DWN;
    } else {
      return DIR_UP;
    }
  } else {
    if (a1.x < a2.x) {
      return DIR_RGT;
    } else {
      return DIR_LFT;
    }
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
      // print('Data sent successfully');
    } catch (e) {
      print('Error while sending data: $e');
    }
  } catch (e) {
    print('Error connecting to server: $e');
  }
}

Future<String> sendRecvMsg(String msg) async {
  try {
    final socket =
        await Socket.connect(ip, port, timeout: Duration(seconds: 5));

    final body = json.encode({'signal': msg});
    try {
      socket.write(body);
      await socket.flush();

      // サーバーからの応答を受信
      final response =
          await socket.transform(utf8.decoder.cast<Uint8List, String>()).join();
      print(response);

      socket.close();
      return response;
    } catch (e) {
      print('Error while sending data: $e');
      return "";
    }
  } catch (e) {
    print('Error connecting to server: $e');
    return "";
  }
}

// 8 x 8 の迷路を1筆がきで全ての頂点を通るようにする
// ただし、障害物は通れない(objs)
const int REL_MAZE_SIZE = 8;
List<Arrow> autoPathCalc(List<Arrow> objs, Arrow start) {
  List<Arrow> paths = [];
  List<List<bool>> visited =
      List.generate(REL_MAZE_SIZE, (_) => List.filled(REL_MAZE_SIZE, false));
  List<List<bool>> obstacles =
      List.generate(REL_MAZE_SIZE, (_) => List.filled(REL_MAZE_SIZE, false));

  // 障害物の位置を設定
  for (var obj in objs) {
    if (0 <= obj.x && 0 <= obj.y) {
      obstacles[obj.x][obj.y] = true;
    }
  }

  bool dfs(int x, int y) {
    // 範囲外または障害物または訪問済みの場合
    if (x < 0 ||
        x >= REL_MAZE_SIZE ||
        y < 0 ||
        y >= REL_MAZE_SIZE ||
        obstacles[x][y] ||
        visited[x][y]) {
      return false;
    }

    // 現在の位置を訪問済みにする
    visited[x][y] = true;
    paths.add(Arrow(x, y, 0));

    // 全ての頂点を訪問した場合
    if (paths.length == REL_MAZE_SIZE * REL_MAZE_SIZE - objs.length) {
      return true;
    }

    // 上下左右に移動
    List<List<int>> directions = [
      [0, 1], // 右
      [1, 0], // 下
      [0, -1], // 左
      [-1, 0] // 上
    ];

    for (var dir in directions) {
      if (dfs(x + dir[0], y + dir[1])) {
        return true;
      }
    }

    // 戻る
    visited[x][y] = false;
    paths.removeLast();
    return false;
  }

  // スタート地点からDFSを開始
  dfs(start.x, start.y);

  return paths;
}
  /* 最短炉のサンプルコード */
  /*
  List<Arrow> path = [];
  List<List<int>> maze = List.generate(MAZE_SIZE, (_) => List.filled(MAZE_SIZE, 0));
  for (int i = 0; i < MAZE_SIZE; i++) {
    maze[i][0] = 1;
    maze[i][MAZE_SIZE - 1] = 1;
    maze[0][i] = 1;
    maze[MAZE_SIZE - 1][i] = 1;
  }
  for (Arrow obj in objs) {
    maze[obj.y][obj.x] = 1;
  }

  Arrow start = objs[0];
  Arrow goal = objs[1];

  List<List<int>> dist = List.generate(MAZE_SIZE, (_) => List.filled(MAZE_SIZE, 1000000));
  List<List<int>> prev = List.generate(MAZE_SIZE, (_) => List.filled(MAZE_SIZE, -1));
  dist[start.y][start.x] = 0;

  Queue<Arrow> q = Queue();
  q.addLast(start);

  while (q.isNotEmpty) {
    Arrow cur = q.removeFirst();
    if (cur.x == goal.x && cur.y == goal.y) {
      break;
    }

    for (int dir = 0; dir < DIR_NUM; dir++) {
      int nx = cur.x + dxs[dir];
      int ny = cur.y + dys[dir];
      if (nx < 0 || nx >= MAZE_SIZE || ny < 0 || ny >= MAZE_SIZE) {
        continue;
      }
      if (maze[ny][nx] == 1) {
        continue;
      }
      if (dist[ny][nx] > dist[cur.y][cur.x] + 1) {
        dist[ny][nx] = dist[cur.y][cur.x] + 1;
        prev[ny][nx] = dir;
        q.addLast(Arrow(nx, ny, dir));
      }
    }
  }

  Arrow cur = goal;
  while (cur.x != start.x || cur.y != start.y) {
    path.add(cur);
    int dir = prev[cur.y][cur.x];
    cur = Arrow(cur.x - dxs[dir], cur.y - dys[dir], dir);
  }
  path.add(start);
  path = path.reversed.toList();
  return path;
*/
