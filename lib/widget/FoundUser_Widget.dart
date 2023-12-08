import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../views/Login_Page.dart';
import '../views/SignUpPage_Page.dart';
import 'dart:typed_data';


class FoundUserWidget extends StatefulWidget {
  final String token;
  FoundUserWidget({
    required this.token
  });

  @override
  FoundUserWidgetWidgetState createState() => FoundUserWidgetWidgetState();
}
class FoundUserWidgetWidgetState extends State<FoundUserWidget> {
  String cleanImagePath(String imagePath) {
    // ลบเครื่องหมายไม่ถูกต้องที่อยู่ท้ายไฟล์รูปภาพ
    return imagePath.replaceAll('"', '');
  }
  String sanitizeFilePath(String originalPath) {
    // Replace invalid characters with a safe alternative or remove them
    String sanitizedPath = originalPath.replaceAll(RegExp(r'[^\w\s./:-]'), '');

    // Replace backslashes with forward slashes
    sanitizedPath = sanitizedPath.replaceAll('\\', '/');

        return sanitizedPath;
    }
  Future<Map<String, dynamic>> getUserInformation(String token) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3333/getUserInformation/$token'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'ok') {
        return {
          'status': 'ok',
          'userInformation': {
            'usUsername': data['usUsername'],
            'usPassword': data['usPassword'],
            'usfname': data['usfname'],
            'uslname': data['uslname'],
            'usCitizen': data['usCitizen'],
            'usPhone': data['usPhone'],
            'usImage': data['usImage'],
          },
        };
      } else {
        return {'status': 'error', 'message': data['message']};
      }
    } else {
      throw Exception('Failed to load user information');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Token: ${widget.token}');
    return SingleChildScrollView(
      // physics: NeverScrollableScrollPhysics(),
      child: Container(
        color: Colors.green,
        height: 1400,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 130.0, right: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.0),
                  color: Colors.white,
                ),
                width: Get.width * 0.75,
                height: Get.height * 0.8,
                alignment: Alignment.topCenter,
                child: FutureBuilder(
                  future: getUserInformation(widget.token),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // แสดง UI ในระหว่างโหลดข้อมูล
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // แสดง UI เมื่อเกิดข้อผิดพลาด
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // แสดง UI เมื่อโหลดข้อมูลเสร็จสมบูรณ์
                      final userInformation = snapshot.data?['userInformation'];

                      // Print ค่า userInformation ทั้งหมด
                      print('User Information: $userInformation');

                      return Column(
                        children: [
                          SizedBox(height: 60),
                          Column(
                            children: [
                              Text('UserName: ${userInformation?['usUsername']}'
                                ,style: TextStyle(fontSize: 20))
                              ,
                              SizedBox(height: 20),
                              Text('Password: ${userInformation?['usPassword']}'
                                  ,style: TextStyle(fontSize: 20)),
                              SizedBox(height: 20),
                              Text('ชื่อผู้ใช้: ${userInformation?['usfname']}'
                                  ,style: TextStyle(fontSize: 20)),
                              SizedBox(height: 20),
                              Text('นามสกุล: ${userInformation?['uslname']}'
                                  ,style: TextStyle(fontSize: 20)),
                              SizedBox(height: 20),
                              Text('เลขบัตรประชาชน: ${userInformation?['usCitizen']}'
                                  ,style: TextStyle(fontSize: 20)),
                              SizedBox(height: 20),
                              Text('เบอร์ติดต่อ: ${userInformation?['usPhone']}'
                                  ,style: TextStyle(fontSize: 20)),
                              // แสดงรูปภาพตามความต้องการ
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}
