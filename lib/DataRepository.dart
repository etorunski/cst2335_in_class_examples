

class DataRepository {

  static String _theWords = ""; //it's "" until something changes it



  static setWords(String words){
    _theWords = words;

  //  SharedPreferences.save("Words", _theWords);
  }

  static String getWords()
  {
    //setWords(sharedPrefs.getString("words"));
    return _theWords;
  }
}