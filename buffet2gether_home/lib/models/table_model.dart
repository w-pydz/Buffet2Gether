//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Table {
  String imageUrl;
  String name1;
  String name2;
  String location;
  String time;
  int ageStart;
  int ageEnd;
  int maxNum;
  DateTime dueDateTime;
  String gender;
  List<bool> interestingBool;
  List<String> interestingText;
  List<IconData> interestingIconUrl;

  Table(
      {
        this.imageUrl,
        this.name1,
        this.name2,
        this.location,
        this.time,
        this.ageStart,
        this.ageEnd,
        this.maxNum,
        this.dueDateTime,
        this.gender,
        this.interestingBool,
        this.interestingText,
        this.interestingIconUrl,
      }
      );
}

final myTable = new Table(
  interestingBool: [
    true, // 0 fasion
    true, // 1 sport
    true, // 2 technology
    true, // 3 politic
    true, // 4 entertainment
    true, // 5 book
    true, // 6 pet
  ],
  interestingText: [
    'Fashion',
    'Sports',
    'Technology',
    'Politics',
    'Entertainment',
    'Books',
    'Pet',
  ],
  interestingIconUrl: [
    FontAwesomeIcons.hatCowboySide,
    FontAwesomeIcons.footballBall,
    FontAwesomeIcons.laptop,
    FontAwesomeIcons.balanceScale,
    FontAwesomeIcons.dice,
    FontAwesomeIcons.book,
    FontAwesomeIcons.cat,
  ],
);