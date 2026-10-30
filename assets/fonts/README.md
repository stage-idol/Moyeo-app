# 카페24 써라운드 폰트 교체

현재는 외부 폰트 다운로드 없이 플랫폼 기본 폰트를 사용합니다.
공식 배포처에서 카페24 써라운드 파일과 라이선스를 확보한 다음 아래처럼 적용하세요.

1. `Cafe24Ssurround.ttf`를 이 폴더에 넣고 배포 라이선스도 함께 보관합니다.
2. `pubspec.yaml`의 `flutter:` 아래에 다음 설정을 추가합니다.

```yaml
  fonts:
    - family: Cafe24Ssurround
      fonts:
        - asset: assets/fonts/Cafe24Ssurround.ttf
```

3. `lib/theme/app_theme.dart`의 `fontFamily`를 `'Cafe24Ssurround'`로 바꿉니다.
4. `flutter pub get` 실행 후 앱을 완전히 다시 시작합니다.

파일은 현재 포함되어 있지 않습니다. 파일 등록 전에는 위 설정을 활성화하지 마세요.
