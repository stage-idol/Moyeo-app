import 'package:flutter_test/flutter_test.dart';
import 'package:moyeo/models/meeting.dart';

void main() {
  test('장소를 다시 누르면 중복 집계하지 않고 변경하면 이전 표를 뺀다', () {
    final meeting = Meeting(title: '저녁', members: ['나', '지민'], dates: [], placeVotes: {'A': 2, 'B': 1});
    meeting.votePlace('A');
    meeting.votePlace('A');
    expect(meeting.placeVotes, {'A': 3, 'B': 1});
    meeting.votePlace('B');
    expect(meeting.placeVotes, {'A': 2, 'B': 2});
    expect(meeting.myPlaceVote, 'B');
  });
}
