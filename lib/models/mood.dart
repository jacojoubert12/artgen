class Mood {
  final int? moodID;
  final String? moodName;
  final String? moodBest;
  final String? moodMid;
  final String? moodWorst;
  int moodValue = 0;

  Mood(
      {this.moodID,
      this.moodBest,
      this.moodMid,
      this.moodWorst,
      this.moodName});

  Map<String, dynamic> toJson() => {
        'id': moodID,
        'name': moodName,
        'best': moodBest,
        'mid': moodMid,
        'worst': moodWorst,
      };

  static Mood fromJson(Map<String, dynamic> json) => Mood(
      moodID: json['id'],
      moodBest: json['best'],
      moodMid: json['mid'],
      moodWorst: json['worst'],
      moodName: json['name']);

  static List<Mood> moodListFromJson(snapshot) {
    List<Mood> moodList = [];
    for (var doc in snapshot.docs) {
      for (var mood in doc.data()['moods']) {
        Mood newMood = new Mood(
            moodID: mood['id'],
            moodName: mood['name'],
            moodBest: mood['best'],
            moodMid: mood['mid'],
            moodWorst: mood['worst']);
        moodList.add(newMood);
      }
    }
    return moodList;
  }
}

List<Mood>? moods = [];
