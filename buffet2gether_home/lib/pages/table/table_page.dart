import 'package:buffet2gether_home/models/memberBarListInTable_model.dart';
import 'package:buffet2gether_home/pages/table/myTable.dart';
import 'package:buffet2gether_home/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buffet2gether_home/models/infoInTable_model.dart';
import 'package:buffet2gether_home/models/mytable_model.dart';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:buffet2gether_home/services/auth.dart';
import 'package:buffet2gether_home/models/userMaster_model.dart';
import 'package:buffet2gether_home/shared/loading.dart';

//----------------------------------------Table page------------------------------------
class Table1 extends StatefulWidget
{
  @override
  _Table1State createState() => new _Table1State();
}
class _Table1State extends State<Table1>
{
  ScrollController scrollController;


  @override
  Widget build(BuildContext context)
  {
    final mytable = Provider.of<Mytable>(context);
    final user = Provider.of<User>(context);

    final tablePageDefault = new Scaffold(
      appBar: new AppBar(
        leading: new Container(),
        centerTitle: true,
        title: new Text(
          'โต๊ะของคุณ!',
          style: TextStyle(
              color: Colors.deepOrange,
              fontFamily: 'Opun',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xfff5f5f5),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                new Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/buffet2gether.appspot.com/o/restaurantAndPromotion_pictures%2FBuffet_transparent.png?alt=media&token=cb9c8611-b998-42aa-92f5-6972a91078cb',
                    width: 500,
                    height: 250),
                Text(
                  'ยังไม่มีโต๊ะเลย...ไปเพิ่มโต๊ะบุฟเฟ่กัน!',
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontFamily: 'Opun',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ]
          )
      ),
    );

    if (mytable?.numberTable == null){
      return tablePageDefault;
    }else
    {
      return Scaffold(
        appBar: new AppBar(
          leading: new Container(),
          centerTitle: true,
          title: new Text(
            'โต๊ะของคุณ!',
            style: TextStyle(
                color: Colors.deepOrange,
                fontFamily: 'Opun',
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Color(0xfff5f5f5),
        ),
        body:
        StreamProvider<UserMaster>.value(
          value: DatabaseService(resID: mytable?.resID,numberTable: mytable?.numberTable).userMasterMax,
          child: StreamProvider<User>.value(
            value: AuthService().user,
            child: StreamProvider<Mytable>.value(
                value:DatabaseService(userID: user.userId).mytable,
                child: StreamProvider<List<MemberBarListInTable>>.value(
                  value: DatabaseService(numberTable: mytable?.numberTable,resID: mytable?.resID).memberInTable,
                  child: StreamProvider<InfoInTable>.value(
                      value: DatabaseService(numberTable:mytable?.numberTable,resID: mytable?.resID).infoInTable,
                      child: MyTable1()),

                )
            ),
          ),

        ),
      );
    }
  }
}