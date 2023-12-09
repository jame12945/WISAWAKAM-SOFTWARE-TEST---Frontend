import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import '../views/Map_Page.dart';


class FoundUserWidget extends StatefulWidget {
  final String token;
  FoundUserWidget({
    required this.token
  });

  @override
  FoundUserWidgetWidgetState createState() => FoundUserWidgetWidgetState();
}
class FoundUserWidgetWidgetState extends State<FoundUserWidget> {


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
            'usImagebase':data['usImagebase'],
          },
        };
      } else {
        return {'status': 'error', 'message': data['message']};
      }
    } else {
      throw Exception('Failed to load user information');
    }
  }
  Widget buildImageWidget(String? base64String) {
    if (base64String != null && base64String.isNotEmpty) {
      final Uint8List bytes = base64.decode(base64String);
      return Image.memory(bytes, width: 290);
    } else {
      return Image.asset(
        'assets/user.png',
        width: 290,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Token: ${widget.token}');
    return SingleChildScrollView(
      // physics: NeverScrollableScrollPhysics(),
      child: Container(
        color: Colors.blueAccent,
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
                child: Stack(
                  children:[ FutureBuilder(
                    future: getUserInformation(widget.token),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {

                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {

                        return Text('Error: ${snapshot.error}');
                      } else {

                        final userInformation = snapshot.data?['userInformation'];

                        print('User Information: $userInformation');

                        return Column(
                          children: [
                            SizedBox(height: 60),
                            Column(
                              children: [
                                Text('UserName: ${userInformation?['usUsername']}'
                                  ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600))
                                ,
                                SizedBox(height: 20),
                                Text('Password: ${userInformation?['usPassword']}'
                                    ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                                SizedBox(height: 20),
                                Text('ชื่อผู้ใช้: ${userInformation?['usfname']}'
                                    ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                                SizedBox(height: 20),
                                Text('นามสกุล: ${userInformation?['uslname']}'
                                    ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                                SizedBox(height: 20),
                                Text('เลขบัตรประชาชน: ${userInformation?['usCitizen']}'
                                    ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                                SizedBox(height: 20),
                                Text('เบอร์ติดต่อ: ${userInformation?['usPhone']}'
                                    ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                                SizedBox(height: 80),
                                Image.asset('assets/user.png',
                                width: 290,),
                                // SizedBox(height: 80),
                                // buildImageWidget(userInformation?['usImagebase']),

                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                    Container(
                      margin: EdgeInsets.only(top: 820.0, left: 120),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MapPage()),
                          );
                        },
                        child: Icon(Icons.near_me),
                      ),
                    )

                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}
