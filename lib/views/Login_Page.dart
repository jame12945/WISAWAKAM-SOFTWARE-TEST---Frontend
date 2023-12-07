
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/Login_Widget.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginWidget(),
    );
  }
}