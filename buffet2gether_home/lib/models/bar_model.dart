import 'package:buffet2gether_home/models/infoInGroup_model.dart';
import 'package:buffet2gether_home/pages/notification/inviteTogroup_page.dart';
import 'package:buffet2gether_home/models/memberBarListInGroup_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buffet2gether_home/services/database.dart';

/// คลาสรวม แถบแจ้งเตือนทั้ง 2 แบบ
abstract class Bar {

  Widget buildNotifBar(BuildContext context);
  Widget buildGroupBar(BuildContext context);
  String getdocumentID() ;
  String getResID();
  String getImageUrl() ;
  String getMemberName() ;
  String getNumber() ;
  String getGender();
  int getAge();
  bool getSport();
  bool getPet();
  bool getTechnology();
  bool getPolitics();
  bool getFashion();
  bool getEntertainment();
  bool getBook();
  String getUserID();
}
/// สร้าง แถบแจ้งเตือนที่มีคนมา match กับกลุ่มที่เราสร้าง
class CreateNotifBar implements Bar{
  final String imageUrl;
  final String membername;
  final String documentID;
  final String gender;
  final int age;
  final bool sport;
  final bool pet;
  final bool technology;
  final bool politics;
  final bool fashion;
  final bool entertainment;
  final bool book;
  final String userID;

  CreateNotifBar({this.gender, this.age,this.fashion, this.sport, this.technology, this.politics, this.entertainment, this.book, this.pet, this.imageUrl,this.membername,this.documentID,this.userID});

  String interesting(){
    List<bool> interest= [fashion,sport,technology,politics,entertainment,book,pet];
    String infomation = '';
    if(interest[0]){
      infomation += '#fashion';
    }
    if(interest[1]){
      infomation += '#sport';
    }
    if(interest[2]){
      infomation += '#technology';
    }
    if(interest[3]){
      infomation += '#politics';
    }
    if(interest[4]){
      infomation += '#entertainment';
    }
    if(interest[5]){
      infomation += '#book';
    }
    if(interest[6]){
      infomation += '#pet';
    }
    return infomation;
  }

  Widget buildNotifBar(BuildContext context){
    final notifBar = new ListTile( /////เอาไฟล์รูปที่เป็นสี่เหลี่ยม มาใส่ในContainerให้เป็นวงกลม
      leading: Container(
        width: 55.0,
        height: 55.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.cover,
                image: new NetworkImage(imageUrl)
            )

        ),
      ),
      title: Text(
        membername+' อยากไปกินบุฟเฟ่ต์กับคุณ!',
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
            'Age: '+age.toString()+' | '+gender, // บรรทัดกลาง อายุ เพศ
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
            interesting(),    //บรรทัดที่ 3 ความชอบ
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
    );

    return
      notifBar;
  }

  Widget buildGroupBar(BuildContext context) => null;



  @override
  String getNumber() {

    return null;
  }

  @override
  String getImageUrl() {

    return imageUrl;
  }

  @override
  String getMemberName() {

    return membername;
  }

  @override
  int getAge() {
    return age;
  }

  @override
  bool getFashion() {
    return fashion;
  }

  @override
  bool getEntertainment() {
    return entertainment;
  }

  @override
  String getGender() {
    return gender;
  }

  @override
  bool getPet() {
    return pet;
  }

  @override
  bool getPolitics() {
    return politics;
  }

  @override
  bool getSport() {
    return sport;
  }

  @override
  bool getTechnology() {
    return technology;
  }

  @override
  bool getBook() {
    return book;
  }

  @override
  String getResID() {

    return null;
  }

  @override
  String getUserID() {

    return userID;
  }

  @override
  String getdocumentID() {

    return documentID;
  }


}
/// สร้าง แถบแจ้งเตือนกลุ่มที่มาเชิญเราไปเข้าร่วม
class CreateGroupBar implements Bar{
  final String imageUrl;
  final String membername;
  final String number;
  final String documentID;
  final String gender;
  final int age;
  final bool sport;
  final bool pet;
  final bool technology;
  final bool politics;
  final bool fashion;
  final bool entertainment;
  final String resID;
  final bool book;
  final String userID;

  CreateGroupBar({this.gender, this.age, this.fashion, this.sport, this.technology, this.politics, this.entertainment, this.book, this.pet,this.imageUrl,this.membername,this.number,this.documentID,this.resID,this.userID});

  String interesting(){
    List<bool> interest= [fashion,sport,technology,politics,entertainment,book,pet];
    String infomation = '';
    if(interest[0]){
      infomation += '#fashion';
    }
    if(interest[01]){
      infomation += '#sport';
    }
    if(interest[2]){
      infomation += '#technology';
    }
    if(interest[3]){
      infomation += '#politics';
    }
    if(interest[4]){
      infomation += '#entertainment';
    }
    if(interest[5]){
      infomation += '#book';
    }
    if(interest[6]){
      infomation += '#pet';
    }
    return infomation;
  }
  @override
  String getdocumentID() {
    return documentID;
  }
  Widget buildGroupBar(BuildContext context){
    final groupBar =  new InkWell(
      onTap: (){
        return showDialog(
          context: context,
          builder: (context) {
            return StreamProvider<List<MemberBarListInGroup>>.value(
              value: DatabaseService(numberGroup: number,resID: resID).memberInGroup,
              child: StreamProvider<InfoInGroup>.value(
                  value: DatabaseService(numberGroup: number,resID: resID).infoInGroup,
                  child: Group1()     ///กดที่แถบแล้วให้ไปที่หน้า InviteToGroup
              ),
            );
          },
        );
      },
      child: new ListTile(
        leading: Container(
          width: 55.0,
          height: 55.0,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: new NetworkImage(imageUrl)
              )
          ),
        ),
        title: Text(
          membername+' เชิญคุณเข้าร่วมกลุ่มบุฟเฟต์!',
          textAlign: TextAlign.start,
          style: TextStyle(
              fontFamily: 'Opun',
              color: Colors.deepOrange,
              fontSize: 14,
              fontWeight: FontWeight.normal
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Age: '+age.toString()+' | '+gender,
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
        trailing: Text(
          'No.'+number,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: 'Opun',
            color: Colors.deepOrange,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );

    return
      groupBar;
  }
  Widget buildNotifBar(BuildContext context) => null;


  @override
  String getNumber() {

    return number;
  }

  @override
  String getImageUrl() {
    return null;
  }

  @override
  String getMemberName() {
    return null;
  }

  @override
  int getAge() {
    return null;
  }

  @override
  bool getFashion() {
    return null;
  }

  @override
  bool getEntertainment() {
    return null;
  }

  @override
  String getGender() {
    return null;
  }

  @override
  bool getPet() {
    return null;
  }

  @override
  bool getPolitics() {
    return null;
  }

  @override
  bool getSport() {
    return null;
  }

  @override
  bool getTechnology() {
    return null;
  }

  @override
  bool getBook() {
    return null;
  }

  @override
  String getResID() {

    return resID;
  }

  @override
  String getUserID() {

    return userID;
  }
}