import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buffet2gether_home/services/search.dart';
import 'package:buffet2gether_home/services/database.dart';
import 'package:provider/provider.dart';
import 'package:buffet2gether_home/pages/home/info_page.dart';
import 'package:buffet2gether_home/services/auth.dart';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:buffet2gether_home/models/userMaster_model.dart';
import 'package:buffet2gether_home/models/mytable_model.dart';
import 'package:buffet2gether_home/models/userFindGroup_model.dart';

class SearchPage extends StatefulWidget
{
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScrollController scrollController;

  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  /* ----------------------------------- Search ---------------------------------------- */
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    // <----- call this function for search algorithm
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    }
    else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name1'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

/* ----------------------------------------------------------------------------------------------- */

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    final rowSearch = Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        onChanged: (val) { //when search the first word of restaurant name
          initiateSearch(val);
        },
        cursorColor: Colors.deepOrange,
        controller: textController,
        style: TextStyle(
          fontFamily: 'Opun',
          color: Colors.grey,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.search),
          hintText: 'ค้นหาด้วยการพิมพ์ 2 ตัวอักษรขึ้นไป',
        ),
      ),
    );

    final user = Provider.of<User>(context);

    final showResult = ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.vertical,
        primary: false,
        shrinkWrap: true,
        children: tempSearchStore.map((element) {
          return InkWell(
              onTap: () {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return StreamProvider<List<UserFindGroup>>.value(
                          value: DatabaseService(resID: element['resID']).userFindGroup,
                          child: StreamProvider<Mytable>.value(
                            value: DatabaseService(userID: user.userId).mytable,
                            child: StreamProvider<List<UserMaster>>.value(
                              value: DatabaseService(resID: element['resID']).userMaster,
                              child: StreamProvider<User>.value(
                                  value: AuthService().user,
                                  child: InfoPage(
                                    resID: element['resID'],
                                    image: element['imageUrl'],
                                    name1: element['name1'],
                                    name2: element['name2'],
                                    location: element['location'],
                                    time: element['time'],
                                    promotion: element['promotion'],
                                    promotionInfo: element['promotionInfo'],
                                  )
                              ),
                            ),
                          )
                      );
                    }
                );
              },
              child: new Container(
                  width: screenSize.width,
                  margin: EdgeInsets.only(bottom: 1, left: 5, right: 5),
                  padding: EdgeInsets.only(
                      bottom: 15, left: 10, right: 5, top: 15),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      Image.network(
                        element['imageUrl'],
                        fit: BoxFit.cover,
                        width: 110,
                        height: 80,),
                      Container(
                        width: screenSize.width - 155,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 25,),
                                  Expanded(
                                    child: Text(
                                      element['name1'],
                                      style: TextStyle(
                                          fontFamily: 'Opun',
                                          color: Colors.deepOrange,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      element['name2'],
                                      style: TextStyle(
                                          fontFamily: 'Opun',
                                          color: Colors.deepOrange,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.location_on, size: 25,
                                  color: Colors.amber,),
                                Expanded(
                                  child: Text(
                                    element['location'],
                                    style: TextStyle(
                                      fontFamily: 'Opun',
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Icon(Icons.access_time, size: 25,
                                    color: Colors.amber),
                                Expanded(
                                  child: Text(
                                    element['time'],
                                    style: TextStyle(
                                      fontFamily: 'Opun',
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )
              )
          );
        }).toList()
    );

    final allInPage = Container(
      color: Color(0XFFF5F5F5),
      child: Column(
        children: [
          SizedBox(height: 20,),
          rowSearch,
          SizedBox(height: 20,),
          showResult,
        ],
      ),
    );

    return Scaffold(
        appBar: new AppBar(
          //leading: new Container(),
          centerTitle: true,
          title: new Text(
            'Search',
            style: TextStyle(
                color: Colors.deepOrange,
                fontFamily: 'Opun',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xfff5f5f5),
        ),
        body: SafeArea(
            child: ListView.builder(
              controller: scrollController,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return allInPage;
              },
            )
        )
    );
  }

}