# 모여!

친구들과 모임을 만들고 날짜와 장소를 투표하는 Flutter 프로토타입입니다.
백엔드, 로그인, 채팅은 포함하지 않습니다. 모든 변경은 메모리에 저장되며 앱을 재시작하거나 웹을 새로고침하면 초기화됩니다.

## 실행

Flutter stable(Dart 3.4 이상 포함)이 필요합니다. 외부 패키지는 사용하지 않으며 Flutter SDK의 Material, 한국어 현지화와 테스트 패키지만 사용합니다.

```sh
flutter --version
flutter doctor -v
flutter pub get
flutter run -d chrome
```

브라우저가 없는 서버에서는 `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080`으로 실행하고 해당 서버 주소를 브라우저에서 엽니다.

현재 플랫폼 진입점은 `web/`입니다. Android/iOS 플랫폼 파일은 아직 생성하지 않았습니다. 모바일 개발 전 Flutter SDK가 있는 환경에서 아래 명령으로 생성하세요. 앱 표시 이름은 `모여!`로 별도 설정하고 배포용 식별자는 확정 후 사용하세요.

```sh
flutter create --platforms=android,ios --project-name moyeo --org com.example .
```

Android에는 Android SDK와 라이선스 설정이, iOS에는 macOS와 Xcode가 추가로 필요합니다.

## 화면과 동작

- 홈: 진행 중인 샘플 모임 목록, 모임 상세 이동, 새 모임 만들기
- 모임 만들기: 제목(공백 불가, 최대 40자), 친구 1명 이상 선택, 본인 자동 포함. 생성 후 상세로 이동하며 홈에도 추가됩니다.
- 일정 투표: 복수 일정 선택, 날짜/시간 선택기로 미래 후보 추가, 저장 후 상세 반영. 뒤로 가면 미저장 변경은 취소됩니다.
- 모임 상세: 참석자, 일정별 본인 선택, 장소 후보별 표 수. 장소는 한 곳만 투표하며 다른 후보로 변경 가능합니다.

샘플 일정은 실행일 기준 미래 날짜입니다. 기존 장소 표 수는 샘플 데이터이며 일정은 본인 투표만 표시합니다. 투표 마감/확정, 친구 검색/초대, 서버 동기화와 영구 저장은 구현하지 않았습니다.

## 디자인과 폰트

아이보리 배경, 검정 주요 버튼, 라일락·민트·피치 포인트와 둥근 카드로 구성했습니다. 작은 화면은 스크롤하고 큰 화면은 콘텐츠 폭을 제한합니다.

카페24 써라운드 파일은 확보하지 못해 시스템 기본 폰트를 사용합니다. 테마에서 한 번에 교체할 수 있으며 `assets/fonts/README.md`에 등록 방법이 있습니다.

## 파일 구조

- `lib/main.dart`: 앱 진입점, 네 화면과 공용 UI
- `lib/models/meeting.dart`: 모임 모델, 샘플 데이터, 장소 투표 처리
- `lib/theme/app_theme.dart`: 색상, 버튼, 폰트 테마
- `web/`: 웹 실행 진입점과 매니페스트
- `test/`: 장소 중복 투표/변경, 모임 생성/검증, 일정 투표 저장 테스트

## 검증

SDK가 있는 환경에서 다음 명령을 실행하세요.

```sh
dart format lib test
flutter analyze
flutter test
flutter build web
```

로컬 환경에는 Flutter/Dart SDK가 없고 SDK 다운로드 요청도 프록시 연결 오류로 실패했습니다. GitHub Actions의 Flutter 3.24.5 / Dart 3.5.4 환경에서 `flutter pub get`, `flutter analyze --fatal-infos`, `flutter test`(3개), `flutter build web`은 모두 통과했습니다. 화면 테스트의 스크롤 탐색과 한국어 뒤로 가기 버튼 탐색을 수정했습니다. 실제 브라우저/모바일 실행과 시각 검증은 수행하지 못했습니다. `pubspec.lock`은 최초 `flutter pub get` 후 생성해 버전 관리에 포함하세요.

## GitHub Actions와 Pages 미리보기

`.github/workflows/flutter-web.yml`은 Flutter 3.24.5를 설치하고 `pub get`, `analyze`, `test`, `build web`을 차례로 실행합니다. 하나라도 실패하면 배포하지 않습니다. 디자인과 앱 기능은 변경하지 않았습니다.

- `feat/flutter-web-preview`, `main`에 push하면 검사 후 Pages 배포를 시도합니다.
- main 대상 PR에서는 검사와 `moyeo-web` 빌드 아티팩트만 생성하며 배포하지 않습니다.
- 저장소 **Settings → Pages → Build and deployment → Source → GitHub Actions**로 설정해야 합니다.
- **Settings → Environments → github-pages**에 배포 브랜치 제한이 있으면 `feat/flutter-web-preview`를 허용해야 해당 브랜치에서 미리보기를 배포할 수 있습니다.
- Actions의 **Flutter web preview** 실행을 확인합니다. Pages 설정을 완료한 후 실패 실행을 다시 실행할 수 있습니다. 워크플로가 main에 병합된 이후에는 **Run workflow**에서 브랜치를 선택할 수도 있습니다.
- 배포 성공 후 예상 주소는 `https://stage-idol.github.io/Moyeo-app/`입니다. 이 주소는 브랜치별 독립 미리보기가 아니라 저장소가 공유하는 Pages 주소이며, 마지막 성공 배포로 갱신됩니다.
- 빌드에는 `/Moyeo-app/` base href를 적용해 GitHub 프로젝트 페이지에서 리소스 경로가 맞도록 했습니다.

검증 실행: https://github.com/stage-idol/Moyeo-app/actions/runs/41086214534

위 실행에서 네 명령과 웹 아티팩트 업로드는 성공했습니다. Pages 배포는 `Get Pages site failed: Not Found`로 실패했습니다. Pages 설정을 GitHub Actions로 활성화한 뒤 위 실행의 실패한 deploy 작업을 재실행하세요. 현재 미리보기 주소는 아직 준비되지 않았습니다. 연결 도구에는 Pages 설정 변경 기능이 없어 수동 설정이 필요합니다.
