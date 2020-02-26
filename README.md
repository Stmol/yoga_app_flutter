# Yoga App in Flutter
Flutter app for custom yoga classes with workout player

<img width=300 src="https://raw.githubusercontent.com/Stmol/yoga_app_flutter/develop/.readme_assets/video/intro_500.gif">
<img width=300 src="https://raw.githubusercontent.com/Stmol/yoga_app_flutter/develop/.readme_assets/video/player_500.gif">


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

<img width=600 src="https://raw.githubusercontent.com/Stmol/yoga_app_flutter/develop/.readme_assets/shots/flex_layout.png">

## Localization
Data set (asanas, classrooms) contains only russian language

## Misc

MIT License, enjoy!

Feedback is welcome!