# Zen

Calm, minimal meditation, yoga and stress-management app (Flutter, iOS + Android).
Languages: English and Turkish. Dark theme only (MVP).

## Run

```sh
flutter pub get   # also generates lib/l10n/app_localizations*.dart
dart run build_runner build   # regenerates *.freezed.dart / *.g.dart (committed)
flutter run
flutter analyze
flutter test
```

## Folder structure

```
lib/
├── main.dart                 # loads SharedPreferences, starts ProviderScope
├── app.dart                  # MaterialApp.router (theme, locale, router)
├── core/
│   ├── theme/                # app_colors, app_typography, app_spacing, app_theme
│   ├── router/               # app_router (go_router, 4-tab shell), route_names
│   └── l10n/                 # locale_controller (saved choice, else device language)
├── l10n/                     # app_en.arb, app_tr.arb (+ generated localizations)
├── shared/widgets/           # app_scaffold_with_nav (bottom navigation)
└── features/
    ├── home/presentation/        # Today tab
    ├── explore/presentation/     # Explore tab
    ├── programs/presentation/    # Programs tab
    ├── profile/presentation/     # Profile tab, language selector
    ├── content/                  # content models, ContentRepository, local JSON impl, providers
    ├── onboarding/  auth/  player/  subscription/   # empty, for later tasks
assets/{images,audio}/
assets/content/catalog.json   # mock content: categories, meditations, programs
test/                         # app_smoke_test, theme contrast test, content repository
```

## Audio player (background and lock screen)

Packages: `just_audio` (playback), `audio_service` (notification, lock screen, background service), `audio_session` (audio focus).

Native changes the player needs:

- **Android** `AndroidManifest.xml`: permissions `INTERNET`, `WAKE_LOCK`, `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_MEDIA_PLAYBACK`, `POST_NOTIFICATIONS`; the `com.ryanheise.audioservice.AudioService` service (`foregroundServiceType="mediaPlayback"`) and `MediaButtonReceiver`.
- **Android** `MainActivity.kt`: extends `AudioServiceActivity` instead of `FlutterActivity`.
- **iOS** `Info.plist`: `UIBackgroundModes` with `audio`.
- Android 13+ shows the playback notification only after the user allows notifications. Nothing asks for that permission yet; add the runtime request (for example when the first session starts) before release.
- Lock screen and notification cover art only shows `http(s)` cover URLs; Flutter asset covers cannot be shown by the system.

Audio files: sources are `assets/audio/...` paths or URLs. The catalog points at `assets/audio/sample.mp3`, which is not in the repo; add a royalty-free file with that name. Without it the player shows "This audio can't be played right now" with a retry button.

Manual test on a real device (cannot be covered by unit tests):

1. Add `assets/audio/sample.mp3`, run `flutter run` on a phone, open a free meditation, tap **Start**.
2. Press play. The ring fills and the breathing circle moves.
3. Lock the screen. Audio keeps playing; the lock screen shows title, narrator and play/pause, back 15 s and forward 15 s.
4. Pause from the lock screen or notification; the app (when reopened) shows the paused state. Play again from there.
5. Pull down the notification shade (Android) or open Control Center (iOS): same controls and title.
6. Switch to another app: audio continues.
7. Call the phone (or start another audio app): playback pauses and does not resume by itself.
8. Unplug wired headphones or disconnect Bluetooth while playing: playback pauses.
9. Skip back/forward 15 s from the app and from the lock screen.
10. Listen to the end: the "Session complete" sheet appears. Leave early (back arrow) before 80%: no sheet, the notification disappears.
11. Remove `sample.mp3` and open a meditation: the friendly error with retry appears.

## Conventions

- No hard-coded text: add strings to both `.arb` files.
- No hard-coded colours or font sizes in screens: use `Theme.of(context)` and the `core/theme` tokens.
- Language: a Turkish device opens in Turkish, anything else in English. The Profile tab selector overrides this and is saved.
- Content goes through `ContentRepository` (`features/content/domain`); the app only reads it via the providers in `content_providers.dart`. To change content, edit `assets/content/catalog.json` (both `en` and `tr`, no medical claims).
