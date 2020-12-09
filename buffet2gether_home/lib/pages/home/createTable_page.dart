//import 'dart:io';
//import 'dart:typed_data';
import 'package:buffet2gether_home/models/userFindGroup_model.dart';
import 'package:buffet2gether_home/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:buffet2gether_home/pages/home/editInterestingTable_page.dart';
import 'package:buffet2gether_home/models/table_model.dart';
import 'dart:math';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:provider/provider.dart';
import 'package:buffet2gether_home/pages/home/matching_page.dart';
import 'package:buffet2gether_home/models/mytable_model.dart';

///ส่วนที่ใช้เลือกเพศ จะมี Name กับ Icon
class GenderItem {
  final genderIcon;
  final genderName;

  const GenderItem(this.genderIcon, this.genderName);
}

/// list เพศที่มีให้เลือก
List genderList = <GenderItem>[
  const GenderItem(FontAwesomeIcons.mars, 'Male'),
  const GenderItem(FontAwesomeIcons.venus, 'Female'),
  const GenderItem(FontAwesomeIcons.venusMars, 'Not specified'),
];

class CreateTablePage extends StatefulWidget {
  ///รับข้อมูลร้านมาจากหน้า Info page
  CreateTablePage(
      {Key key,
        this.resID,
        this.name1,
        this.name2,
        this.image,
        this.location,
        this.time})
      : super(key: key);

  final String resID;
  final String image;
  final String name1;
  final String name2;
  final String location;
  final String time;

  @override
  _CreateTablePageState createState() => new _CreateTablePageState();
}

class _CreateTablePageState extends State<CreateTablePage> {
  ScrollController scrollController;

  ///ใช้แสดงคุณสมบัติต่างกันไป เช่นกดอายุขึ้นให้เลือกช่วงอายุ กดจำนวนขึ้นขึ้นให้เลือกจำนวนคน กดวันเวลาขึ้นให้เลือกวันเวลา กดเพศขึ้นให้เลือกเพศ
  ///ค่าเริ่มต้นเป็นอายุ
  int isSelecting = 0;

  ///เอาไว้แสดง gender ที่ถูกเลือก เป็น icon ในแถบคุณสมบัติ
  ///ค่าเริ่มต้น icon เป็น not specific แต่ genderName ที่เป็น string เป็น null
  ///ดังนั้น ต้อง เลือก เพศ ก่อน กด post
  Icon newGender = Icon(
    FontAwesomeIcons.venusMars,
    size: 23,
    color: Colors.deepOrange,
  );

  ///เอาไว้แสดงวันเวลาที่ถูกเลือกในแถบคุณสมบัติ
  ///ค่าเริ่มต้นเป็นวันเวลาปัจจุบัน
  DateTime newDateOfDue = DateTime.now();

  ///ใช้เป็นชนิด GenderItem จาก class ข้างบนเพื่อเก็บเป็น icon คู่ name(string)
  GenderItem selectedGender;

  /// จำนวนคนในห้อง ค่าเริ่มต้นเป็น 2
  double selectedNumm = 2;

  ///ช่วงอายุ ค่าเริ่มค้นเป็น 35-50 เป็นชนิด double เวลาจะใช้เป็น Int ต้องใส่ .round() ต่อท้าย
  RangeValues selectedRange = RangeValues(35, 50);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final user = Provider.of<User>(context);
    final userFindGroups = Provider.of<List<UserFindGroup>>(context);
    final mytable = Provider.of<Mytable>(context);

