import 'package:buffet2gether_home/models/mytable_model.dart';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:buffet2gether_home/models/userFindGroup_model.dart';
import 'package:buffet2gether_home/models/userMaster_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buffet2gether_home/models/bar_model.dart';
import 'package:buffet2gether_home/models/infoInGroup_model.dart';
import 'package:buffet2gether_home/models/memberBarListInGroup_model.dart';
import 'package:buffet2gether_home/models/infoInTable_model.dart';
import 'package:buffet2gether_home/models/memberBarListInTable_model.dart';
import 'package:buffet2gether_home/models/rec_model.dart';
import 'package:buffet2gether_home/models/more_model.dart';
import 'package:buffet2gether_home/models/tableInfo.dart';
import 'package:buffet2gether_home/models/promotion_model.dart';
import 'package:buffet2gether_home/models/history_model.dart';

class DatabaseService {
  final String uid;
  final String numberGroup;
  final String numberTable;
  final String resID;
  final String userID;

  DatabaseService(
      {this.uid, this.numberGroup, this.numberTable, this.resID, this.userID});

  //----------------------------- Restaurants -----------------------------------------------------------
  final CollectionReference recInResCollection =
  Firestore.instance.collection('Restaurants/recommend/recList');
  final CollectionReference moreInResCollection =
  Firestore.instance.collection('Restaurants/more/moreList');
  final CollectionReference GroupsCollection =
  Firestore.instance.collection('Groups');
  final CollectionReference promotionCollection =
  Firestore.instance.collection('Restaurants/promotion/promotionPic');
  final CollectionReference historyCollection =
  Firestore.instance.collection('History');

  ///ดึงข้อมูลร้านใน history
  History _historyFromSnapshot(DocumentSnapshot snapshot) {
    return History(
      resID: snapshot.data['resID'],
      image: snapshot.data['image'],
      name1: snapshot.data['name1'],
      name2: snapshot.data['name2'],
      location: snapshot.data['location'],
      time: snapshot.data['time'],
      ageStart: snapshot.data['ageStart'],
      ageEnd: snapshot.data['ageEnd'],
      num: snapshot.data['num'],
      dueTime: snapshot.data['dueTime'].toString(),
      gender: snapshot.data['gender'],
      fashion: snapshot.data['fashion'] ?? false,
      sport: snapshot.data['sport'] ?? false,
      technology: snapshot.data['technology'] ?? false,
      politics: snapshot.data['politics'] ?? false,
      entertainment: snapshot.data['entertainment'] ?? false,
      book: snapshot.data['book'] ?? false,
      pet: snapshot.data['pet'] ?? false,
    );
  }

  Stream<History> get history {
    return historyCollection
        .document(userID)
        .snapshots()
        .map(_historyFromSnapshot);
  }

