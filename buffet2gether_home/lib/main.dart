//---------------------------- Buffet2Gether adated-------------------------------------
//import 'dart:html';
import 'package:buffet2gether_home/models/promotion_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:buffet2gether_home/pages/home/home_page.dart';
import 'package:buffet2gether_home/pages/profile/profile_screen.dart';
import 'package:buffet2gether_home/pages/notification/notification_page.dart';
import 'package:buffet2gether_home/pages/table/table_page.dart';
import 'package:buffet2gether_home/services/database.dart';
import 'package:provider/provider.dart';
import 'package:buffet2gether_home/pages/login/getStarted_page.dart';
import 'package:buffet2gether_home/models/rec_model.dart';
import 'package:buffet2gether_home/models/more_model.dart';
import 'package:buffet2gether_home/services/auth.dart';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:buffet2gether_home/models/mytable_model.dart';
import 'package:buffet2gether_home/models/history_model.dart';

void main() {
  //debugPaintSizeEnabled=true;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Buffet2Gether',
        theme: ThemeData(
          primaryColor: Colors.deepOrange,
          accentColor: Colors.deepOrangeAccent,
          scaffoldBackgroundColor: Color(0xFFF3F5F7),
        ),
        home: new GetStartedColumn());
  }
}

//-------------------------------------main---------------------------------------------
class MyCustomForm extends StatefulWidget {
  MyCustomForm({this.tabsIndex});

  int tabsIndex;

  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyCustomForm>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(
        length: 4, vsync: this, initialIndex: widget.tabsIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabs = <Tab>[
      new Tab(
        icon: new Icon(Icons.home),
      ),
      new Tab(
        icon: new Icon(Icons.fastfood),
      ),
      new Tab(
        icon: new Icon(Icons.notifications_active),
      ),
      new Tab(
        icon: new Icon(Icons.assignment_ind),
      ),
    ];

    final user = Provider.of<User>(context);

    return new Scaffold(
      body: SafeArea(
          child: new TabBarView(
            controller: controller,
            children: <Widget>[
              StreamProvider<User>.value(
                value: AuthService().user,
                child: StreamProvider<List<Recom>>.value(
                  value: DatabaseService().recInRes,
                  child: StreamProvider<List<More>>.value(
                      value: DatabaseService().moreInRes,
                      child: StreamProvider<List<Promo>>.value(
                        value: DatabaseService().promotionPic,
                        child: new HomeColumn(),
                      )),
                ),
              ),
              StreamProvider<User>.value(
                value: AuthService().user,
                child: StreamProvider<Mytable>.value(
                    value: DatabaseService(userID: user?.userId).mytable,
                    child: new Table1()),
              ),
              StreamProvider<Mytable>.value(
                value: DatabaseService(userID: user?.userId).mytable,
                child: StreamProvider<User>.value(
                    value: AuthService().user,
                    child: new NotifColumn()),
              ),
              StreamProvider<User>.value(
                  value: AuthService().user,
                  child: StreamProvider<History>.value(
                    value: DatabaseService(userID: user?.userId).history,
                    child: ProfileScreen(),
                  ))
            ],
          )),
      bottomNavigationBar: new Material(
        color: Colors.white,
        shadowColor: Colors.deepOrange,
        child: new TabBar(
          controller: controller,
          tabs: tabs,
          unselectedLabelColor: Colors.black38,
          labelColor: Colors.deepOrange,
          indicatorColor: Colors.deepOrange,
          indicatorWeight: 3.0,
        ),
      ),
    );
  }
}