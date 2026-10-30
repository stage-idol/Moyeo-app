class Meeting {
  Meeting({
    required this.title,
    required this.members,
    required this.dates,
    this.placeVotes,
  });

  final String title;
  final List<String> members;
  final List<DateTime> dates;
  final Map<String, int>? placeVotes;
  final Set<DateTime> myDateVotes = {};
  String? myPlaceVote;

  void votePlace(String place) {
    final votes = placeVotes;
    if (votes == null || myPlaceVote == place) return;
    if (myPlaceVote != null) {
      votes[myPlaceVote!] = (votes[myPlaceVote!] ?? 1) - 1;
    }
    votes[place] = (votes[place] ?? 0) + 1;
    myPlaceVote = place;
  }
}

const friends = ['지민', '수아', '도윤', '하린', '서준', '유진'];

List<Meeting> sampleMeetings() {
  final now = DateTime.now();
  DateTime day(int offset, int hour) =>
      DateTime(now.year, now.month, now.day + offset, hour);
  return [
    Meeting(
      title: '오랜만에, 우리 저녁 먹자',
      members: ['나', '지민', '수아', '도윤'],
      dates: [day(3, 18), day(4, 19), day(5, 18)],
      placeVotes: {'연남동 파스타': 2, '성수동 피자': 1, '합정 한식': 0},
    ),
    Meeting(
      title: '주말의 작은 피크닉',
      members: ['나', '하린', '서준'],
      dates: [day(7, 12), day(8, 13)],
      placeVotes: {'서울숲': 1, '한강공원': 1},
    ),
  ];
}