  ///ดึงข้อมูลร้านใน promotion
  List<Promo> _promotionPicFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Promo(
        resID: doc.data['resID'] ?? '',
        imageUrl: doc.data['imageUrl'] ?? '',
        name1: doc.data['name1'] ?? '',
        name2: doc.data['name2'] ?? '',
        location: doc.data['location'] ?? '',
        promotion: doc.data['promotion'] ?? '',
        promotionInfo: doc.data['promotionInfo'] ?? '',
        time: doc.data['time'] ?? '',
        proPic: doc.data['proPic'] ?? '',
      );
    }).toList();
  }

  Stream<List<Promo>> get promotionPic {
    return promotionCollection.snapshots().map(_promotionPicFromSnapshot);
  }

  TableInfo _getGroupInterest(DocumentSnapshot snapshot) {
    //ดึงความชอบจากร้านที่สร้างเอาไว้

    return TableInfo(
        fashion: snapshot.data['fashion'] ?? false,
        sport: snapshot.data['sport'] ?? false,
        technology: snapshot.data['technology'] ?? false,
        politics: snapshot.data['politics'] ?? false,
        entertainment: snapshot.data['entertainment'] ?? false,
        book: snapshot.data['book'] ?? false,
        pet: snapshot.data['pet'] ?? false,
        ageStart: snapshot.data['ageStart'] ?? 0,
        ageEnd: snapshot.data['ageEnd'] ?? 0,
        gender: snapshot.data['gender'] ?? '');
  }

  Stream<TableInfo> get groupInterest {
    return GroupsCollection.document(resID)
        .collection('GroupsInRes')
        .document(numberTable)
        .collection('info')
        .document('info')
        .snapshots()
        .map(_getGroupInterest);
  }

  ///ดึงข้อมูลร้านใน Recommend
  List<Recom> _recListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Recom(
        resID: doc.data['resID'] ?? '',
        imageUrl: doc.data['imageUrl'] ?? '',
        name1: doc.data['name1'] ?? '',
        name2: doc.data['name2'] ?? '',
        location: doc.data['location'] ?? '',
        promotion: doc.data['promotion'] ?? '',
        promotionInfo: doc.data['promotionInfo'] ?? '',
        time: doc.data['time'] ?? '',
      );
    }).toList();
  }

  Stream<List<Recom>> get recInRes {
    return recInResCollection.snapshots().map(_recListFromSnapshot);
  }

  ///ดึงข้อมูลร้านใน More
  List<More> _moreListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return More(
        resID: doc.data['resID'] ?? '',
        imageUrl: doc.data['imageUrl'] ?? '',
        name1: doc.data['name1'] ?? '',
        name2: doc.data['name2'] ?? '',
        location: doc.data['location'] ?? '',
        promotion: doc.data['promotion'] ?? '',
        promotionInfo: doc.data['promotionInfo'] ?? '',
        time: doc.data['time'] ?? '',
      );
    }).toList();
  }

  Stream<List<More>> get moreInRes {
    return moreInResCollection.snapshots().map(_moreListFromSnapshot);
  }

  ///เพิ่มข้อมูลกลุ่มที่สร้างใน Groups/ชื่อร้าน(resID)/GroupsInRes/... ใน 1 ร้านมีหลายกลุ่ม
  Future updateGroups(
      String resID,
      String name1,
      String name2,
      String image,
      String location,
      String time,
      int ageStart,
      int ageEnd,
      double num,
      DateTime dueTime,
      String gender,
      bool fashion,
      bool sport,
      bool technology,
      bool politics,
      bool entertainment,
      bool book,
      bool pet,
      String numberTable) async {
    return await GroupsCollection.document(resID)
        .collection('GroupsInRes')
        .document(numberTable)
        .collection('info')
        .document('info')
        .setData({
      'resID': resID,

      /// ข้อมูลร้าน
      'name1': name1,
      'name2': name2,
      'image': image,
      'location': location,
      'time': time,
      'ageStart': ageStart,

      /// คุณสมบัติ
      'ageEnd': ageEnd,
      'num': num,
      'dueTime': dueTime,
      'gender': gender,
      'fashion': fashion,

      /// ความชอบของกลุ่ม
      'sport': sport,
      'technology': technology,
      'politics': politics,
      'entertainment': entertainment,
      'book': book,
      'pet': pet,
    });
  }

  ///เพิ่มข้อมูลคนหากลุ่มใน Groups/ชื่อร้าน(resID)/UserFindGroup/... ใน 1 ร้านมีคนหากลุ่มมหลายคน
  Future updateUserFindGroup(
      String resID,
      String name1,
      String name2,
      String image,
      String location,
      String time,
      String userName,
      String profilePic,
      String gender,
      int age,
      bool fashion,
      bool sport,
      bool technology,
      bool politics,
      bool entertainment,
      bool book,
      bool pet,
      String userID) async {
    return await GroupsCollection.document(resID)
        .collection('UserFindGroup')
        .document(userID)
        .setData({
      'resID': resID,

      /// ข้อมูลร้าน
      'name1': name1,
      'name2': name2,
      'image': image,
      'location': location,
      'time': time,
      'userName': userName,

      /// ข้อมูล user
      'profilePic': profilePic,
      'gender': gender,
      'age': age,
      'fashion': fashion,

      /// ความชอบของ user
      'sport': sport,
      'technology': technology,
      'politics': politics,
      'entertainment': entertainment,
      'book': book,
      'pet': pet,
      'userID': userID,
    });
  }

  ///เพิ่มข้อมูล
  Future updateFinish(
      String resID,
      String name1,
      String name2,
      String image,
      String location,
      String time,
      int ageStart,
      int ageEnd,
      double num,
      DateTime dueTime,
      String gender,
      bool fashion,
      bool sport,
      bool technology,
      bool politics,
      bool entertainment,
      bool book,
      bool pet,
      String numberTable,
      String itemUserID) async {
    return await historyCollection.document(itemUserID).setData({
      'resID': resID,

      /// ข้อมูลร้าน
      'name1': name1,
      'name2': name2,
      'image': image,
      'location': location,
      'time': time,

      /// คุณสมบัติ
      'ageStart': ageStart,
      'ageEnd': ageEnd,
      'num': num,
      'dueTime': dueTime,
      'gender': gender,

      /// ความชอบของกลุ่ม
      'fashion': fashion,
      'sport': sport,
      'technology': technology,
      'politics': politics,
      'entertainment': entertainment,
      'book': book,
      'pet': pet,
      'itemUserID': itemUserID,
    });
  }

  //----------------------------- NOTIFACATION -----------------------------------------------------------
  /// set path ของ Collection ใน firebase ที่จะเอามาใช้
  final CollectionReference userCollection =
  Firestore.instance.collection('Users');

  /// ฟังก์ชันเอาไว้เพิ่ม document ใน firebase ส่วนที่เป็น notification (เพิ่มแถบแจ้งเตือน)
  Future updateNotifData(
      String resID,
      String imageUrl,
      String membername,
      String number,
      bool group,
      String gender,
      int age,
      bool fashion,
      bool sport,
      bool technology,
      bool politics,
      bool entertainment,
      bool book,
      bool pet,
      String userID, /////////// เจ้าของข้อมูลก่อนหน้านี้
      String pathID, /////////// userID ของ คนที่ต้องการให้เห็นแจ้งเตือนนี้
      ) async {
    return await userCollection
        .document(pathID)
        .collection('notification')
        .document(userID)
        .setData({
      'imageUrl': imageUrl,

      ///รูปโปรไฟล์ user (ถ้าเป็น groupbar จะเป็นของหัวหน้ากลุ่ม)
      'membername': membername,

      ///ชื่อ user (ถ้าเป็น groupbar จะเป็นของหัวหน้ากลุ่ม)
      'number': number,

      ///นำไปใช้เฉพาะ groupbar เป็นเลขของกลุ่ม
      'group': group,
      'gender': gender,
      'age': age,
      'fashion': fashion,
      'sport': sport,
      'technology': technology,
      'politics': politics,
      'entertainment': entertainment,
      'book': book,
      'pet': pet,
      'resID': resID,
      'userID': userID //////////// userID ข้อเจ้าของข้อมูลใน bar นี้
    });
  }

  ////////////////////////// ฟังก์ชันเอาไว้เพิ่มส่วนที่เป็น Table ของเรา///////////////////////
  Future updateTableData(String resID, String number, String userID) async {
    return await userCollection
        .document(userID)
        .collection('table')
        .document('My table')
        .setData({
      'number': number,
      'resID': resID,
    });
  }

  ///////////// ฟังก์ชันเอาไว้เพิ่ม document ใน firebase ส่วนที่เป็น master ของแต่ละกลุ่ม//////////
  Future updateMasterData(
      String resID, String number, String userID, bool max) async {
    return await GroupsCollection.document(resID)
        .collection('GroupsInRes')
        .document(number)
        .setData({
      'userID': userID,
      'max': max,
    });
  }

  /////////////// ฟังก์ชันเอาไว้เพิ่ม document ใน firebase ส่วนที่รับ member เข้ากลุ่ม///////////////////////
  Future updateMemberInGroup(
      String resID,
      String imageUrl,
      String membername,
      String numberTable,
      String gender,
      int age,
      bool fashion,
      bool sport,
      bool technology,
      bool politics,
      bool entertainment,
      bool book,
      bool pet,
      String userID,
      ) async {
    return await GroupsCollection.document(resID)
        .collection('GroupsInRes')
        .document(numberTable)
        .collection('member')
        .document(userID)
        .setData({
      'imageUrl': imageUrl,
      'membername': membername,
      'gender': gender,
      'age': age,
      'fashion': fashion,
      'sport': sport,
      'technology': technology,
      'politics': politics,
      'entertainment': entertainment,
      'book': book,
      'pet': pet,
      'userID': userID
    });
  }

