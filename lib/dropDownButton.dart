import 'package:flutter/material.dart';
import 'common.dart';

const double FONT_SIZE = 30;

class CustomDropdown extends StatelessWidget {
  final int selectedValue;
  final int mouceIndex;
  final ValueChanged<int?> onChanged;

  CustomDropdown(
      {required this.selectedValue,
      required this.mouceIndex,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // 適切な幅を指定
      decoration: BoxDecoration(
        color: mouceColors[mouceIndex], // 背景色を赤色に設定
        borderRadius: BorderRadius.circular(30.0), // 楕円形にするための角の丸みを設定
        border: Border.all(color: Colors.white, width: 2.0), // 外枠を白色に設定
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // 影の色
            offset: Offset(0, 4), // 影の位置
            blurRadius: 10.0, // ぼかしの強さ
          ),
        ],
      ),
      child: DropdownButton(
        items: const [
          DropdownMenuItem<int>(
            value: MOUSE_PATH_MODE_MANUAL,
            child: Center(
                child: Text('手動', style: TextStyle(fontSize: FONT_SIZE))),
          ),
          DropdownMenuItem<int>(
            value: MOUSE_PATH_MODE_AUTO,
            child: Center(
                child: Text('自動', style: TextStyle(fontSize: FONT_SIZE))),
          ),
          DropdownMenuItem<int>(
            value: MOUSE_PATH_MODE_RANDOM,
            child: Center(
                child: Text('ランダム', style: TextStyle(fontSize: FONT_SIZE))),
          ),
          DropdownMenuItem<int>(
            value: MOUSE_PATH_MODE_OFF,
            child: Center(
                child: Text('OFF', style: TextStyle(fontSize: FONT_SIZE))),
          ),
        ],
        onChanged: onChanged,
        value: selectedValue,
        elevation: 16,
        menuWidth: 160,
        isExpanded: true, // ドロップダウンの幅を広げる
        underline: const SizedBox.shrink(), // 枠線を消す
      ),
    );
  }
}