# ohio_chat_app

A new Flutter templates.

## Guide

### Easy Localization
Run locale file gen:

```bash
# flutter pub run easy_localization:generate -S assets/translations
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart -S assets/translations
```

### Assets gen

```bash
flutter pub run build_runner build
```