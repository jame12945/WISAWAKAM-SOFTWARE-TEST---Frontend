import 'dart:ffi';

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
class LoginWidget extends StatefulWidget {

  @override
  LoginWidgetWidgetState createState() => LoginWidgetWidgetState();
}

class LoginWidgetWidgetState extends State<LoginWidget> {
  TextEditingController user_username = TextEditingController();
  TextEditingController user_password = TextEditingController();
  void loginfunction() async {

    final nodeUrl = Uri.parse('http://10.0.2.2:3333/login');
    final Map<String, dynamic> UserData = {
      "user_username": user_username.text,
      "user_password": user_password.text,
    };

    final response = await http.post(
      nodeUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(UserData),
    );

    if (response.statusCode == 200) {
      print('Login สำเร็จ ');
    } else {
      print('Login ไม่สำเร็จ: ${response.statusCode}');
    }

  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.green,
        height: 1400,
        child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 350.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.0),
                    color: Colors.white,
                  ),
                  width: Get.width*0.75,
                  height: Get.height*0.4,
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Sign In',
                          style:TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold

                          ),
                        ),
                      ),
                      SizedBox(height: 50,),

                      Container(
                        width: Get.width * 0.65,
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black
                          ),
                          controller: user_username,
                          decoration: InputDecoration(
                            hintText: 'Username', // ข้อความตัวอย่างในช่องใส่ข้อความ
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            // fillColor: customColor,

                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

                      Container(
                        width: Get.width * 0.65,
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black
                          ),
                          controller: user_password,
                          decoration: InputDecoration(
                              hintText: 'Password', // ข้อความตัวอย่างในช่องใส่ข้อความ
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              // fillColor: customColor
                          ),
                        ),
                      ),



                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 30.0),
                          child: ElevatedButton(
                            onPressed: () {
                              loginfunction();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // สีพื้นหลังของปุ่ม
                                foregroundColor: Colors.white, // สีของข้อความ
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                padding:EdgeInsets.symmetric(horizontal: 152 , vertical: 13)

                            ),
                            child: Text("Login",
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
        ),
      ),
    );
  }
}