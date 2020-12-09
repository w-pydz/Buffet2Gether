class User {
  String userId;
  User({this.userId});
}

class UserData
{
  String profilePicture;
  String userId;
  String bio;
  String name;
  String password;
  String gender;
  String history;
  DateTime dateofBirth;
  bool fashion;
  bool sport;
  bool technology;
  bool politics;
  bool entertainment;
  bool book;
  bool pet;
  bool isOwner;

  UserData(
      {this.profilePicture,
        this.userId,
        this.isOwner,
        this.name,
        this.bio,
        this.password,
        this.gender,
        this.dateofBirth,
        this.fashion,
        this.sport,
        this.technology,
        this.politics,
        this.entertainment,
        this.book,
        this.pet,
        this.history});
}