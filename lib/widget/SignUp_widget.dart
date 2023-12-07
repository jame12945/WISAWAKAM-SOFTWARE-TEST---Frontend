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
class SignUpWidget extends StatefulWidget {

@override
 SignUpWidgetWidgetState createState() => SignUpWidgetWidgetState();
}

class SignUpWidgetWidgetState extends State<SignUpWidget> {

  TextEditingController user_username = TextEditingController();
  TextEditingController user_password = TextEditingController();
  TextEditingController user_fname = TextEditingController();
  TextEditingController user_lname = TextEditingController();
  TextEditingController user_citizenId = TextEditingController();
  TextEditingController user_phone = TextEditingController();


  File? _image;
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // ลดขนาดรูปภาพ
      final File reducedImage = await _reduceImageSize(pickedFile.path);
      setState(() {
        _image = reducedImage;
      });
    }
  }

  Future<File> _reduceImageSize(String imagePath) async {
    final File imageFile = File(imagePath);
    final img.Image originalImage = img.decodeImage(imageFile.readAsBytesSync())!;

    // กำหนดขนาดที่ต้องการ (300x300)
    final img.Image reducedImage = img.copyResize(originalImage, width: 300, height: 300);

    // บันทึกรูปภาพที่ลดขนาดลง
    final tempDir = await getTemporaryDirectory();
    final File reducedFile = File('${tempDir.path}/reduced_image.jpg');
    reducedFile.writeAsBytesSync(img.encodeJpg(reducedImage));

    return reducedFile;
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:3333/upload'), // ปรับเปลี่ยน URL ของ Node.js server ของคุณ
    );

    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  void Register() async {
    await _uploadImage();
    final nodeUrl = Uri.parse('http://10.0.2.2:3333/register');
    final Map<String, dynamic> UserData = {
      "user_username": user_username.text,
      "user_password": user_password.text,
      "user_fname": user_fname.text,
      "user_lname": user_lname.text,
      "user_citizenid":user_citizenId.text,
      "user_phone":user_phone.text ,
      "user_image": _image != null ? _image!.path : null,



    };

    final response = await http.post(
      nodeUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(UserData),
    );

    if (response.statusCode == 200) {
      // บันทึกข้อมูลสำเร็จ

      print('Register สำเร็จ ');
    } else {
      print('Register ไม่สำเร็จ: ${response.statusCode}');
    }

  }
  @override
  Widget build(BuildContext context) {
    Color customColor = Color(0xCCEFEEEE);
    return SingleChildScrollView(
       child: Container(
         color: Colors.green,
         height: 1400,
         child: Stack(
           children: [
             Align(
               alignment: Alignment.topCenter,
               child: Container(
                 margin: EdgeInsets.only(top: 180.0),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(28.0),
                   color: Colors.white,
                 ),
                 width: Get.width*0.75,
                 height: Get.height*0.9,
                 alignment: Alignment.topCenter,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Padding(
                       padding: const EdgeInsets.symmetric(vertical: 20.0),
                       child: Text(
                         'Register',
                         style:TextStyle(
                             fontSize: 28,
                             fontWeight: FontWeight.bold

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
                         controller: user_username,
                         decoration: InputDecoration(
                           hintText: 'Username', // ข้อความตัวอย่างในช่องใส่ข้อความ
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10.0),
                           ),
                           filled: true,
                           fillColor: customColor,

                         ),
                       ),
                     ),
                     SizedBox(height: 10,),

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
                             fillColor: customColor
                         ),
                       ),
                     ),
                     SizedBox(height: 10,),

                     Container(
                       width: Get.width * 0.65,
                       child: TextFormField(
                         style: TextStyle(
                             color: Colors.black
                         ),
                         controller: user_fname,
                         decoration: InputDecoration(
                             hintText: 'ชื่อผู้ใช้', // ข้อความตัวอย่างในช่องใส่ข้อความ
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                             ),
                             filled: true,
                             fillColor: customColor
                         ),
                       ),
                     ),

                     SizedBox(height: 10,),

                     Container(
                       width: Get.width * 0.65,
                       child: TextFormField(
                         style: TextStyle(
                             color: Colors.black
                         ),
                           controller:user_lname,
                         decoration: InputDecoration(
                             hintText: 'นามสกุล', // ข้อความตัวอย่างในช่องใส่ข้อความ
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                             ),
                             filled: true,
                             fillColor: customColor
                         ),
                       ),
                     ),
                     SizedBox(height: 10,),
                     Container(
                       width: Get.width * 0.65,
                       child: TextFormField(
                         style: TextStyle(
                             color: Colors.black
                         ),
                         controller:user_citizenId,
                         decoration: InputDecoration(
                             hintText: 'เลขบัตรประชาชน', // ข้อความตัวอย่างในช่องใส่ข้อความ
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                             ),
                             filled: true,
                             fillColor: customColor
                         ),
                       ),
                     ),
                     SizedBox(height: 10,),
                     Container(
                       width: Get.width * 0.65,
                       child: TextFormField(
                         style: TextStyle(
                             color: Colors.black
                         ),
                         controller:user_phone,
                         decoration: InputDecoration(
                             hintText: 'เบอร์ติดต่อ', // ข้อความตัวอย่างในช่องใส่ข้อความ
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                             ),
                             filled: true,
                             fillColor: customColor
                         ),
                       ),
                     ),
                     SizedBox(height: 20),
                     ElevatedButton(
                       onPressed: _getImage,
                       child: Text('Choose Image'),
                     ),

                     if (_image != null)
                       Image.file(_image!),



                     Align(
                       alignment: Alignment.topCenter,
                       child: Container(
                         margin: EdgeInsets.only(top: 30.0),
                         child: ElevatedButton(
                           onPressed: () {
                             Register();
                             // _uploadImage();
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
                           child: Text("Save",
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