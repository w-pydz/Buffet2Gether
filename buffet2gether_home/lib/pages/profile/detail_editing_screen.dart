import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:buffet2gether_home/services/database.dart';
import 'package:buffet2gether_home/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GenderItem {
  final genderName;
  final genderIcon;
  const GenderItem(this.genderIcon, this.genderName);
}

List genderList = <GenderItem>[
  const GenderItem(FontAwesomeIcons.mars, 'Male'),
  const GenderItem(FontAwesomeIcons.venus, 'Female'),
  const GenderItem(FontAwesomeIcons.venusMars, 'Not specified'),
];

class DetailEditingScreen extends StatefulWidget {
  @override
  _DetailEditingScreenState createState() => _DetailEditingScreenState();
}

class _DetailEditingScreenState extends State<DetailEditingScreen> {

  final _formKey = GlobalKey<FormState>();
  GenderItem selectedGender;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        leading: new Container(),
        title: Text(
          'Details',
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
                String newName = userData.name;
                String newGender = userData.gender;
                String newBio = userData.bio;
                DateTime newDateOfBirth = userData.dateofBirth;
                return ListView(
                  padding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          //width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.idCard,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Username',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                maxLength: 10,
                                decoration: InputDecoration(
                                    counterText: "",
                                    isDense: true,
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.grey[200]),
                                initialValue: userData.name,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text.';
                                  }
                                  if (value.length > 12) {
                                    return 'Please fill within 12 charaters.';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  newName = value;
                                },
                              ),
                              SizedBox(height: 30),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.venusMars,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Gender',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownButtonFormField<GenderItem>(
                                isDense: true,
                                isExpanded: true,
                                hint: Text('Select your gender'),
                                value: selectedGender,
                                onChanged: (GenderItem value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                                onSaved: (GenderItem value) {
                                  setState(() {
                                    if (value != null) {
                                      //selectedGender = value;
                                      newGender = selectedGender.genderName;
                                    }
                                  });
                                },
                                items: genderList
                                    .map<DropdownMenuItem<GenderItem>>((value) {
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
                              SizedBox(height: 30),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.font,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Bio',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                maxLines: 3,
                                maxLength: 100,
                                decoration: InputDecoration(
                                    counterText: "",
                                    isDense: true,
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.grey[200]),
                                initialValue: userData.bio,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text.';
                                  }
                                  if (value.length > 100)
                                    return 'Please fill within 100 characters.';
                                },
                                onSaved: (String value) {
                                  newBio = value;
                                },
                              ),
                              SizedBox(height: 30),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.birthdayCake,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Date of Birth',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: OutlineButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Text(
                                        'Edit your date of birth',
                                        style: TextStyle(
                                          fontFamily: 'Opun',
                                          color: Colors.black45,
                                          fontSize: 14,

                                        ),
                                      ),
                                      onPressed: () {
                                        DatePicker.showDatePicker(
                                          context,
                                          showTitleActions: true,
                                          minTime: DateTime(1950),
                                          maxTime: DateTime.now(),
                                          onConfirm: (date) {
                                            //print('confirm $date');
                                            newDateOfBirth = date;
                                            //print(date.toString());
                                          },
                                          currentTime: userData.dateofBirth,
                                          locale: LocaleType.th,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  OutlineButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Text(
                                      'Cancle',
                                      style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  OutlineButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.deepOrange,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () async {
                                      //print(newName);
                                      //print(newGender);
                                      //print(newDateOfBirth);
                                      //print(newBio);
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        await DatabaseService(uid: user.userId)
                                            .updateUserDataDetail(
                                            newName ?? userData.name,
                                            newGender ?? userData.gender,
                                            newDateOfBirth ?? userData.dateofBirth,
                                            newBio ?? userData.bio
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Loading();
              }
            }),
      ),
    );
  }
}