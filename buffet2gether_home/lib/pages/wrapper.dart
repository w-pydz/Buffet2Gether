import 'package:buffet2gether_home/main.dart';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:buffet2gether_home/pages/home/home_page.dart';
import 'package:buffet2gether_home/pages/login/getStarted_page.dart';
import 'package:buffet2gether_home/pages/login/login_page.dart';
import 'package:buffet2gether_home/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print("aaaa");
    // return either the Home or Authenticate widget
    // print("user id is ${user.userId}");
    if (user == null) {
      print("in if");
      return Login();
    } else {
      print("in else");
      return StreamProvider<User>.value(
          value: AuthService().user,
          child: MyCustomForm(
            tabsIndex: 0,
          ));
    }
  }
}