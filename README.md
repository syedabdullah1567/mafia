# Mafia — Party Role Dealer

A simple offline Android app for playing the party game **Mafia** with a single phone. Set up your player count, pick the role line-up, name your friends, and pass the phone around — each player flips their card privately to learn their secret role.

No accounts, no server, no internet needed. Everything happens on one device.

## Game flow

```
main.dart
   └── homepage.dart          — start screen, pick number of players (4–20)
         └── choose_roles.dart — set mafia / doctor / detective / villager counts
               └── name_players.dart — enter each player's name
                     └── player_roles.dart — pass-around secret role cards
```

1. **Choose players** — select how many people are playing (minimum 4).
2. **Build the line-up** — use the +/− counters to decide how many Mafia, Doctors, Detectives and Villagers are in the game. Every role must be placed before continuing.
3. **Name the players** — type a name for each seat. Duplicate names are rejected so cards stay unambiguous.
4. **Secret roles** — roles are shuffled and dealt. Each player taps their own card, gets one private look at their role with a short reminder of what it does, then seals it as *Viewed*. Only one card can be open at a time, and the button stays disabled until everyone has looked.
5. **Next Round** — once all cards are viewed, reshuffle and start a fresh game.

## Roles

| Role | What it does |
| --- | --- |
| Mafia | Eliminates a player each night. Stays unsuspected by day. |
| Doctor | Chooses one player to save each night. |
| Detective | Investigates one player each night to learn their side. |
| Villager | No night power. Votes wisely and finds the mafia. |

## Features

- Role counters with live validation — you can't continue until all players have a role
- Private one-look flip cards with 3D flip animation and per-role accent colours
- One card open at a time, so nobody peeks at a neighbour's role
- Duplicate-name check on the naming screen
- Reshuffle with a single tap for back-to-back rounds
- Dark theme throughout, with high-refresh-rate support on Android

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x)
- Android SDK / an Android device or emulator

### Install & run

```sh
git clone <your-repo-url>
cd mafia
flutter pub get
flutter run
```

### Build a release APK

```sh
flutter build apk --release
```

The APK lands in `build/app/outputs/flutter-apk/app-release.apk`.

## Project structure

```
lib/
├── main.dart            # App entry, dark theme definition
├── homepage.dart        # Start screen & player count picker
├── choose_roles.dart    # Role line-up counters (RoleCounts model lives here)
├── name_players.dart    # Player name entry
└── player_roles.dart    # Secret role flip cards & reshuffle
```

## Dependencies

- [flutter_displaymode](https://pub.dev/packages/flutter_displaymode) — enables high refresh rate on supported Android devices

## License

This project is for personal / educational use. Add a license of your choice if you plan to publish it.
