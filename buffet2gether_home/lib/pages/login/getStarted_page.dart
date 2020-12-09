import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buffet2gether_home/pages/login/login_page.dart';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:buffet2gether_home/pages/wrapper.dart';
import 'package:buffet2gether_home/services/auth.dart';
import 'package:provider/provider.dart';

class GetStartedColumn extends StatefulWidget
{
  @override
  _GetStartedColumnState createState() => new _GetStartedColumnState();
}

class _GetStartedColumnState extends State<GetStartedColumn>
{
  ScrollController scrollController;

  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    final screenSize = MediaQuery.of(context).size;

    final buttonStarted = new InkWell(
      onTap: ()
      {
        return
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return StreamProvider<User>.value(
                    value: AuthService().user,
                    child: Wrapper(),
                  );

                },
              )
          );
      },
      child:new Container(
        margin: EdgeInsets.only(top:30.0),
        width: 300,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.yellow[600],
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Text(
          'Get Started',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Opun',
            color: Colors.white,
            fontSize: 20,fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final getStartedColumn = Container(
      decoration: BoxDecoration(
          color:Colors.white
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            SizedBox(height: 62,),
            Text(
              'Buffet2gether',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Opun',
                color: Colors.deepOrange,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 38,),
            Image.network(
              'https://firebasestorage.googleapis.com/v0/b/buffet2gether.appspot.com/o/restaurantAndPromotion_pictures%2FBuffet_transparent.png?alt=media&token=cb9c8611-b998-42aa-92f5-6972a91078cb',
              width: 230,
              height: 250,
            ),
            SizedBox(height: 37,),
            Stack(
              children: <Widget>[
                Container(
                  width: screenSize.width,
                  height: 200,
                  margin: EdgeInsets.only(top:110.0),
                  decoration: BoxDecoration(
                      color:Colors.deepOrange
                  ),
                ),
                Align(
                  child: Container(
                    height:220,
                    width: screenSize.width,
                    decoration: new BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: new BorderRadius.all(Radius.elliptical(200, 100)),
                    ),
                  ),
                ),
                Container(
                  width: screenSize.width,
                  height:180,
                  margin: EdgeInsets.only(top:60.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        Text(
                          'Hungry Now?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Opun',
                            color: Colors.white,
                            fontSize: 20,fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Create a post so other can join you.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Opun',
                            color: Colors.white,
                            fontSize: 15,fontWeight: FontWeight.bold,
                          ),
                        ),
                        buttonStarted
                      ]
                  ),
                ),
              ],
            )
          ]
      ) ,
    );

    return Scaffold(
        body: SafeArea(
            child: ListView.builder(
                controller: scrollController,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index)
                {
                  return getStartedColumn;
                })
        )
    );
  }
}