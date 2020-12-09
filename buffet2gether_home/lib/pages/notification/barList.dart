import 'package:buffet2gether_home/models/infoInTable_model.dart';
import 'package:buffet2gether_home/models/userMaster_model.dart';
import 'package:buffet2gether_home/main.dart';
import 'package:buffet2gether_home/services/database.dart';
import 'package:buffet2gether_home/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buffet2gether_home/models/bar_model.dart';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:buffet2gether_home/services/auth.dart';
import 'package:buffet2gether_home/models/mytable_model.dart';
import 'package:buffet2gether_home/models/userFindGroup_model.dart';
import 'package:buffet2gether_home/models/tableInfo.dart';

/// คลาสที่นำ list ของแถบแจ้งเตือนมาสร้างเป็น ListView.builder เพื่อไปแสดงในหน้า Notification
class BarList extends StatefulWidget {
  @override
  _BarListState createState() => _BarListState();
}

class _BarListState extends State<BarList> {
  @override
  Widget build(BuildContext context) {
    final bars = Provider.of<List<Bar>>(context);
    final user = Provider.of<User>(context);
    final mytable = Provider.of<Mytable>(context);
    final userFindGroups = Provider.of<List<UserFindGroup>>(context);
    //print('now in barlist');
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: bars?.length ?? 0,
        itemBuilder: (context, index) {
          //print('now');
          final bar = bars[index];

          return StreamBuilder<List<UserFindGroup>>(
              stream: DatabaseService(resID: mytable.resID).userFindGroup,
              builder: (context, snapshot4) {
                return StreamBuilder<UserMaster>(
                    stream: DatabaseService(
                        resID: bar.getResID(), numberTable: bar.getNumber())
                        .userMasterMax,
                    builder: (context, snapshot1) {
                      //if (snapshot1.hasData) {
                      UserMaster userMaster = snapshot1.data;
                      return StreamBuilder<UserMaster>(
                          stream: DatabaseService(
                              resID: mytable.resID,
                              numberTable: mytable.numberTable)
                              .userMasterMax,
                          builder: (context, snapshot2) {
                            //if (snapshot2.hasData) {
                            UserMaster master = snapshot2.data;
                            return StreamBuilder<TableInfo>(
                                stream: DatabaseService(
                                    resID: mytable.resID,
                                    numberTable: mytable.numberTable)
                                    .groupInterest,
                                builder: (context, snapshot3) {
                                  //if (snapshot3.hasData) {
                                  return StreamBuilder<UserData>(
                                      stream: DatabaseService(uid: user?.userId)
                                          .userData,
                                      builder: (context, snapshot) {
                                        //if (snapshot.hasData) {
                                        UserData userData = snapshot.data;
                                        TableInfo tableInfo = snapshot3.data;

                                        if (mytable.resID != null) {
                                          if (snapshot4.hasData &&
                                              snapshot3.hasData) {
                                            for (var item in userFindGroups) {
                                              //matching
                                              if (((item
                                                  .getBook() &&
                                                  tableInfo
                                                      .getBook()) ==
                                                  false) &&
                                                  ((item
                                                      .getEntertainment() &&
                                                      tableInfo
                                                          .getEntertainment()) ==
                                                      false) &&
                                                  ((item
                                                      .getFashion() &&
                                                      tableInfo
                                                          .getFashion()) ==
                                                      false) &&
                                                  ((item.getPet() &&
                                                      tableInfo.getPet()) ==
                                                      false) &&
                                                  ((item.getPolitics() &&
                                                      tableInfo
                                                          .getPolitics()) ==
                                                      false) &&
                                                  ((item.getSport() &&
                                                      tableInfo
                                                          .getSport()) ==
                                                      false) &&
                                                  ((item.getTechnology() &&
                                                      tableInfo
                                                          .getTechnology()) ==
                                                      false)) {
                                                DatabaseService().deleteNotifData(
                                                    item.userID,
                                                    userData
                                                        .userId); ////เอาไว้ลบ document firebase
                                                continue;
                                              }

                                              if ((item.age <
                                                  tableInfo
                                                      .getAgeStart()) ||
                                                  (item.age >
                                                      tableInfo.getAgeEnd())) {
                                                DatabaseService().deleteNotifData(
                                                    item.userID,
                                                    userData
                                                        .userId); ////เอาไว้ลบ document firebase
                                              }

                                              if (tableInfo.getGender() ==
                                                  'Male') {
                                                if (item.getGender() !=
                                                    'Male') {
                                                  DatabaseService().deleteNotifData(
                                                      item.userID,
                                                      userData
                                                          .userId); ////เอาไว้ลบ document firebase
                                                }
                                              } else if (tableInfo
                                                  .getGender() ==
                                                  'Female') {
                                                if (item.getGender() !=
                                                    'Female') {
                                                  DatabaseService().deleteNotifData(
                                                      item.userID,
                                                      userData
                                                          .userId); ////เอาไว้ลบ document firebase
                                                }
                                              }
                                            }
                                          } else {
                                            if (snapshot.hasError) {
                                              print(snapshot.error.toString());
                                            }
                                            return Loading();
                                          }
                                        } else {
                                          if (bar.getNumber() == null) {
                                            DatabaseService().deleteNotifData(
                                                bar.getUserID(),
                                                userData
                                                    .userId); ////เอาไว้ลบ document firebase
                                          }
                                        }

                                        return Dismissible(
                                          ////Dismission คือให้มันปัดซ้ายปัดขวาได้
                                          secondaryBackground: Container(
                                              color: Colors.red,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(Icons.cancel),
                                                  Text(' delete   '),
                                                ],
                                              )),
                                          background: Container(
                                              color: Colors.green,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text('   '),
                                                  Icon(Icons.check_circle),
                                                  Text(' accept'),
                                                ],
                                              )),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.deepOrange[50]),
                                              child: ListTile(
                                                /// สร้าง bar
                                                title:
                                                bar.buildNotifBar(context),
                                                subtitle:
                                                bar.buildGroupBar(context),
                                              )),
                                          key: UniqueKey(),
                                          onDismissed:
                                              (DismissDirection direction) {
                                            setState(() {
                                              bars.removeAt(index);
                                            });

                                            DatabaseService().deleteNotifData(
                                                bar.getdocumentID(),
                                                userData
                                                    .userId); ////เอาไว้ลบ document firebase เวลาปัดซ้ายปัดขวา
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(direction ==
                                                  DismissDirection
                                                      .startToEnd
                                                  ? 'accept'
                                                  : 'delete'),
                                              backgroundColor: direction ==
                                                  DismissDirection
                                                      .startToEnd
                                                  ? Colors.green
                                                  : Colors.red,
                                            ));

                                            if (direction ==
                                                DismissDirection.startToEnd) {
                                              ////// ถ้า accept
                                              if (bar.getNumber() != null) {
                                                /////////ถ้าเป็น Group bar จะมีเลขกลุ่ม
                                                if (mytable.numberTable ==
                                                    null) {
                                                  if (userMaster.max == false) {
                                                    //////////////// เพิ่มตัวเองลงในกลุ่มที่ยอมรับนั้น /////////////////////
                                                    DatabaseService()
                                                        .updateMemberInGroup(
                                                      bar.getResID(),
                                                      userData.profilePicture,
                                                      userData.name,
                                                      bar.getNumber(),
                                                      userData.gender,
                                                      (DateTime.now()
                                                          .difference(
                                                          userData
                                                              .dateofBirth)
                                                          .inDays /
                                                          365)
                                                          .floor(),
                                                      userData.fashion,
                                                      userData.sport,
                                                      userData.technology,
                                                      userData.politics,
                                                      userData.entertainment,
                                                      userData.book,
                                                      userData.pet,
                                                      userData.userId,
                                                    );
                                                    /////////////// เพิ่มหน้า Table ของเราว่าเรามีกลุ่มแล้ว /////////////
                                                    DatabaseService()
                                                        .updateTableData(
                                                        bar.getResID(),
                                                        bar.getNumber(),
                                                        userData.userId);
                                                    ////////////// ลบข้อมูล document ของเราใน user find Group เพราะเรามีกลุ่มแล้ว
                                                    DatabaseService()
                                                        .deleteUserFindGroupData(
                                                        bar.getResID(),
                                                        userData.userId);

                                                    ///////////// ไปที่หน้า Table///////////////////////////////
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                            context) =>
                                                            StreamProvider<
                                                                User>.value(
                                                                value:
                                                                AuthService()
                                                                    .user,
                                                                child:
                                                                MyCustomForm(
                                                                  tabsIndex:
                                                                  1,
                                                                ))));
                                                  } else {
                                                    return showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                            'ขออภัย...ไม่สามารถเข้ากลุ่มได้เนื่องจากกลุ่มนี้เต็มแล้ว',
                                                            style: TextStyle(
                                                              fontFamily:
                                                              'Opun',
                                                              color: Colors
                                                                  .deepOrange,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                } else {
                                                  return showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        content: Text(
                                                          'ขออภัย...ไม่สามารถเข้ากลุ่มได้เนื่องจากคุณมีกลุ่มแล้ว',
                                                          style: TextStyle(
                                                            fontFamily: 'Opun',
                                                            color: Colors
                                                                .deepOrange,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              } else {
                                                /////////////////////// ถ้าเป็นแจ้งเตือนคนมาหากลุ่ม
                                                if (master.max == false) {
                                                  bool haveInFindGroup = false;
                                                  for (var item
                                                  in userFindGroups) {
                                                    if (bar.getUserID() ==
                                                        item.userID) {
                                                      haveInFindGroup = true;

                                                      //////////// ถ้าผู้ใช้ที่เราเชิญเข้ากลุ่มอยู่ใน userFindGroup ให้ส่งแจ้งเตือนเชิญเข้ากลุ่มไปที่ user คนนั้น
                                                      DatabaseService().updateNotifData(
                                                          mytable?.resID,
                                                          userData
                                                              .profilePicture,
                                                          userData.name,
                                                          mytable.numberTable,
                                                          true,
                                                          userData.gender,
                                                          (DateTime.now()
                                                              .difference(
                                                              userData
                                                                  .dateofBirth)
                                                              .inDays /
                                                              365)
                                                              .floor(),
                                                          userData.fashion,
                                                          userData.sport,
                                                          userData.technology,
                                                          userData.politics,
                                                          userData
                                                              .entertainment,
                                                          userData.book,
                                                          userData.pet,
                                                          userData.userId,
                                                          bar.getUserID());
                                                    }
                                                  }

                                                  if (haveInFindGroup ==
                                                      false) {
                                                    //////////ถ้าผู้ใช้ไม่ได้อยู่ใน userFindGroup แปลว่าระหว่งที่เรายังไม่กดเชิญ ผู้ใช้นั้นมีกลุ่มไปแล้ว จึงถูกลบออกจาก user find group
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                            'ขออภัย...ไม่สามารถเชิญได้เนื่องจาก ' +
                                                                bar.getMemberName() +
                                                                ' มีกลุ่มบุฟเฟฟต์แล้ว',
                                                            style: TextStyle(
                                                              fontFamily:
                                                              'Opun',
                                                              color: Colors
                                                                  .deepOrange,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        content: Text(
                                                          'ขออภัย...กลุ่มของคุณเต็มแล้ว',
                                                          style: TextStyle(
                                                            fontFamily: 'Opun',
                                                            color: Colors
                                                                .deepOrange,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              }
                                            }
                                          },
                                        );
                                        //} else {
                                        // return Container();
                                        //}
                                      });
                                  //} else {
                                  //return Container();
                                  //}
                                });
                            //} else {
                            //  return Container();
                            //}
                          });
                      //} else {
                      //  return Container();
                      //}
                    });
              });
        });
  }
}