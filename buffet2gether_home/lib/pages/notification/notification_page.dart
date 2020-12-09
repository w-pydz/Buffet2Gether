import 'package:buffet2gether_home/models/bar_model.dart';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:buffet2gether_home/models/table_model.dart';
import 'package:buffet2gether_home/pages/notification/barList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buffet2gether_home/services/database.dart';
import 'package:provider/provider.dart';
import 'package:buffet2gether_home/services/auth.dart';
import 'package:buffet2gether_home/models/mytable_model.dart';
import 'package:buffet2gether_home/models/userFindGroup_model.dart';
import 'package:buffet2gether_home/shared/loading.dart';

//----------------------------------------Notification page------------------------------------
class NotifColumn extends StatefulWidget {
  @override
  _NotifColumnState createState() => new _NotifColumnState();
}

class _NotifColumnState extends State<NotifColumn> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context)
  {
    final user = Provider.of<User>(context);
    final mytable = Provider.of<Mytable>(context);
    //print('now in notif');

    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          leading: new Container(),
          title: Text(
            'การแจ้งเตือน',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Opun',
              color: Colors.deepOrange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xfff5f5f5),
        ),
        body:StreamBuilder<List<UserFindGroup>>(
            stream: DatabaseService(resID: mytable?.resID).userFindGroup,
            builder: (context, snapshot) {
              if (snapshot.hasData)
              {
                return StreamProvider<List<UserFindGroup>>.value(
                  value: DatabaseService(resID: mytable?.resID).userFindGroup,
                  child: StreamProvider<Mytable>.value(
                    value: DatabaseService(userID: user?.userId).mytable,
                    child: StreamProvider<User>.value(
                      value: AuthService().user,
                      child: StreamProvider<List<Bar>>.value(
                          value: DatabaseService(userID: user?.userId).notifications,
                          child: BarList()
                      ),
                    ),
                  ),
                );
              }
              else
              {
                if (snapshot.hasError)
                {
                  print(snapshot.error.toString());
                }
                return Loading();
              }
            })
    );
  }
}