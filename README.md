# Yoga App in Flutter
Flutter app for custom yoga classes with workout player

## Run the project
```bash
$ git clone git@github.com:Stmol/yoga_app_flutter.git
$ flutter pub get
$ flutter run
```

## Architecture
- State management: **Flutter MobX**
- DI: **Provider**
- **MVVM**: MobX Stores as MV
- Storage: JSON in SharedPreferences

## iOS and Android layout
It uses flex layout to fit different screen sizes

## Localization
Data set (asanas, classrooms) contains only russian language