///////////////////////////////////ลบ แถบแจ้งเตือน //////////////////////////////
  void deleteNotifData(String documentID, String userID) {
    userCollection
        .document(userID)
        .collection('notification')
        .document(documentID)
        .delete();
  }

///////////////////////////////////ลบข้อมูลใน Group เมื่อกด finish //////////////////////////////
  void deleteGroupData(
      String resID, String numberTable, String userID, String documentInfo) {
    if (documentInfo != null) {
      GroupsCollection.document(resID)
          .collection('GroupsInRes')
          .document(numberTable)
          .delete();
      GroupsCollection.document(resID)
          .collection('GroupsInRes')
          .document(numberTable)
          .collection('info')
          .document(documentInfo)
          .delete();
    }
    GroupsCollection.document(resID)
        .collection('GroupsInRes')
        .document(numberTable)
        .collection('member')
        .document(userID)
        .delete();
  }

///////////////////////////////////ลบ User Find Group เมื่อผู้ใช้หากลุ่มได้แล้ว//////////////////////////////
  void deleteUserFindGroupData(String resID, String userID) {
    GroupsCollection.document(resID)
        .collection('UserFindGroup')
        .document(userID)
        .delete();
  }

  /////////////////////////////////// map User Find Group //////////////////////////////
  List<UserFindGroup> _userFindGroupFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserFindGroup(
          imageUrl: doc.data['profilePic'] ?? '',
          name: doc.data['userName'] ?? '',
          gender: doc.data['gender'] ?? '',
          age: doc.data['age'] ?? 0,
          fashion: doc.data['fashion'] ?? false,
          sport: doc.data['sport'] ?? false,
          technology: doc.data['technology'] ?? false,
          politics: doc.data['politics'] ?? false,
          entertainment: doc.data['entertainment'] ?? false,
          book: doc.data['book'] ?? false,
          pet: doc.data['pet'] ?? false,
          userID: doc.data['userID'] ?? '');
    }).toList();
  }

  Stream<List<UserFindGroup>> get userFindGroup {
    return GroupsCollection.document(resID)
        .collection('UserFindGroup')
        .snapshots()
        .map(_userFindGroupFromSnapshot);
  }

