import 'package:bookingapp/views/FoundUser_Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import '../views/SignUpPage_Page.dart';
import 'package:url_launcher/url_launcher.dart';


class LoginWidget extends StatefulWidget {

  @override
  LoginWidgetWidgetState createState() => LoginWidgetWidgetState();
}

class LoginWidgetWidgetState extends State<LoginWidget> {
  String? alertvalue;
  String userFirstName = '';
  String Gettoken = '';
  TextEditingController user_username = TextEditingController();
  TextEditingController user_password = TextEditingController();
  Future<void> _launchPhoneDialer(String phoneNumber) async {
    if (await canLaunchUrl(phoneNumber as Uri)) {
      await launchUrl(phoneNumber as Uri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
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
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 'ok') {
        print('Login สำเร็จ');
       setState(() {
         alertvalue = 'Login สำเร็จ';
         userFirstName = responseData['user_fname'];
         Gettoken = responseData['token'];
         print(alertvalue);
         print(Gettoken);
       });

      } else {
        print('Login ไม่สำเร็จ: ${responseData['message']}');
        setState(() {
          alertvalue = 'Login ไม่สำเร็จ';
          print(alertvalue);
        });


      }
    } else {
      print('HTTP Error ${response.statusCode}');
      setState(() {
        alertvalue = 'เกิดข้อผิดพลาด';
        print(alertvalue);
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        color: Colors.blueAccent,
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
                  height: Get.height*0.45,
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height:40,),
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
                      SizedBox(height: 40,),

                      Container(
                        width: Get.width * 0.65,
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black
                          ),
                          controller: user_username,
                          decoration: InputDecoration(
                            hintText: 'Username',
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
                              Future.delayed(Duration(milliseconds: 100), () {
                                if (alertvalue == 'Login สำเร็จ') {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'ยินดีต้อนรับคุณ   $userFirstName',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      content:Image.asset("assets/personpic.gif",
                                        width: Get.width*0.10,
                                        height: Get.height*0.10,),

                                    ),
                                  );
                                }
                                else{
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'ไม่พบข้อมูลผู้ใช้ในระบบกรุณา สมัครสมาชิก หรือ ติดต่อผู้ดูแลระบบ',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                        onPressed:(){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder:(context)=>SignUpPage())
                                        );
                                       },

                                            child: Text('Register')
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            final Uri url = Uri(scheme: 'tel', path: '1176');
                                            launchUrl(url);
                                          },
                                          child: Text('ติดต่อผู้ดูแลระบบ'),
                                        ),




                                      ],

                                    ),
                                  );
                                }
                              });
                              Future.delayed(Duration(milliseconds: 2000), () {
                              if (alertvalue == 'Login สำเร็จ') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FoundUserPage(token:Gettoken)),
                                );
                              }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // สีพื้นหลังของปุ่ม
                                foregroundColor: Colors.white, // สีของข้อความ
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                padding:EdgeInsets.symmetric(horizontal: 120 , vertical: 15)

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