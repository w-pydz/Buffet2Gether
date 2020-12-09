import 'package:buffet2gether_home/models/userFindGroup_model.dart';
import 'package:buffet2gether_home/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buffet2gether_home/services/database.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:buffet2gether_home/models/rec_model.dart';
import 'package:buffet2gether_home/models/more_model.dart';
import 'package:provider/provider.dart';
import 'package:buffet2gether_home/pages/home/info_page.dart';
import 'package:buffet2gether_home/services/auth.dart';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:buffet2gether_home/models/userMaster_model.dart';
import 'package:buffet2gether_home/models/mytable_model.dart';
import 'package:buffet2gether_home/pages/home/search_page.dart';
import 'package:buffet2gether_home/models/promotion_model.dart';

class HomeColumn extends StatefulWidget {
  @override
  _HomeColumnState createState() => new _HomeColumnState();
}

class _HomeColumnState extends State<HomeColumn> {
  SwiperController swiperController = SwiperController();
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 10),
        );
      }
      if (swiperController.hasListeners) {
        swiperController.move(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final recs = Provider.of<List<Recom>>(context);
    final user = Provider.of<User>(context);
    final more = Provider.of<List<More>>(context);
    final proPics = Provider.of<List<Promo>>(context);

    final textPro = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5),
            color: Colors.amberAccent,
          ),
          margin: EdgeInsets.only(left: 10),
          child: Text(
            '  โปรโมชั่นจากน้องบุฟ !  ',
            style: TextStyle(
              fontFamily: 'Opun',
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );

    final picPro = ConstrainedBox(
        child: new Swiper(
          itemCount: proPics?.length,
          autoplay: true,
          pagination: new SwiperPagination(),
          controller: swiperController,
          itemBuilder: (BuildContext context, int index) {
            final proPic = proPics[index];
            return InkWell(
                onTap: () {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return StreamProvider<List<UserFindGroup>>.value(
                        value:
                        DatabaseService(resID: proPic.resID).userFindGroup,
                        child: StreamProvider<Mytable>.value(
                          value: DatabaseService(userID: user.userId).mytable,
                          child: StreamProvider<List<UserMaster>>.value(
                            value:
                            DatabaseService(resID: proPic.resID).userMaster,
                            child: StreamProvider<User>.value(
                                value: AuthService().user,
                                child: InfoPage(
                                  resID: proPic.resID,
                                  image: proPic.imageUrl,
                                  name1: proPic.name1,
                                  name2: proPic.name2,
                                  location: proPic.location,
                                  time: proPic.time,
                                  promotion: proPic.promotion,
                                  promotionInfo: proPic.promotionInfo,
                                )),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Image.network(proPic.proPic));
          },
        ),
        constraints: new BoxConstraints.loose(new Size(350, 220.0)));

    final promotion = Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[picPro, textPro],
    );

    final textRecom = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(5),
              color: Colors.deepOrange,
            ),
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '  น้องบุฟแนะนำ !  ',
              style: TextStyle(
                fontFamily: 'Opun',
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ))
      ],
    );

    final rowRecom = Container(
        height: 155,
        color: Color(0xFFF5F5F5),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: recs?.length,
          itemBuilder: (BuildContext context, int index) {
            final rec = recs[index];
            return InkWell(
                onTap: () {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return StreamProvider<List<UserFindGroup>>.value(
                          value:
                          DatabaseService(resID: rec.resID).userFindGroup,
                          child: StreamProvider<Mytable>.value(
                            value: DatabaseService(userID: user.userId).mytable,
                            child: StreamProvider<List<UserMaster>>.value(
                              value:
                              DatabaseService(resID: rec.resID).userMaster,
                              child: StreamProvider<User>.value(
                                  value: AuthService().user,
                                  child: InfoPage(
                                    resID: rec.resID,
                                    image: rec.imageUrl,
                                    name1: rec.name1,
                                    name2: rec.name2,
                                    location: rec.location,
                                    time: rec.time,
                                    promotion: rec.promotion,
                                    promotionInfo: rec.promotionInfo,
                                  )),
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10, bottom: 7),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  width: 140,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Positioned(
                          bottom: 0,
                          child: Container(
                            height: 100,
                            width: 140,
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(1),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    rec.name1,
                                    style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    rec.name2,
                                    style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 6,
                              )
                            ]),
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                rec.imageUrl,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 90,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ));

    final textMore = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '  ร้านอื่น ๆ ของน้องบุฟ  ',
          style: TextStyle(
            fontFamily: 'Opun',
            color: Colors.deepOrange,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            //backgroundColor: Colors.amberAccent,
          ),
        )
      ],
    );

    final colMore = Container(
        height: 400,
        width: screenSize.width,
        color: Color(0xFFF5F5F5),
        child: ListView.builder(
            itemCount: more?.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final m = more[index];
              return InkWell(
                  onTap: () {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return StreamProvider<List<UserFindGroup>>.value(
                            value:
                            DatabaseService(resID: m.resID).userFindGroup,
                            child: StreamProvider<Mytable>.value(
                              value:
                              DatabaseService(userID: user.userId).mytable,
                              child: StreamProvider<List<UserMaster>>.value(
                                value:
                                DatabaseService(resID: m.resID).userMaster,
                                child: StreamProvider<User>.value(
                                    value: AuthService().user,
                                    child: InfoPage(
                                      resID: m.resID,
                                      image: m.imageUrl,
                                      name1: m.name1,
                                      name2: m.name2,
                                      location: m.location,
                                      time: m.time,
                                      promotion: m.promotion,
                                      promotionInfo: m.promotionInfo,
                                    )),
                              ),
                            ),
                          );
                        });
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              m.imageUrl,
                              fit: BoxFit.cover,
                              width: 110,
                              height: 80,
                            ),
                          ),
                          Container(
                            width: screenSize.width - 135,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Expanded(
                                        child: Text(
                                          m.name1,
                                          style: TextStyle(
                                              fontFamily: 'Opun',
                                              color: Colors.deepOrange,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          m.name2,
                                          style: TextStyle(
                                              fontFamily: 'Opun',
                                              color: Colors.deepOrange,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      size: 25,
                                      color: Colors.amber,
                                    ),
                                    Expanded(
                                      child: Text(
                                        m.location,
                                        style: TextStyle(
                                          fontFamily: 'Opun',
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Icon(Icons.access_time,
                                        size: 25, color: Colors.amber),
                                    Expanded(
                                      child: Text(
                                        m.time,
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
                      )));
            }));

    final homeColumn = Container(
      color: Color(0XFFF5F5F5),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          promotion,
          textRecom,
          SizedBox(
            height: 5,
          ),
          rowRecom,
          SizedBox(
            height: 10,
          ),
          textMore,
          colMore,
        ],
      ),
    );

    return Scaffold(
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.search),
            color: Colors.orange,
            onPressed: () {
              return showDialog(
                context: context,
                builder: (context) {
                  return StreamProvider<User>.value(
                    value: AuthService().user,
                    child: new SearchPage(),
                  );
                },
              );
            },
          ),
          centerTitle: true,
          title: new Text(
            'Buffet2Gether',
            style: TextStyle(
                color: Colors.deepOrange,
                fontFamily: 'Opun',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xfff5f5f5),
        ),
        body: SafeArea(
            child: StreamBuilder<List<Promo>>(
                stream: DatabaseService().promotionPic,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return StreamProvider<User>.value(
                        value: AuthService().user,
                        child: StreamProvider<List<Recom>>.value(
                            value: DatabaseService().recInRes,
                            child: StreamProvider<List<More>>.value(
                                value: DatabaseService().moreInRes,
                                child: StreamProvider<List<Promo>>.value(
                                    value: DatabaseService().promotionPic,
                                    child: ListView.builder(
                                      controller: scrollController,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: 1,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return homeColumn;
                                      },
                                    )))));
                  } else {
                    if (snapshot.hasError) {
                      print(snapshot.error.toString());
                    }
                    return Loading();
                  }
                })));
  }
}