////////////////////////////////////map Master/////////////////////////////////////////
  List<UserMaster> _userMasterFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserMaster(userId: doc.data['userID'] ?? '', max: doc.data['max']);
    }).toList();
  }

  Stream<List<UserMaster>> get userMaster {
    return GroupsCollection.document(resID)
        .collection('GroupsInRes')
        .snapshots()
        .map(_userMasterFromSnapshot);
  }

////////////////////////////////////map Group Master Max ค่า max เป็น true คือกลุ่มเต็มแล้ว///////////////////////////
  UserMaster _userMasterMaxFromSnapshot(DocumentSnapshot snapshot) {
    return UserMaster(
        userId: snapshot.data['userID'] ?? '', max: snapshot.data['max']);
  }

  Stream<UserMaster> get userMasterMax {
    return GroupsCollection.document(resID)
        .collection('GroupsInRes')
        .document(numberTable)
        .snapshots()
        .map(_userMasterMaxFromSnapshot);
  }

  ////////////////////////// map แถบการแจ้งเตือนจาก document ใน Notification ทั้ง 2 แบบ ให้อยู่ใน list เดียวกัน
  List<Bar> _notificationListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((doc) {
      if (doc.data['group'] ?? false) {
        ///ถ้า group เป็น true จะสร้าง group bar
        return CreateGroupBar(
            imageUrl: doc.data['imageUrl'] ?? '',
            membername: doc.data['membername'] ?? '',
            number: doc.data['number'] ?? '',
            gender: doc.data['gender'] ?? '',
            age: doc.data['age'] ?? 0,
            fashion: doc.data['fashion'] ?? false,
            sport: doc.data['sport'] ?? false,
            technology: doc.data['technology'] ?? false,
            politics: doc.data['politics'] ?? false,
            entertainment: doc.data['entertainment'] ?? false,
            book: doc.data['book'] ?? false,
            pet: doc.data['pet'] ?? false,
            documentID: doc.documentID,
            resID: doc.data['resID'] ?? '',
            userID: doc.data['userID'] ?? '');
      } else {
        ///ถ้า group เป็น false จะสร้าง notif bar
        return CreateNotifBar(
            imageUrl: doc.data['imageUrl'] ?? '',
            membername: doc.data['membername'] ?? '',
            gender: doc.data['gender'] ?? '',
            age: doc.data['age'] ?? 0,
            fashion: doc.data['fashion'] ?? false,
            sport: doc.data['sport'] ?? false,
            technology: doc.data['technology'] ?? false,
            politics: doc.data['politics'] ?? false,
            entertainment: doc.data['entertainment'] ?? false,
            book: doc.data['book'] ?? false,
            pet: doc.data['pet'] ?? false,
            documentID: doc.documentID,
            userID: doc.data['userID'] ?? '');
      }
    })
        .toSet()
        .toList();
  }

  Stream<List<Bar>> get notifications {
    return userCollection
        .document(userID)
        .collection('notification')
        .snapshots()
        .map(_notificationListFromSnapshot);
  }

  //////////////////////////// map สมาชิกที่อยู่ในโต๊ะ ในแถบรายละเอียดกลุ่มเมื่อกดแถบ group bar///////////
  List<MemberBarListInGroup> _memberInGroupFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return MemberBarListInGroup(
        imageUrl: doc.data['imageUrl'] ?? '',
        membername: doc.data['membername'] ?? '',
        gender: doc.data['gender'] ?? '',
        age: doc.data['age'] ?? 0,
        fashion: doc.data['fashion'] ?? false,
        sport: doc.data['sport'] ?? false,
        technology: doc.data['technology'] ?? false,
        politics: doc.data['politics'] ?? false,
        entertainment: doc.data['entertainment'] ?? false,
        book: doc.data['book'] ?? false,
        pet: doc.data['pet'] ?? false,
        userID: doc.data['userID'] ?? '',
      );
    }).toList();
  }

  Stream<List<MemberBarListInGroup>> get memberInGroup {
    return GroupsCollection.document(resID)
        .collection('GroupsInRes')
        .document(numberGroup)
        .collection('member')
        .snapshots()
        .map(_memberInGroupFromSnapshot);
  }

