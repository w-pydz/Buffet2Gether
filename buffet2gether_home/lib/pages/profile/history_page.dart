import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:buffet2gether_home/models/table_model.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  ///รับข้อมูลร้านมาจากหน้า Info page
  HistoryPage(
      {Key key,
        this.resID,
        this.name1,
        this.name2,
        this.image,
        this.location,
        this.time,
        this.ageStart,
        this.ageEnd,
        this.num,
        this.dueTime,
        this.gender,
        this.fashion,
        this.sport,
        this.technology,
        this.politics,
        this.entertainment,
        this.book,
        this.pet})
      : super(key: key);

  final String resID;
  final String image;
  final String name1;
  final String name2;
  final String location;
  final String time;
  final int ageStart;
  final int ageEnd;
  final double num;
  final String dueTime;
  final String gender;
  final bool fashion;
  final bool sport;
  final bool technology;
  final bool politics;
  final bool entertainment;
  final bool book;
  final bool pet;

  @override
  _HistoryPageState createState() => new _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  ScrollController scrollController;

  Icon gender;

  @override
  Widget build(BuildContext context) {
    List<bool> interestingList = [
      widget.fashion,
      widget.sport,
      widget.technology,
      widget.politics,
      widget.entertainment,
      widget.book,
      widget.pet
    ];

    if (widget.gender == 'Male') {
      gender = Icon(
        FontAwesomeIcons.mars,
        color: Colors.deepOrange,
      );
    } else if (widget.gender == 'Female') {
      gender = Icon(
        FontAwesomeIcons.venus,
        color: Colors.deepOrange,
      );
    } else if (widget.gender == 'Not specified') {
      gender = Icon(
        FontAwesomeIcons.venusMars,
        color: Colors.deepOrange,
      );
    }

    final screenSize = MediaQuery.of(context).size;

    // แปลง time stamp ให้เป็น date Time
    int getDueTime() {
      String stringDueTime = widget.dueTime.substring(18, 28);
      return int.parse(stringDueTime);
    }

    DateTime newDueTime =
    new DateTime.fromMillisecondsSinceEpoch(getDueTime() * 1000);

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
                Text(
                  widget.location,
                  style: TextStyle(
                    fontFamily: 'Opun',
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
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
            Text(
              ///ค่าอายุเริ่ม - ค่าอายุจบ
              widget.ageStart.toString() + ' - ' + widget.ageEnd.toString(),
              style: TextStyle(
                fontFamily: 'Opun',
                color: Colors.deepOrange,
                fontSize: 15,
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

            ///maxNum
            Container(
              child: Row(
                children: <Widget>[
                  Text(
                    /// 1/จำนวนคนที่เลือก
                    widget.num.round().toString() +
                        ' / ' +
                        widget.num.round().toString(),
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
            Text(
              '|',
              style: TextStyle(
                fontFamily: 'Opun',
                color: Colors.amberAccent,
                fontSize: 25,
              ),
            ),

            ///Date and time
            Text(
              DateFormat('dd-MM-yyyy  h:mm a').format(newDueTime),
              style: TextStyle(
                fontFamily: 'Opun',
                color: Colors.deepOrange,
                fontSize: 15,
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
            gender
          ],
        ),
      ),
    );

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
          ],
        ));

    /// แสดง interest ตามที่เลือกจากหน้า edit interesting table
    final interestList = Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      height: 50,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,

          /// myTable มาจาก table model จะมี list bool interest อยู่
          itemCount: interestingList.length,
          itemBuilder: (BuildContext context, int index) {
            if (interestingList[index])

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
            'History',
            style: TextStyle(
                fontFamily: 'Opun',
                color: Colors.deepOrange,
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white70,
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