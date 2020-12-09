import 'package:buffet2gether_home/models/table_model.dart';
import 'package:flutter/material.dart';

class InterestingInTable extends StatefulWidget {
  @override
  _InterestingInTableState createState() =>
      _InterestingInTableState();
}

class _InterestingInTableState extends State<InterestingInTable> {
  List<bool> _tempInteresting = myTable.interestingBool;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Interesting',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                SwitchListTile(
                  title: Text('Fashion'),
                  value: _tempInteresting[0],
                  secondary: Icon(
                    myTable.interestingIconUrl[0],
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (bool value) {
                    setState(() {
                      _tempInteresting[0] = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Sport'),
                  value: _tempInteresting[1],
                  secondary: Icon(
                    myTable.interestingIconUrl[1],
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (bool value) {
                    setState(() {
                      _tempInteresting[1] = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Technology'),
                  value: _tempInteresting[2],
                  secondary: Icon(
                    myTable.interestingIconUrl[2],
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (bool value) {
                    setState(() {
                      _tempInteresting[2] = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Politics'),
                  value: _tempInteresting[3],
                  secondary: Icon(
                    myTable.interestingIconUrl[3],
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (bool value) {
                    setState(() {
                      _tempInteresting[3] = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Entertainment'),
                  value: _tempInteresting[4],
                  secondary: Icon(
                    myTable.interestingIconUrl[4],
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (bool value) {
                    setState(() {
                      _tempInteresting[4] = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Book'),
                  value: _tempInteresting[5],
                  secondary: Icon(
                    myTable.interestingIconUrl[5],
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (bool value) {
                    setState(() {
                      _tempInteresting[5] = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Pet'),
                  value: _tempInteresting[6],
                  secondary: Icon(
                    myTable.interestingIconUrl[6],
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (bool value) {
                    setState(() {
                      _tempInteresting[6] = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlineButton(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        'Cancle',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        _tempInteresting = myTable.interestingBool;
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10),
                    OutlineButton(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () {
                        myTable.interestingBool = _tempInteresting;
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}