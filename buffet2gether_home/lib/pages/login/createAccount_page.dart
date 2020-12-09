import 'package:buffet2gether_home/services/auth.dart';
import 'package:buffet2gether_home/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:buffet2gether_home/pages/login/login_page.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:buffet2gether_home/services/database.dart';
import 'package:buffet2gether_home/models/profile_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

/////////////////////////////////////////////Sign Up///////////////////////////////////////////////
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => new _SignUpState();
}

class _SignUpState extends State<SignUp>
    with SingleTickerProviderStateMixin //<=== register page
    {
  ScrollController scrollController;
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  //text field
  static String email = '';
  static String password = '';

  String error = '';

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView.builder(
                controller: scrollController,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 70,
                          ),
                          Text(
                            'Create your account',
                            style: TextStyle(
                                fontFamily: 'Opun',
                                color: Colors.deepOrange,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            //email block
                            width: 380,
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              cursorColor: Colors.deepOrange,
                              style: TextStyle(
                                fontFamily: 'Opun',
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  prefixIcon: Icon(Icons.email)),
                              validator: (val) =>
                              isEmail(val) ? null : "Invalid email",
                              onChanged: (val) {
                                setState(() =>
                                email = val); // save email to text field
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 380,
                            decoration: new BoxDecoration(
                              // <----- Password block
                              borderRadius: new BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              // Password Text Field
                              cursorColor: Colors.deepOrange,
                              style: TextStyle(
                                fontFamily: 'Opun',
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  prefixIcon: Icon(Icons.lock)),
                              validator: (val) => val.length < 6
                                  ? 'Please enter a password more than 6 characters'
                                  : null,
                              onChanged: (val) {
                                setState(() => password =
                                    val); //save password to textfield
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            color: Colors.yellow[600],
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                new BorderRadius.all(Radius.circular(10))),
                            onPressed: () async {
                              if (_formkey.currentState.validate()) {
                                dynamic result = await _auth.registerWithEmailAndPassword(
                                    email, password);
                                print(result);
                                if(result == null){

                                  setState(() => error = "This email is already use");
                                }else{
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StreamProvider<User>.value(
                                          value: AuthService().user,
                                          child: CreateProfile());
                                    },
                                  );
                                }
                              }
                            },
                            child: new Container(
                              width: 380,
                              height: 50,
                              child: Text(
                                'Next',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Opun',
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  );
                })));
  }
}

/////////////////////////////////////////////////////////////////////////////profile //////////////////////////////////////////////////////////////////////////////////
class CreateProfile extends StatefulWidget {
  final Function toggleView;
  CreateProfile({this.toggleView});

