
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/FoundUser_Widget.dart';


class FoundUserPage extends StatelessWidget {
  final String token;

  FoundUserPage({required this.token});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FoundUserWidget(
        token: token,
      ),
    );
  }
}