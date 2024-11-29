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

class ObjectRecognition extends StatelessWidget {
  bool _isTapped = false; // 非同期処理実施中に2回目以降のタップを無効にするためのフラグ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/BackGround.png'), // 画像のパスを指定
            fit: BoxFit.cover, // 画面いっぱいに表示
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // 透明度を設定
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: Image.asset('images/ObjRecog.png'),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: InkWell(
                          onTap: () async {
                            if (_isTapped) {
                              return;
                            }
                            _isTapped = true;
                            sendMsg("mode:pathFind");
                            print("mode:pathFind");
                            List<Arrow> objs = [];
                            List<List<Arrow>> paths = [
                              [],
                              [],
                              [],
                              [],
                            ];

                            final response = await sendRecvMsg("get_path");
                            if (response != "") {
                              final jsonResponse = json.decode(response);

                              jsonResponse['objs'].forEach((obj) {
                                objs.add(Arrow(obj['x'], obj['y'], 0));
                              });
                            }

                            final path_set = await sendRecvMsg("get_auto_path");
                            if (path_set != "") {
                              final jsonResponse = json.decode(path_set);

                              jsonResponse['mouce0'].forEach((node) {
                                paths[0].add(Arrow(node['x'], node['y'], 0));
                              });
                              jsonResponse['mouce1'].forEach((node) {
                                paths[1].add(Arrow(node['x'], node['y'], 0));
                              });
                              jsonResponse['mouce2'].forEach((node) {
                                paths[2].add(Arrow(node['x'], node['y'], 0));
                              });
                              jsonResponse['mouce3'].forEach((node) {
                                paths[3].add(Arrow(node['x'], node['y'], 0));
                              });
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PathFind(objs: objs, paths: paths)),
                            ).then((value) {
                              print("mode:objRecg");
                              sendMsg("mode:objRecg");
                            });
                          },
                          child: Image.asset('images/NextButton.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
