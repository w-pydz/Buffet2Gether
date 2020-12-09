import 'dart:ui';
import 'package:buffet2gether_home/models/history_model.dart';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:buffet2gether_home/pages/profile/profile_setting_screen.dart';
import 'package:buffet2gether_home/services/database.dart';
import 'package:buffet2gether_home/shared/fade_indexed_stack.dart';
import 'package:buffet2gether_home/shared/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:buffet2gether_home/services/auth.dart';
import 'package:buffet2gether_home/pages/profile/history_page.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final maleIcon = FontAwesomeIcons.male;
  final femaleIcon = FontAwesomeIcons.female;
  int isSelecting = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //var currentUser = FirebaseAuth.instance.currentUser();
    //final history = Provider.of<History>(context);

    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        leading: new Container(),
        title: Text(
          'Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Opun',
            color: Colors.deepOrange,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xfff5f5f5),
      ),
      body: SafeArea(
          child: StreamBuilder<UserData>(
              stream: DatabaseService(uid: user?.userId).userData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData userData = snapshot.data;
                  //print(userData.userId);
                  return ListView(
                    physics: BouncingScrollPhysics(),
                    padding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                    children: <Widget>[
                      SizedBox(height: 25),
                      Column(
                        children: <Widget>[
                          Container(
                            height: 220,
                            width: 350,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: <Widget>[
                                Positioned(
                                  bottom: 10,
                                  child: Container(
                                    width: 340,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 2),
                                          blurRadius: 5.0,
                                          spreadRadius: 2.0,
                                        ),
                                      ],
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      //color: Colors.grey[300],
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              //print('Tag Pressed');
                                              setState(() {
                                                isSelecting = 0;
                                              });
                                            },
                                            child: Container(
                                                width: 169.5,
                                                height: 110,
                                                padding:
                                                EdgeInsets.only(top: 70),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                    topLeft:
                                                    Radius.circular(10),
                                                    bottomLeft:
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Tag',
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontFamily: 'Opun',
                                                      fontSize: 15,
                                                      letterSpacing: 2,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                )),
                                          ),
                                          SizedBox(width: 1),
                                          InkWell(
                                            onTap: () {
                                              //print('History Pressed');
                                              setState(() {
                                                isSelecting = 1;
                                              });
                                            },
                                            child: Container(
                                                width: 169.5,
                                                height: 110,
                                                padding:
                                                EdgeInsets.only(top: 70),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                    topRight:
                                                    Radius.circular(10),
                                                    bottomRight:
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Text(
                                                  'History',
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontFamily: 'Opun',
                                                      fontSize: 15,
                                                      letterSpacing: 2,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                )),
                                          ),
                                        ]),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: 330,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.deepOrange,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(0, 2),
                                            blurRadius: 5.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Container(
                                              width: 102,
                                              height: 102,
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (_) {
                                                            return new ViewProfilePictureScreen(
                                                                userData
                                                                    .profilePicture);
                                                          }));
                                                },
                                                child: Hero(
                                                  tag: 'profile',
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                    userData.profilePicture,
                                                    imageBuilder: (context,
                                                        imageProvider) =>
                                                        Container(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            image: DecorationImage(
                                                                image:
                                                                imageProvider,
                                                                fit: BoxFit.cover),
                                                          ),
                                                        ),
                                                    placeholder: (context,
                                                        url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                        Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    userData.name,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'Opun',
                                                        color: Colors.white,
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        letterSpacing: 1),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        (DateTime.now()
                                                            .difference(
                                                            userData.dateofBirth)
                                                            .inDays /
                                                            365)
                                                            .floor()
                                                            .toString() +
                                                            ' | ',
                                                        style: TextStyle(
                                                          fontFamily: 'Opun',
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          letterSpacing: 1,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Icon(
                                                        userData.gender ==
                                                            'Male'
                                                            ? FontAwesomeIcons
                                                            .mars
                                                            : FontAwesomeIcons
                                                            .venus,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              padding: EdgeInsets.only(
                                                  bottom: 100, left: 5),
                                              icon: Icon(
                                                FontAwesomeIcons.cog,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                //print('Settings pressed');
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                        StreamProvider<
                                                            User>.value(
                                                            value:
                                                            AuthService()
                                                                .user,
                                                            child:
                                                            ProfileSettingScreen())));
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Center(
                          child: Text(
                            '\' ' + userData.bio + ' \'',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontFamily: 'Opun',
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeIndexedStack(
                          index: isSelecting,
                          duration: Duration(milliseconds: 400),
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                ////////////////////////////////////////////////////Tag
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'You are interesting in : ',
                                    style: TextStyle(
                                      fontFamily: 'Opun',
                                      color: Colors.black45,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        //height: 180,
                                        child: ListView.builder(
                                          physics:
                                          NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: 7,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (index == 0 &&
                                                userData.fashion == true) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 1),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 1),
                                                      blurRadius: 5.0,
                                                      spreadRadius: 1.0,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                child: ListTile(
                                                  dense: true,
                                                  leading: Icon(
                                                    FontAwesomeIcons
                                                        .hatCowboySide,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  title: Text(
                                                    'Fashion',
                                                    //overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                      fontFamily: 'Opun',
                                                      color: Colors.deepOrange,
                                                      fontSize: 18.0,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            if (index == 1 &&
                                                userData.sport == true) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 1),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 1),
                                                      blurRadius: 5.0,
                                                      spreadRadius: 1.0,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                child: ListTile(
                                                  dense: true,
                                                  leading: Icon(
                                                    FontAwesomeIcons
                                                        .footballBall,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  title: Text(
                                                    'Sport',
                                                    //overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                      fontFamily: 'Opun',
                                                      color: Colors.deepOrange,
                                                      fontSize: 18.0,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            if (index == 2 &&
                                                userData.technology == true) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 1),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 1),
                                                      blurRadius: 5.0,
                                                      spreadRadius: 1.0,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                child: ListTile(
                                                  dense: true,
                                                  leading: Icon(
                                                    FontAwesomeIcons.laptop,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  title: Text(
                                                    'Technology',
                                                    //overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                      fontFamily: 'Opun',
                                                      color: Colors.deepOrange,
                                                      fontSize: 18.0,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            if (index == 3 &&
                                                userData.politics == true) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 1),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 1),
                                                      blurRadius: 5.0,
                                                      spreadRadius: 1.0,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                child: ListTile(
                                                  dense: true,
                                                  leading: Icon(
                                                    FontAwesomeIcons
                                                        .balanceScale,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  title: Text(
                                                    'Politics',
                                                    //overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                      fontFamily: 'Opun',
                                                      color: Colors.deepOrange,
                                                      fontSize: 18.0,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            if (index == 4 &&
                                                userData.entertainment ==
                                                    true) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 1),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 1),
                                                      blurRadius: 5.0,
                                                      spreadRadius: 1.0,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                child: ListTile(
                                                  dense: true,
                                                  leading: Icon(
                                                    FontAwesomeIcons.dice,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  title: Text(
                                                    'Entertainment',
                                                    //overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                      color: Colors.deepOrange,
                                                      fontSize: 18.0,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            if (index == 5 &&
                                                userData.book == true) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 1),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 1),
                                                      blurRadius: 5.0,
                                                      spreadRadius: 1.0,
                                                    ),
                                                  ],
                                                ),
                                                child: ListTile(
                                                  dense: true,
                                                  leading: Icon(
                                                    FontAwesomeIcons.book,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  title: Text(
                                                    'Book',
                                                    //overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                      fontFamily: 'Opun',
                                                      color: Colors.deepOrange,
                                                      fontSize: 18.0,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            if (index == 6 &&
                                                userData.pet == true) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 1),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(0, 1),
                                                      blurRadius: 5.0,
                                                      spreadRadius: 1.0,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                child: ListTile(
                                                  dense: true,
                                                  leading: Icon(
                                                    FontAwesomeIcons.cat,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  title: Text(
                                                    'Pet',
                                                    //overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                      fontFamily: 'Opun',
                                                      color: Colors.deepOrange,
                                                      fontSize: 18.0,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            return SizedBox();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            StreamBuilder<History>(
                                stream: DatabaseService(userID: user?.userId)
                                    .history,
                                builder: (context, snapshot) {
                                  //print(snapshot.data);
                                  if (snapshot.hasData) {
                                    //print('kao if jaaaaa');
                                    History userHistory = snapshot.data;
                                    if (userHistory.resID == 'restaurant ID') {
                                      return Text('No history yet',
                                          style: TextStyle(
                                              fontFamily: 'Opun',
                                              color: Colors.black45));
                                    } else {
                                      return Container(
                                        /////////////////////////////////////////History
                                          width:
                                          MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          //color: Colors.blue,
                                          child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'History : ',
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (_) =>
                                                                HistoryPage(
                                                                  resID: userHistory
                                                                      .resID,
                                                                  image: userHistory
                                                                      .image,
                                                                  name1: userHistory
                                                                      .name1,
                                                                  name2: userHistory
                                                                      .name2,
                                                                  location:
                                                                  userHistory
                                                                      .location,
                                                                  time: userHistory
                                                                      .time,
                                                                  ageStart:
                                                                  userHistory
                                                                      .ageStart,
                                                                  ageEnd: userHistory
                                                                      .ageEnd,
                                                                  num: userHistory
                                                                      .num,
                                                                  dueTime:
                                                                  userHistory
                                                                      .dueTime,
                                                                  gender: userHistory
                                                                      .gender,
                                                                  fashion:
                                                                  userHistory
                                                                      .fashion,
                                                                  sport: userHistory
                                                                      .sport,
                                                                  technology:
                                                                  userHistory
                                                                      .technology,
                                                                  politics:
                                                                  userHistory
                                                                      .politics,
                                                                  entertainment:
                                                                  userHistory
                                                                      .entertainment,
                                                                  book: userHistory
                                                                      .book,
                                                                  pet: userHistory
                                                                      .pet,
                                                                )));
                                                  },
                                                  child: Container(
                                                    height: 150,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          offset: Offset(0, 5),
                                                          blurRadius: 5.0,
                                                          spreadRadius: 2.0,
                                                        ),
                                                      ],
                                                    ),
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              10),
                                                          child: Image.network(
                                                            userHistory.image,
                                                            fit: BoxFit.cover,
                                                            width: 110,
                                                            height: 80,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: <Widget>[
                                                              Text(
                                                                userHistory
                                                                    .name1,
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Theme.of(context).primaryColor,
                                                                    //fontWeight: FontWeight.bold,
                                                                    letterSpacing: 0.5),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    FontAwesomeIcons
                                                                        .mapMarkerAlt,
                                                                    color: Theme.of(
                                                                        context)
                                                                        .primaryColor,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                      10),
                                                                  Expanded(
                                                                    child: Text(
                                                                      userHistory
                                                                          .location,
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                      maxLines:
                                                                      2,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    FontAwesomeIcons
                                                                        .user,
                                                                    color: Theme.of(
                                                                        context)
                                                                        .primaryColor,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                      10),
                                                                  Expanded(
                                                                    child: Text(
                                                                      userHistory.num
                                                                          .round()
                                                                          .toString(),
                                                                      overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                      maxLines:
                                                                      2,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ]));
                                    }
                                  } else {
                                    //print('kao else jaaaaaa');
                                    if (snapshot.hasError) {
                                      print(snapshot.error.toString());
                                    }
                                    return Loading();
                                  }
                                })
                          ]),
                    ],
                  );
                } else {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                  }
                  return Loading();
                }
              })),
    );
  }
}

class ViewProfilePictureScreen extends StatelessWidget {
  ViewProfilePictureScreen(this.url);
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'profile',
            child: CachedNetworkImage(
              imageUrl: url,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}