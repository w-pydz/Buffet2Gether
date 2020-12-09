import 'package:buffet2gether_home/models/memberBarListInTable_model.dart';
import 'package:buffet2gether_home/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buffet2gether_home/models/infoInTable_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:buffet2gether_home/models/mytable_model.dart';
import 'package:buffet2gether_home/models/userMaster_model.dart';
import 'package:buffet2gether_home/models/table_model.dart';
import 'package:buffet2gether_home/shared/loading.dart';

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


/////////////////////////////////////////////Table page///////////////////////////////////////////////
class MyTable1 extends StatefulWidget
{
  @override
  _MyTable1State createState() => new _MyTable1State();
}

class _MyTable1State extends State<MyTable1>
{
  ScrollController scrollController;

  @override
  Widget build(BuildContext context)
  {
    final user = Provider.of<User>(context);
    final mytable = Provider.of<Mytable>(context);
    final listMember = Provider.of<List<MemberBarListInTable>>(context);
    final infoFromTable = Provider.of<InfoInTable>(context);

    final screenSize = MediaQuery.of(context).size;
    final userMaster = Provider.of<UserMaster>(context);
    bool iAmMaster = false;
    ///คุณสมบัติต่างๆ
    // แปลง time stamp ให้เป็น date Time
    int getDueTime(){
      if(infoFromTable?.dueTime != null){
        String stringDueTime = infoFromTable?.dueTime.substring(18,28);
        return int.parse(stringDueTime);
      }else{
        return 0;
      }

    }
    DateTime newDueTime = new DateTime.fromMillisecondsSinceEpoch(getDueTime()*1000);

    if(infoFromTable?.people != null){
      if(listMember?.length == infoFromTable?.people.round()){
        if(userMaster?.max == false){
          DatabaseService().updateMasterData(mytable.resID, mytable.numberTable, userMaster?.userId, true);
        }
      }
    }

    final buttonLeaveGroup = Container(
      margin: EdgeInsets.all(10),
      width: 410,
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed:(){
              /////////////////////////// ลบข้อมูลตัวเองออกจากกลุ่มอย่างเดียว
              DatabaseService().deleteGroupData(mytable.resID, mytable.numberTable,user?.userId,null);
              DatabaseService().updateTableData(null, null,user?.userId);
            } ,
            child:Icon(Icons.exit_to_app),
            backgroundColor:Colors.red,
            tooltip: 'Leave group',
          ),
        ],
      ),


    );
    final buttonFinish = Container(
      margin: EdgeInsets.all(10),
      width: 410,
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: (){
              for (var item in listMember) /////////////////////////// ลบข้อมูลคนอื่นออกจากกลุ่ม
                  {
                if(item?.userID != user?.userId)
                {
                  DatabaseService().updateFinish(
                      mytable.resID,
                      infoFromTable.name1,
                      infoFromTable.name2,
                      infoFromTable.imageUrl,
                      infoFromTable.location,
                      infoFromTable.time,
                      infoFromTable.ageStart,
                      infoFromTable.ageEnd,
                      infoFromTable?.people,
                      newDueTime,
                      infoFromTable.gender,
                      infoFromTable.fashion,
                      infoFromTable.sport,
                      infoFromTable.technology,
                      infoFromTable.politics,
                      infoFromTable.entertainment,
                      infoFromTable.book,
                      infoFromTable.pet,
                      infoFromTable.number,
                      item?.userID);
                  DatabaseService().deleteGroupData(mytable.resID, mytable.numberTable,item?.userID,null);
                  DatabaseService().updateTableData(null, null,item?.userID);
                }
              }
              /////////////////////////// ลบข้อมูลตัวเองออกจากกลุ่ม
              DatabaseService().updateFinish(
                  mytable.resID,
                  infoFromTable.name1,
                  infoFromTable.name2,
                  infoFromTable.imageUrl,
                  infoFromTable.location,
                  infoFromTable.time,
                  infoFromTable.ageStart,
                  infoFromTable.ageEnd,
                  infoFromTable?.people,
                  newDueTime,
                  infoFromTable.gender,
                  infoFromTable.fashion,
                  infoFromTable.sport,
                  infoFromTable.technology,
                  infoFromTable.politics,
                  infoFromTable.entertainment,
                  infoFromTable.book,
                  infoFromTable.pet,
                  infoFromTable.number,
                  user?.userId);
              DatabaseService().deleteGroupData(mytable.resID, mytable.numberTable,user?.userId,'info');
              DatabaseService().updateTableData(null, null,user?.userId);
            },
            child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/buffet2gether.appspot.com/o/notificationAndTable_test%2Ffinish.png?alt=media&token=8eb679d9-be8a-4a77-8fc5-4da352700d7e',
                width: 100,
                height:100),
          )
        ],
      ),


    );

    final nongBuffet = Container(
      margin: EdgeInsets.all(10),
      width: 410,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Image.network(
              'https://firebasestorage.googleapis.com/v0/b/buffet2gether.appspot.com/o/notificationAndTable_test%2FLetEat.png?alt=media&token=f1a2da80-ead5-4666-adbc-b4c35f2b3497',
              width: 100,
              height:100)
        ],
      ),
    );

    List<bool> interestTable = [
      infoFromTable?.fashion,
      infoFromTable?.sport,
      infoFromTable?.technology,
      infoFromTable?.politics,
      infoFromTable?.entertainment,
      infoFromTable?.book,
      infoFromTable?.pet
    ];

    /// แสดง interest ตามที่เลือกจากหน้า edit interesting table
    final interestList = Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: 50,
        child: StreamBuilder<InfoInTable>(
            stream: DatabaseService(numberTable:mytable?.numberTable,resID: mytable?.resID).infoInTable,
            builder: (context, snapshot)
            {
              if (snapshot.hasData)
              {
                return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    /// myTable มาจาก table model จะมี list bool interest อยู่
                    itemCount: interestTable?.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                      if (interestTable[index]) ///ถ้าถูกเลือกขึ้นสีส้ม
                      {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.5),
                          child: Icon(
                              myTable.interestingIconUrl[index],
                              color: Colors.deepOrange
                          ),
                        );
                      }
                      return Padding( ///ไม่เลือกขึ้นเเทา
                        padding: const EdgeInsets.symmetric(horizontal: 8.5),
                        child: Icon(
                          myTable.interestingIconUrl[index],
                          color: Colors.grey,
                        ),
                      );
                    });
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

    final info = Container(
        margin: EdgeInsets.all(10),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(10),
            color: Colors.white,
            boxShadow:
            [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0,2),
                blurRadius: 3,
              )
            ]
        ),
        child: Column(
          children: <Widget>[
            Text(
              (infoFromTable?.number != null)?'No.'+infoFromTable?.number:'',
              style: TextStyle(
                  fontFamily: 'Opun',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow[700]
              ),
            ),
            Text(
              ((infoFromTable?.name1 != null)&&(infoFromTable?.name2 != null))?infoFromTable?.name1+' '+infoFromTable?.name2:'',
              style: TextStyle(
                  fontFamily: 'Opun',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange
              ),
            ),
            Image.network(
                infoFromTable?.imageUrl ?? 'https://firebasestorage.googleapis.com/v0/b/buffet2gether.appspot.com/o/profile_pictures%2Fdefault.png?alt=media&token=c91f2a65-0928-4eb1-a284-c07c0a8c1517',
                fit: BoxFit.contain,
                width: 250,
                height: 120
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.location_on,size: 25,color: Colors.amber,),
                Expanded(
                  child: Text(
                    infoFromTable?.location ?? ' ',
                    style: TextStyle(
                      fontFamily: 'Opun',
                      color: Colors.grey,
                      fontSize: 13,
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
                Icon(Icons.access_time,size: 25,color: Colors.amber),
                Text(
                  infoFromTable?.time ?? ' ',
                  style: TextStyle(
                    fontFamily: 'Opun',
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        )
    );

    final properties = Container(
        height: 80,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0,4),
                blurRadius: 5,
              )
            ]
        ),
        child: StreamBuilder<InfoInTable>(
            stream: DatabaseService(numberTable:mytable?.numberTable,resID: mytable?.resID).infoInTable,
            builder: (context, snapshot)
            {
              if (snapshot.hasData)
              {
                int getGender()
                {
                  int index = 0;
                  for (var item in genderList)
                  {
                    if (infoFromTable.gender  == item.genderName)
                    {
                      return index;
                    }
                    index += 1;
                  }
                }
                return FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ///age
                      Text(
                        ///ค่าอายุเริ่ม - ค่าอายุจบ
                        '${infoFromTable?.ageStart.toString()} - ${infoFromTable?.ageEnd.toString()}',
                        style: TextStyle(
                          fontFamily: 'Opun',
                          color: Colors.deepOrange,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '|',
                        style:  TextStyle(
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
                              (infoFromTable?.people != null)?'${listMember?.length.toString()} / ${infoFromTable?.people.round().toString()}':' ',
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
                        style:  TextStyle(
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
                        style:  TextStyle(
                          fontFamily: 'Opun',
                          color: Colors.amberAccent,
                          fontSize: 25,
                        ),
                      ),
                      ///gender
                      Icon(
                        genderList[getGender()].genderIcon,
                        size: 23,
                        color: Colors.deepOrange,),
                    ],
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
            }
        )
    );

    final memberBar = ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: listMember?.length,
      itemBuilder: (BuildContext context,int index) {
        MemberBarListInTable member = listMember[index];
        String interesting(){
          List<bool> interest= [member.fashion, member.sport, member.technology, member.politics, member.entertainment, member.book, member.pet];
          String infomation = '';
          if(interest[0]){infomation += '#fashion';}
          if(interest[1]){infomation += '#sport';}
          if(interest[2]){infomation += '#technology';}
          if(interest[3]){infomation += '#politics';}
          if(interest[4]){infomation += '#entertainment';}
          if(interest[5]){infomation += '#book';}
          if(interest[6]){infomation += '#pet';}
          return infomation;
        }
        return  new Container(
            decoration: BoxDecoration(
                color:Colors.deepOrange[50]
            ),
            child:new ListTile(
              leading: Container(
                width: 55.0,
                height: 55.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new NetworkImage(member.imageUrl)
                    )

                ),
              ),
              title: Text(
                member.membername+' เข้าร่วมกลุ่มนี้แล้ว!',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Opun',
                  color: Colors.deepOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Age: '+member.age.toString()+' | '+member.gender,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Opun',
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    interesting(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Opun',
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            )

        );
      },
    );


    print(iAmMaster);
    final stackMatchCol = StreamBuilder<InfoInTable>(
        stream: DatabaseService(numberTable:mytable?.numberTable,resID: mytable?.resID).infoInTable,
        builder: (context, snapshot)
        {
          if (snapshot.hasData)
          {  if(user?.userId == userMaster?.userId)
          {
            iAmMaster = true;
          }
          return Stack(
              children: [
                SafeArea(
                    child: Column(
                        children: <Widget>[
                          Expanded(
                              child: ListView(
                                  padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                                  children: <Widget>[
                                    info,
                                    Text(
                                      '  '+'Matching with',
                                      style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.deepOrange,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,

                                      ),
                                    ),
                                    properties,
                                    Text(
                                      ' Interesting',
                                      style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.deepOrange,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    interestList,
                                    Text(
                                      '  '+'Member',
                                      style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.deepOrange,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,

                                      ),
                                    ),
                                    Container(
                                      height: 200,
                                      width: screenSize.width,
                                      color: Color(0xFFF5F5F5),
                                      child: memberBar,
                                    )
                                  ]
                              )
                          )
                        ]
                    )
                ),
                Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:[
                          (iAmMaster)?buttonFinish:Container(),
                          ((iAmMaster==false)&&(userMaster?.max==false))?buttonLeaveGroup:Container(),//ไม่ใช่เจ้าของห้อง และกลุ่มเต็ม ปุ่มออกจากห้องจะหาย
                          ((iAmMaster==false)&&(userMaster?.max))?nongBuffet:Container(),
                        ]
                    )
                )
              ]
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
        }
    );
    return stackMatchCol;
  }
}