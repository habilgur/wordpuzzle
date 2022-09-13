class Player {
  String name;
  double point = 0;

  Player({required this.name});

  getCurrentPoint() => point;

  // Ads (+) prize to player point
  addQuestionPrize(double prize) {
    if (prize > 0) {
      point = point + prize;
    }
  }
}

//todo her soruda baştan ipucu ver yeşil  - randomKEy 2 yap

//todo her oyun için Ödüllü reklam ile x2 Hint ver

//todo skip butonu yap 3 adet skip hakkı olsun bunun için her skipte bir soru ekle questionliste

// todo günlük oynama sınırı 5 yap eğer oynamak isterse ödüllü izlet ancak max 3 kez izleyebilisin.
