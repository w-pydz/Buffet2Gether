class UserFindGroup {

  final String name;
  final String imageUrl;
  final String gender;
  final int age;
  final String userID;
  final bool sport;
  final bool pet;
  final bool technology;
  final bool politics;
  final bool fashion;
  final bool entertainment;
  final bool book;

  UserFindGroup({ this.name,this.imageUrl, this.gender, this.age, this.userID,this.sport,this.pet,this.technology,this.politics,this.fashion,this.entertainment,this.book});

  @override
  bool getFashion() {
    return fashion;
  }

  @override
  bool getEntertainment() {
    return entertainment;
  }

  @override
  String getGender() {
    return gender;
  }

  @override
  bool getPet() {
    return pet;
  }

  @override
  bool getPolitics() {
    return politics;
  }

  @override
  bool getSport() {
    return sport;
  }

  @override
  bool getTechnology() {
    return technology;
  }

  @override
  bool getBook() {
    return book;
  }

}