import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService
{
  searchByName(String searchField)
  {
    return Firestore.instance.collection('Restaurants').document('more').collection('moreList')
        .where('searchKey',isEqualTo: searchField.substring(0,1).toUpperCase())
        .getDocuments();
  }
}