///////////////// map ข้อมูลรายละเอียดร้านอาหาร ในแถบรายละเอียดกลุ่มเมื่อกดแถบ group bar//////////////////
  InfoInGroup _infoInGroupFromSnapshot(DocumentSnapshot snapshot) {
    return InfoInGroup(
      number: numberGroup,
      name1: snapshot.data['name1'],
      name2: snapshot.data['name2'],
      location: snapshot.data['location'],
      time: snapshot.data['time'],
      imageUrl: snapshot.data['image'],
      ageStart: snapshot.data['ageStart'],
      ageEnd: snapshot.data['ageEnd'],
      people: snapshot.data['num'],
      dueTime: snapshot.data['dueTime'].toString(),
      gender: snapshot.data['gender'],
      fashion: snapshot.data['fashion'] ?? false,
      sport: snapshot.data['sport'] ?? false,
      technology: snapshot.data['technology'] ?? false,
      politics: snapshot.data['politics'] ?? false,
      entertainment: snapshot.data['entertainment'] ?? false,
      book: snapshot.data['books'] ?? false,
      pet: snapshot.data['pet'] ?? false,
    );
  }

  Stream<InfoInGroup> get infoInGroup {
    return GroupsCollection.document(resID)
        .collection('GroupsInRes')
        .document(numberGroup)
        .collection('info')
        .document('info')
        .snapshots()
        .map(_infoInGroupFromSnapshot);
  }

  /////////////////////////////// map สมาชิกที่อยู่ในโต๊ะ ในหน้า Table//////////////////////////////
  List<MemberBarListInTable> _memberInTableFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return MemberBarListInTable(
        imageUrl: doc.data['imageUrl'] ?? '',
        membername: doc.data['membername'] ?? '',
        gender: doc.data['gender'] ?? '',
        age: doc.data['age'] ?? 0,
        fashion: doc.data['fashion'] ?? false,
        sport: doc.data['sport'] ?? false,
        technology: doc.data['technology'] ?? false,
        politics: doc.data['politics'] ?? false,
        entertainment: doc.data['entertainment'] ?? false,
        book: doc.data['book'] ?? false,
        pet: doc.data['pet'] ?? false,
        userID: doc.data['userID'] ?? '',
      );
    }).toList();
  }

  Stream<List<MemberBarListInTable>> get memberInTable {
    return GroupsCollection.document(resID)
        .collection('GroupsInRes')
        .document(numberTable)
        .collection('member')
        .snapshots()
        .map(_memberInTableFromSnapshot);
  }

