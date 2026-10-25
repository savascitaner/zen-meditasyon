# Zen

Calm, minimal meditation, yoga and stress-management app (Flutter, iOS + Android).
Languages: English and Turkish. Dark theme only (MVP).

## Run

```sh
flutter pub get   # also generates lib/l10n/app_localizations*.dart
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
    ├── onboarding/  auth/  player/  subscription/   # empty, for later tasks
assets/{images,audio}/
test/                         # app_smoke_test, theme contrast test
```

## Conventions

- No hard-coded text: add strings to both `.arb` files.
- No hard-coded colours or font sizes in screens: use `Theme.of(context)` and the `core/theme` tokens.
- Language: a Turkish device opens in Turkish, anything else in English. The Profile tab selector overrides this and is saved.