    ///ข้อมูลร้าน
    final info = Container(
        margin: EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 20),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 3,
              )
            ]),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.name1,
                  style: TextStyle(
                      fontFamily: 'Opun',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange),
                ),
                Text(
                  widget.name2,
                  style: TextStyle(
                      fontFamily: 'Opun',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  widget.image,
                  fit: BoxFit.contain,
                  width: 250,
                  height: 120,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 25,
                  color: Colors.amber,
                ),
                Expanded(
                  child: Text(
                    widget.location,
                    style: TextStyle(
                      fontFamily: 'Opun',
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.access_time, size: 25, color: Colors.amber),
                Text(
                  widget.time,
                  style: TextStyle(
                    fontFamily: 'Opun',
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ));

    /// Matching with
    final textMatch = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 15,
        ),
        Text(
          'Matching with',
          style: TextStyle(
            fontFamily: 'Opun',
            color: Colors.red,
            fontSize: 19,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    ///คุณสมบัติต่างๆ
    final properties = Container(
      width: screenSize.width,
      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 5,
            )
          ]),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ///age
            InkWell(
                onTap: () {
                  setState(() {
                    /// กดแล้วแสดงให้เลือกอายุ
                    isSelecting = 0;
                  });
                },
                child: Text(
                  ///ค่าอายุเริ่ม - ค่าอายุจบ
                  '${selectedRange.start.round()} - ${selectedRange.end.round()}',
                  style: TextStyle(
                    fontFamily: 'Opun',
                    color: Colors.deepOrange,
                    fontSize: 15,
                  ),
                )),
            Text(
              '|',
              style: TextStyle(
                fontFamily: 'Opun',
                color: Colors.amberAccent,
                fontSize: 25,
              ),
            ),

            ///maxNum
            InkWell(
              onTap: () {
                setState(() {
                  /// กดจำนวนคน ขึ้นให้เลือกจำนวนคน
                  isSelecting = 1;
                });
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Text(
                      /// 1/จำนวนคนที่เลือก
                      '1 / ${selectedNumm.round()}',
                      style: TextStyle(
                        fontFamily: 'Opun',
                        color: Colors.deepOrange,
                        fontSize: 15,
                      ),
                    ),
                    Icon(
                      Icons.people,
                      color: Colors.deepOrange,
                      size: 23,
                    )
                  ],
                ),
              ),
            ),
            Text(
              '|',
              style: TextStyle(
                fontFamily: 'Opun',
                color: Colors.amberAccent,
                fontSize: 25,
              ),
            ),

            ///Date and time
            InkWell(
              onTap: () {
                setState(() {
                  /// กดวันเวลา ขึ้นให้เลือกวันเวลา
                  isSelecting = 2;
                });
                return DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime.now().add(new Duration(days: 30)),

                  ///นับจากเวลาปัจจุบันไปอีก 30 วัน
                  onConfirm: (date) {
                    newDateOfDue = date;

                    /// ใส่ setState ว่างๆไว้ให้มัน Update auto
                    setState(() {});
                  },
                  locale: LocaleType.th,
                );
              },
              child: Text(
                DateFormat('dd-MM-yyyy  h:mm a').format(newDateOfDue),
                style: TextStyle(
                  fontFamily: 'Opun',
                  color: Colors.deepOrange,
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              '|',
              style: TextStyle(
                fontFamily: 'Opun',
                color: Colors.amberAccent,
                fontSize: 25,
              ),
            ),

            ///gender
            InkWell(
              onTap: () {
                setState(() {
                  /// กดเพศ ขึ้นให้เลือกเพศ
                  isSelecting = 3;
                });
              },
              child: newGender,
            ),
          ],
        ),
      ),
    );

    /// จาก isSelecting ใน properties กดอะไรขึ้นอันนั้น
    WhichProp() {
      return IndexedStack(
          index: isSelecting,
          alignment: Alignment.center,
          children: [
            ///ให้เลือก age
            RangeSlider(
              activeColor: Colors.pink,

              ///สีช่วงเลือก
              inactiveColor: Colors.amberAccent,

              ///สีช่วงธรรมดา
              values: selectedRange,
              min: 10,

              ///อายุต่ำสุด
              max: 60,

              ///อายุสูงสุด
              divisions: 50,

              ///ช่วง 50 ช่วง(60-10=50) ห่างกันช่วงละ 1
              labels: RangeLabels(

                ///ป้ายบอกเลข
                  '${selectedRange.start.round()}',
                  '${selectedRange.end.round()}'),
              onChanged: (value) {
                setState(() {
                  selectedRange = value;
                });
              },
            ),

            ///ให้เลือก maxNum
            Slider(
              ///เหมือน RangeSlider
              activeColor: Colors.pink,
              inactiveColor: Colors.amberAccent,
              value: selectedNumm,
              min: 2,
              max: 10,
              divisions: 8,
              label: '${selectedNumm.round()}',
              onChanged: (value) {
                setState(() {
                  selectedNumm = value;
                });
              },
            ),

            ///ให้เลือก Date and time
            Container(
              /// Date and time มันขึ้นอัตโนมัติอยู่แล้ว อันนี้เลยทำไว้ให้มันมี Index 2 เฉย ๆ
              color: Color(0xfff5f5f5),
              width: 1,
              height: 1,
            ),

            ///ให้เลือก gender
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<GenderItem>(
                hint: Text('select gender'),
                isDense: true,
                isExpanded: true,
                style: TextStyle(
                  fontFamily: 'Opun',
                  color: Colors.black,
                  fontSize: 13,
                ),
                underline: Container(
                  height: 1,
                  color: Colors.black12,
                ),
                value: selectedGender,
                onChanged: (GenderItem value) {
                  setState(() {
                    selectedGender = value;

                    ///เก็บเพศที่เลือกทั้ง icon และ name(string)
                    newGender = Icon(
                      ///เอาแค่ icon ที่เลือกไปแสดง
                      selectedGender.genderIcon,
                      size: 23,
                      color: Colors.deepOrange,
                    );
                  });
                },
                items: genderList.map<DropdownMenuItem<GenderItem>>((value)

                ///list ให้เลือก
                {
                  return DropdownMenuItem<GenderItem>(
                    value: value,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          value.genderIcon,
                          color: Colors.black38,
                        ),
                        SizedBox(width: 10),
                        Text(value.genderName),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ]);
    }

    ///Text interest
    final interest = Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'Interesting',
              style: TextStyle(
                fontFamily: 'Opun',
                color: Colors.red,
                fontSize: 19,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            GestureDetector(
              child: Text(
                'Edit',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onTap: () {
                /// กด edit ไปหน้า edit interesting table
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => InterestingInTable()));
              },
            ),
          ],
        ));

    /// แสดง interest ตามที่เลือกจากหน้า edit interesting table
    final interestList = Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,

          /// myTable มาจาก table model จะมี list bool interest อยู่
          itemCount: myTable.interestingIconUrl.length,
          itemBuilder: (BuildContext context, int index) {
            if (myTable.interestingBool[index])

              ///ถ้าถูกเลือกขึ้นสีส้ม
            {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  myTable.interestingIconUrl[index],
                  color: Theme.of(context).accentColor,
                ),
              );
            }
            return Padding(
              ///ไม่เลือกขึ้นเเทา
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                myTable.interestingIconUrl[index],
                color: Theme.of(context).buttonColor,
              ),
            );
          }),
    );

    final allInPage = Container(
        color: Color(0xFFF5F5F5),
        child: Column(
          children: [
            info,
            textMatch,
            properties,
            SizedBox(
              height: 60,
            ),
            WhichProp(),
            SizedBox(
              height: 60,
            ),
            interest,
            interestList,
            SizedBox(
              height: 30,
            )
          ],
        ));

    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(
            '+ เพิ่มโต๊ะของคุณ',
            style: TextStyle(
                fontFamily: 'Opun',
                color: Colors.deepOrange,
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white70,
          actions: <Widget>[
            StreamBuilder<UserData>(
                stream: DatabaseService(uid: user?.userId).userData,
                builder: (context, snapshot) {
                  return InkWell(
                    onTap: () {
                      if (selectedGender?.genderName == null)

                        ///ถ้าไม่เลือก gender จะกด post ไม่ได้ เลยทำอันนี้ไว้เตือน แต่มันไม่ขึ้น...แงงงงง
                      {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  content: Text(
                                    'Please select gender',
                                    style: TextStyle(
                                      fontFamily: 'Opun',
                                      color: Colors.black45,
                                      fontSize: 10,
                                    ),
                                  ));
                            });
                      } else

                        ///กด post ได้
                      {
                        if (mytable.numberTable == null) {
                          int numberTable = new Random().nextInt(100);
                          DatabaseService().updateGroups(
                              widget.resID,
                              widget.name1,
                              widget.name2,
                              widget.image,
                              widget.location,
                              widget.time,
                              selectedRange.start.round(),
                              selectedRange.end.round(),
                              selectedNumm,
                              newDateOfDue,
                              selectedGender.genderName,

                              ///ข้อมูลร้าน
                              myTable.interestingBool[0],
                              myTable.interestingBool[1],
                              myTable.interestingBool[2],
                              myTable.interestingBool[3],
                              myTable.interestingBool[4],
                              myTable.interestingBool[5],
                              myTable.interestingBool[6],
                              numberTable.toString());

                          ///หัวข้อที่สนใจ
                          UserData userData = snapshot.data;

                          ///เพิ่มข้อมูลของตัวเจ้าของห้องให้เป็นสมาชิกในกลุ่มคนแรก
                          DatabaseService().updateMemberInGroup(
                              widget.resID,
                              userData.profilePicture,
                              userData.name,
                              numberTable.toString(),
                              userData.gender,
                              (DateTime.now()
                                  .difference(userData.dateofBirth)
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
                              userData.userId);

                          ///เพิ่ม ID ของเราเป็น Master ของกลุ่มนี้
                          DatabaseService().updateMasterData(widget.resID,
                              numberTable.toString(), userData.userId, false);

                          ///ถ้ามี  user find group ของร้านนี้อยู่ก่อนแล้ว ให้เพิ่ม user find group ทุกคนใน notification ของเรา
                          for (var item in userFindGroups) {
                            DatabaseService().updateNotifData(
                                widget.resID,
                                item.imageUrl,
                                item.name,
                                null,
                                false,
                                item.gender,
                                item.age,
                                item.fashion,
                                item.sport,
                                item.technology,
                                item.politics,
                                item.entertainment,
                                item.book,
                                item.pet,
                                item.userID,
                                userData.userId);
                          }

                          ///เพิ่มหน้า Table ของเราว่าเรามีโต๊ะเลขนี้แล้ว
                          DatabaseService().updateTableData(widget.resID,
                              numberTable.toString(), userData.userId);

                          //// ไปหมุนหน้าน้องบุฟ 3 วิ ละค่อยไปหน้า Table
                          return Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                              StreamProvider<Mytable>.value(
                                  value: DatabaseService(
                                      userID: userData.userId)
                                      .mytable,
                                  child: MatchingPage())));
                        } else {
                          /// ถ้ามีโต๊ะแล้วจะกด post ไม่ได้แล้วให้ขึ้นแจ้งเตือน
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  'ขออภัย...ไม่สามารถสร้างกลุ่มใหม่ได้เนื่องจากคุณมีกลุ่มบุฟเฟฟต์แล้ว',
                                  style: TextStyle(
                                    fontFamily: 'Opun',
                                    color: Colors.deepOrange,
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }
                    },
                    child: Text(
                      'Post    ',
                      style: TextStyle(
                        fontFamily: 'Opun',
                        color: Colors.orange,
                        fontSize: 20,
                      ),
                    ),
                  );
                }),
          ],
        ),
        body: SafeArea(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return allInPage;
            },
          ),
        ));
  }
}