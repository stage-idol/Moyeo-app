import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/meeting.dart';
import 'theme/app_theme.dart';

void main() => runApp(const MoyeoApp());

String dateLabel(DateTime d) =>
    '${d.month}월 ${d.day}일 (${['월', '화', '수', '목', '금', '토', '일'][d.weekday - 1]}) ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

class MoyeoApp extends StatelessWidget {
  const MoyeoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: '모여!',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        locale: const Locale('ko'),
        supportedLocales: const [Locale('ko')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: const HomeScreen(),
      );
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            children: children,
          ),
        ),
      );
}

class SoftCard extends StatelessWidget {
  const SoftCard({super.key, required this.child, this.color = Colors.white});
  final Widget child;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(26),
        ),
        child: child,
      );
}

Widget heading(String title, String subtitle) => Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(subtitle, style: const TextStyle(color: Colors.black54, height: 1.6)),
        ],
      ),
    );

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final meetings = sampleMeetings();
  Future<void> createMeeting() async {
    final meeting = await Navigator.of(context).push<Meeting>(
      MaterialPageRoute(builder: (_) => const CreateMeetingScreen()),
    );
    if (meeting == null || !mounted) return;
    setState(() => meetings.insert(0, meeting));
    await openMeeting(meeting);
  }

  Future<void> openMeeting(Meeting meeting) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => MeetingDetailScreen(meeting: meeting)),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('모여!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28))),
        body: PageBody(children: [
          heading('좋은 만남의 시작', '언제, 어디서 만날까?\n친구들과 함께 정해요.'),
          SoftCard(
            color: AppTheme.peach,
            child: Row(children: [
              const Icon(Icons.wb_sunny_outlined, size: 36),
              const SizedBox(width: 16),
              Expanded(child: Text('우리의 다음 이야기는\n만나는 순간 시작돼요.', style: Theme.of(context).textTheme.titleMedium)),
            ]),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('진행 중인 모임 ${meetings.length}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const Text('함께 정하는 중', style: TextStyle(color: Colors.black54)),
          ]),
          const SizedBox(height: 18),
          for (final entry in meetings.asMap().entries)
            Semantics(
              button: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(26),
                onTap: () => openMeeting(entry.value),
                child: SoftCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Chip(label: Text(entry.value.myDateVotes.isEmpty ? '일정 투표 중' : '내 투표 완료'), backgroundColor: entry.key.isEven ? AppTheme.lilac : AppTheme.mint, side: BorderSide.none),
                  const SizedBox(height: 10),
                  Text(entry.value.title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text('${entry.value.members.join(' · ')}  /  ${entry.value.members.length}명'),
                  const SizedBox(height: 12),
                  const Row(children: [Text('모임 살펴보기'), Spacer(), Icon(Icons.arrow_forward_rounded)]),
                ])),
              ),
            ),
          const SizedBox(height: 10),
          FilledButton.icon(onPressed: createMeeting, icon: const Icon(Icons.add), label: const Text('새 모임 만들기')),
          const SizedBox(height: 20),
          const Text('샘플 모드 · 앱을 다시 시작하면 데이터가 초기화돼요.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black54)),
        ]),
      );
}

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({super.key});
  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final selected = <String>{};
  String? memberError;
  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  void submit() {
    final valid = formKey.currentState!.validate();
    setState(() => memberError = selected.isEmpty ? '함께할 친구를 한 명 이상 선택해 주세요.' : null);
    if (!valid || selected.isEmpty) return;
    Navigator.pop(context, Meeting(
      title: title.text.trim(),
      members: ['나', ...selected],
      dates: [],
      placeVotes: {'연남동 파스타': 0, '성수동 피자': 0, '서울숲': 0},
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('모임 만들기')),
        body: PageBody(children: [
          heading('누구와 만날까요?', '작은 약속도 좋아요. 먼저 친구들을 모아봐요.'),
          Form(key: formKey, child: TextFormField(
            controller: title,
            maxLength: 40,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: '모임 제목', hintText: '예: 금요일엔 맛있는 저녁'),
            validator: (value) => value == null || value.trim().isEmpty ? '모임 제목을 입력해 주세요.' : null,
          )),
          const SizedBox(height: 24),
          const Text('함께할 친구', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('나는 자동으로 참석자에 포함돼요.'),
          const SizedBox(height: 18),
          SoftCard(child: Column(children: [
            for (final friend in friends)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                secondary: CircleAvatar(backgroundColor: AppTheme.lilac, child: Text(friend.substring(0, 1))),
                title: Text(friend),
                value: selected.contains(friend),
                onChanged: (value) => setState(() {
                  value == true ? selected.add(friend) : selected.remove(friend);
                  memberError = null;
                }),
              ),
          ])),
          if (memberError != null) Padding(padding: const EdgeInsets.only(bottom: 16), child: Text(memberError!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          FilledButton(onPressed: submit, child: Text('모임 만들기 · ${selected.length + 1}명')),
        ]),
      );
}

class MeetingDetailScreen extends StatefulWidget {
  const MeetingDetailScreen({super.key, required this.meeting});
  final Meeting meeting;
  @override
  State<MeetingDetailScreen> createState() => _MeetingDetailScreenState();
}

class _MeetingDetailScreenState extends State<MeetingDetailScreen> {
  Future<void> vote() async {
    await Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => DateVoteScreen(meeting: widget.meeting)));
    if (mounted) setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final meeting = widget.meeting;
    return Scaffold(
      appBar: AppBar(title: const Text('모임 상세')),
      body: PageBody(children: [
        heading(meeting.title, '서로의 시간을 모아, 함께하는 하루로.'),
        SoftCard(color: AppTheme.lilac, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('함께하는 친구들', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final member in meeting.members) Chip(avatar: const Icon(Icons.person_outline, size: 18), label: Text(member), side: BorderSide.none)]),
        ])),
        SoftCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('언제 만날까요?', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (meeting.dates.isEmpty) const Text('첫 번째 일정 후보를 제안해 주세요.'),
          for (final date in meeting.dates) Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(children: [Expanded(child: Text(dateLabel(date))), Text(meeting.myDateVotes.contains(date) ? '나의 선택 ✓' : '투표 대기')]),
          ),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: vote, child: const Text('일정 투표하기'))),
        ])),
        SoftCard(color: AppTheme.mint, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('어디서 만날까요?', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('마음에 드는 장소 한 곳을 골라주세요. 변경할 수 있어요.'),
          const SizedBox(height: 12),
          for (final entry in (meeting.placeVotes ?? <String, int>{}).entries)
            Padding(padding: const EdgeInsets.only(bottom: 8), child: OutlinedButton(
              style: OutlinedButton.styleFrom(backgroundColor: meeting.myPlaceVote == entry.key ? Colors.white : Colors.transparent, minimumSize: const Size(double.infinity, 52)),
              onPressed: () => setState(() => meeting.votePlace(entry.key)),
              child: Row(children: [Expanded(child: Text(entry.key)), Text('${entry.value}표${meeting.myPlaceVote == entry.key ? ' ✓' : ''}')]),
            )),
        ])),
        const Text('일정과 장소는 투표 중이에요. 아직 확정되지 않았어요.', style: TextStyle(color: Colors.black54)),
      ]),
    );
  }
}

