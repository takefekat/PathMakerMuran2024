import 'package:flutter/material.dart';

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