///////////////////////map ข้อมูลรายละเอียดร้านอาหาร ในหน้า Table//////////////////////////////////
  InfoInTable _infoInTableFromSnapshot(DocumentSnapshot snapshot) {
    return InfoInTable(
      number: numberTable,
      name1: snapshot.data['name1'],
      name2: snapshot.data['name2'],
      location: snapshot.data['location'],
      time: snapshot.data['time'],
      imageUrl: snapshot.data['image'],
      ageStart: snapshot.data['ageStart'],
      ageEnd: snapshot.data['ageEnd'],
      people: snapshot.data['num'],
      dueTime: snapshot.data['dueTime'].toString(),
      gender: snapshot.data['gender'],
      fashion: snapshot.data['fashion'] ?? false,
      sport: snapshot.data['sport'] ?? false,
      technology: snapshot.data['technology'] ?? false,
      politics: snapshot.data['politics'] ?? false,
      entertainment: snapshot.data['entertainment'] ?? false,
      book: snapshot.data['book'] ?? false,
      pet: snapshot.data['pet'] ?? false,
    );
  }

  Stream<InfoInTable> get infoInTable {
    return GroupsCollection.document(resID)
        .collection('GroupsInRes')
        .document(numberTable)
        .collection('info')
        .document('info')
        .snapshots()
        .map(_infoInTableFromSnapshot);
  }

  /////////////////////////// map ข้อมูลรายละเอียดร้านอาหาร ในหน้า Table///////////////////////////
  Mytable _myTableFromSnapshot(DocumentSnapshot snapshot) {
    return Mytable(
      resID: snapshot.data['resID'],
      numberTable: snapshot.data['number'],
    );
  }

  Stream<Mytable> get mytable {
    return userCollection
        .document(userID)
        .collection('table')
        .document('My table')
        .snapshots()
        .map(_myTableFromSnapshot);
  }

  //------------------------------- USER -----------------------------------------------------------