class DateVoteScreen extends StatefulWidget {
  const DateVoteScreen({super.key, required this.meeting});
  final Meeting meeting;
  @override
  State<DateVoteScreen> createState() => _DateVoteScreenState();
}

class _DateVoteScreenState extends State<DateVoteScreen> {
  late final Set<DateTime> selected = {...widget.meeting.myDateVotes};
  late final List<DateTime> candidates = [...widget.meeting.dates];
  Future<void> addCandidate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = await showDatePicker(context: context, initialDate: today.add(const Duration(days: 1)), firstDate: today, lastDate: DateTime(now.year + 2, now.month, now.day));
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 18, minute: 0));
    if (time == null || !mounted) return;
    final candidate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    if (!candidate.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('현재보다 이후의 시간을 선택해 주세요.')));
      return;
    }
    setState(() {
      if (!candidates.contains(candidate)) candidates.add(candidate);
      candidates.sort();
      selected.add(candidate);
    });
  }
  void save() {
    widget.meeting.dates
      ..clear()
      ..addAll(candidates);
    widget.meeting.myDateVotes
      ..clear()
      ..addAll(selected);
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('일정 투표')),
        body: PageBody(children: [
          heading('시간을 맞춰봐요', '가능한 날짜와 시간을 모두 선택해 주세요.\n새로운 일정도 제안할 수 있어요.'),
          SoftCard(color: AppTheme.peach, child: Text(widget.meeting.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          if (candidates.isEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Text('아직 일정 후보가 없어요. 아래에서 추가해 주세요.')),
          for (final candidate in candidates)
            SoftCard(child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(dateLabel(candidate)),
              subtitle: const Text('참석할 수 있어요'),
              value: selected.contains(candidate),
              onChanged: (value) => setState(() { value == true ? selected.add(candidate) : selected.remove(candidate); }),
            )),
          OutlinedButton.icon(onPressed: addCandidate, icon: const Icon(Icons.add), label: const Text('날짜와 시간 제안하기')),
          const SizedBox(height: 24),
          FilledButton(onPressed: selected.isEmpty ? null : save, child: Text('${selected.length}개 일정에 투표하기')),
          const SizedBox(height: 12),
          const Text('투표 버튼을 눌러야 저장돼요. 뒤로 가면 변경을 취소해요.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 12)),
        ]),
      );
}