  @override
  _CreateProfileState createState() => new _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile>
    with SingleTickerProviderStateMixin // <=== Profile page
    {
  ScrollController scrollController;
  File _tempImage;
  String _uploadedImageURL;

  //final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  //Text Field
  static bool regSuccess = false;
  static String gender = '';
  static String username = '';
  _SignUpState signup = new _SignUpState();
  var email = _SignUpState.email;
  var password = _SignUpState.password;
  bool loading = false;
  DateTime dateOfBirth;
  String error = "";
  GenderItem selectedGender;
  bool inputError = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : Scaffold(
        body: SafeArea(
            child: StreamBuilder<UserData>(
                stream: DatabaseService(uid: user?.userId).userData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserData userData = snapshot.data;
                    Future getImageFromGalleryAndUpload() async {
                      await ImagePicker.pickImage(
                          source: ImageSource.gallery)
                          .then((image) {
                        setState(() {
                          _tempImage = image;
                        });
                      });
                      if (_tempImage != null) {
                        StorageReference storageReference = FirebaseStorage
                            .instance
                            .ref()
                            .child('profile_pictures/user_' +
                            userData.userId.toString());
                        StorageUploadTask uploadTask =
                        storageReference.putFile(_tempImage);
                        await uploadTask.onComplete;
                        //print('File Uploaded');
                        storageReference.getDownloadURL().then((fileURL) {
                          setState(() {
                            _uploadedImageURL = fileURL;
                          });
                        });
                      }
                    }

                    return ListView(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15),
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Form(
                              key: _formkey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Create your profile',
                                    style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.deepOrange,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 100,
                                    height: 100,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          _uploadedImageURL ??
                                              userData.profilePicture),
                                      radius: 70,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      getImageFromGalleryAndUpload();
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                  SizedBox(
                                    //Box for input username    <==== Start at this line
                                    height: 20,
                                  ),
                                  Container(
                                    width: 380,
                                    decoration: new BoxDecoration(
                                      borderRadius:
                                      new BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: TextFormField(
                                      cursorColor: Colors.deepOrange,
                                      style: TextStyle(
                                        fontFamily: 'Opun',
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Username',
                                          errorText: inputError?"Enter a username 4-12 characters":null,
                                          prefixIcon: Icon(Icons.person)),
                                      onChanged: (val) {
                                        if(val.length < 4||val.length>12){
                                          setState(() => inputError = true);
                                        }else{
                                          setState(() {
                                            username =val;
                                            inputError = false;
                                          }); //save username to textfield
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    //Box select gender
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.venusMars,
                                          color: Theme.of(context)
                                              .primaryColor,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          'Gender',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 17,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          ' *',
                                          style: TextStyle(
                                              fontSize: 17,
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  DropdownButton<GenderItem>(
                                    isDense: true,
                                    isExpanded: true,
                                    hint: Text('Select your gender'),
                                    value: selectedGender,
                                    onChanged: (GenderItem value) {
                                      setState(() {
                                        selectedGender = value;
                                        gender = selectedGender.genderName;
                                        //print('select ' + selectedGender.genderName);
                                      });
                                    },
                                    items: genderList
                                        .map<DropdownMenuItem<GenderItem>>(
                                            (value) {
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
                                  SizedBox(
                                    // Box For input Age    <==== Start at this line
                                    height: 10,
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.birthdayCake,
                                          color: Theme.of(context)
                                              .primaryColor,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          'Date of Birth',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 17,
                                            letterSpacing: 0.5,
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
                                              'Edit your date of birth'),
                                          onPressed: () {
                                            DatePicker.showDatePicker(
                                              context,
                                              showTitleActions: true,
                                              minTime: DateTime(1950),
                                              maxTime: DateTime.now(),
                                              onConfirm: (date) {
                                                //print('confirm $date');
                                                dateOfBirth = date;
                                              },
                                              currentTime: dateOfBirth,
                                              locale: LocaleType.th,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    // Button is here  <==== Start at this line
                                    height: 20,
                                  ),
                                  RaisedButton(
                                    color: Colors.yellow[600],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius.circular(
                                            10.0)),
                                    onPressed: () async {
                                      // if press
                                      if(selectedGender!=null&&dateOfBirth!=null&&username!=''){
                                        if (_formkey.currentState
                                            .validate()) {
                                          await DatabaseService(
                                              uid: userData.userId)
                                              .updateFirstTimeUserData(
                                              _uploadedImageURL ??
                                                  'https://firebasestorage.googleapis.com/v0/b/buffet2gether.appspot.com/o/profile_pictures%2Fdefault.png?alt=media&token=c91f2a65-0928-4eb1-a284-c07c0a8c1517',
                                              username,
                                              selectedGender.genderName,
                                              dateOfBirth); // <=;== pass arguement to register    [function is in service/auth  ]

                                          return Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()));
                                        }
                                      }else{
                                        print(username);
                                        setState(() {
                                          if(username==''){

                                            error = 'Username must not be empty';

                                          }else{
                                            error = (selectedGender==null)?'Please select your gender':'Please select your date of birth';
                                          }
                                        });

                                      }
                                    },
                                    child: new Container(
                                      width: 380,
                                      height: 50,
                                      child: Text(
                                        'Done',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Opun',
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  Text(
                                    error,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]);
                  } else {
                    return Loading();
                  }
                })));
  }
}