// collection reference
  final CollectionReference tableCollection =
  Firestore.instance.collection('Groups');

  Future<void> updateUserData(
      String profilePicture,
      String name,
      String gender,
      DateTime dateOfBirth,
      String bio,
      bool fashion,
      bool sport,
      bool technology,
      bool politics,
      bool entertainment,
      bool book,
      bool pet,
      bool isOwner) async {
    return await userCollection.document(uid).setData({
      'ProfilePicture': profilePicture,
      'Name': name,
      'Gender': gender,
      'BirthDate': dateOfBirth,
      'Bio': bio,
      'Fashion': fashion,
      'Sport': sport,
      'Technology': technology,
      'Politics': politics,
      'Entertainment': entertainment,
      'Book': book,
      'Pet': pet,
      'isOwner': isOwner,
      'UserID': userCollection.document(uid).documentID,
    });
  }

  Future<void> updateUserDataInteresting(
      bool fashion,
      bool sport,
      bool technology,
      bool politics,
      bool entertainment,
      bool book,
      bool pet,
      ) async {
    return await userCollection.document(uid).updateData({
      'Fashion': fashion,
      'Sport': sport,
      'Technology': technology,
      'Politics': politics,
      'Entertainment': entertainment,
      'Book': book,
      'Pet': pet,
    });
  }

  Future<void> updateUserDataDetail(
      String name,
      String gender,
      DateTime dateOfBirth,
      String bio,
      ) async {
    return await userCollection.document(uid).updateData({
      'Name': name,
      'Gender': gender,
      'BirthDate': dateOfBirth,
      'Bio': bio,
    });
  }

//new func
  Future<void> updateFirstTimeUserData(
      String profilePic,
      String name,
      String gender,
      DateTime dateOfBirth,
      ) async {
    return await userCollection.document(uid).updateData({
      'Name': name,
      'Gender': gender,
      'BirthDate': dateOfBirth,
      'ProfilePicture': profilePic,
    });
  }

  Future<void> updateFirstTimeUserHistory(
      String profilePic,
      String name,
      String gender,
      DateTime dateOfBirth,
      ) async {
    return await userCollection.document(uid).updateData({
      'Name': name,
      'Gender': gender,
      'BirthDate': dateOfBirth,
      'ProfilePicture': profilePic,
    });
  }

  Future<void> updateUserProfilePicture(
      String url,
      ) async {
    return await userCollection.document(uid).updateData({
      'ProfilePicture': url,
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      userId: uid,
      profilePicture: snapshot.data['ProfilePicture'],
      name: snapshot.data['Name'],
      gender: snapshot.data['Gender'],
      dateofBirth: snapshot.data['BirthDate'].toDate(),
      bio: snapshot.data['Bio'],
      fashion: snapshot.data['Fashion'],
      sport: snapshot.data['Sport'],
      technology: snapshot.data['Technology'],
      politics: snapshot.data['Politics'],
      entertainment: snapshot.data['Entertainment'],
      book: snapshot.data['Book'],
      pet: snapshot.data['Pet'],
      isOwner: snapshot.data['isOwner'],
    );
  }

  // get brews stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  // user list from snapshot
  /*List<UserInformation> _userListFromSnapshot(QuerySnapshot snapshot)
  {
    return snapshot.documents.map((doc){
      return UserInformation(
        name: doc.data['Name'] ?? '',
        gender: doc.data['Gender'] ?? '',
        userID : doc.data['UserID'] ?? '',
        sport: doc.data['Sport'] ?? '',
        pet: doc.data['Pet'] ?? '',
        technology: doc.data['Technology'] ?? '',
        political: doc.data['Polotical'] ?? '',
        beauty: doc.data['Beauty'] ?? '',
        entertainment: doc.data['Entertainment'] ?? ''
      );
    }).toList();
  }
  // get brews stream
  Stream<List<UserInformation>> get users
  {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }*/

  Future<void> creatTable(
      String master, String member1, String member2, String member3) async {
    return await userCollection.document(uid).setData({
      'Master': userCollection.document(uid).documentID,
      'Member1': member1,
      'Member2': member2,
      'Member3': member3,
    });
  }
}