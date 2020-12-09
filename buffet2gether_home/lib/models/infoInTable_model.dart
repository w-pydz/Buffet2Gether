///คลาส model รายละเอียดของหน้า Table
class InfoInTable
{
  String number;
  String name1;
  String name2;
  String location;
  String time;
  String imageUrl;
  int ageStart;
  int ageEnd;
  double people;
  String dueTime;
  String gender;
  bool sport;
  bool pet;
  bool technology;
  bool politics;
  bool fashion;
  bool entertainment;
  bool book;

  InfoInTable(
      {
        this.number,
        this.name1,
        this.name2,
        this.location,
        this.time,
        this.imageUrl,
        this.ageStart,
        this.ageEnd,
        this.dueTime,
        this.gender,
        this.people,
        this.sport,
        this.pet,
        this.technology,
        this.politics,
        this.fashion,
        this.entertainment,
        this.book,
      }
      );
}