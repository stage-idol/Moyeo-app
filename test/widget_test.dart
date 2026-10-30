import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moyeo/main.dart';

void main() {
  testWidgets('제목 검증 후 친구를 선택해 모임을 만들면 상세와 홈에 반영된다', (tester) async {
    await tester.pumpWidget(const MoyeoApp());
    await tester.scrollUntilVisible(find.text('새 모임 만들기'), 250);
    await tester.tap(find.text('새 모임 만들기'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('모임 만들기 · 1명'), 250);
    await tester.tap(find.text('모임 만들기 · 1명'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byType(TextFormField), -250);
    expect(find.text('모임 제목을 입력해 주세요.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '테스트 모임');
    await tester.scrollUntilVisible(find.text('지민'), 250);
    await tester.tap(find.text('지민'));
    await tester.pump();
    await tester.scrollUntilVisible(find.text('모임 만들기 · 2명'), 250);
    await tester.tap(find.text('모임 만들기 · 2명'));
    await tester.pumpAndSettle();
    expect(find.text('모임 상세'), findsOneWidget);
    expect(find.text('테스트 모임'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('진행 중인 모임 3'), findsOneWidget);
  });

  testWidgets('샘플 모임의 일정 투표를 저장하면 상세에 선택이 표시된다', (tester) async {
    await tester.pumpWidget(const MoyeoApp());
    await tester.tap(find.text('오랜만에, 우리 저녁 먹자'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('일정 투표하기'), 250);
    await tester.tap(find.text('일정 투표하기'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pump();
    await tester.scrollUntilVisible(find.text('1개 일정에 투표하기'), 250);
    await tester.tap(find.text('1개 일정에 투표하기'));
    await tester.pumpAndSettle();
    expect(find.text('나의 선택 ✓'), findsOneWidget);
  });
}
