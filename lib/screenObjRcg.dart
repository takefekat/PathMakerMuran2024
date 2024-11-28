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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                          sendMsg("mode:pathFind");
                          print("mode:pathFind");
                          List<Arrow> objs = [];

                          final response = await sendRecvMsg("get_path");
                          if (response != "") {
                            final jsonResponse = json.decode(response);

                            jsonResponse['objs'].forEach((obj) {
                              objs.add(Arrow(obj['x'], obj['y'], 0));
                            });
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PathFind(objs: objs)),
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
    );
  }
}
