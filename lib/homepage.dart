import 'package:flutter/material.dart';
import 'package:mafia/choose_players.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void _showHowToPlay() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final text = Theme.of(context).textTheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("How to Play", style: text.headlineMedium),
                  const SizedBox(height: 16),
                  Text(
                    "1. Pick the number of players, then how many mafias, "
                    "doctors, detectives and villagers are in the game.\n\n"
                    "2. Enter everyone's name and pass the phone around. Each "
                    "player taps their own name to see their secret role; "
                    "a role can only be viewed once.\n\n"
                    "3. Play the night and day rounds out loud. Use Next Round "
                    "to reshuffle roles for a fresh game with the same lineup.\n\n"
                    "4. The mafias open their eyes when called upon, to kill a person of their choice.\n\n"
                    "5. The doctors open their eyes when called upon to save a person of their choice. Even themselves, "
                    "but they can't save themselves twice in a row.\n\n"
                    "6. The detectives open their eyes when called upon to investigate a person of their choice. "
                    "If their guess is correct the narrator holds out a M, if incorrect the narrator holds out a V.\n\n",
                    style: text.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Text(
                "MAFIA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 10,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "PASS AND PLAY",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 5,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const Spacer(flex: 4),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChoosePlayers(),
                    ),
                  );
                },
                child: const Text('Start Game'),
              ),
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: _showHowToPlay,
                child: const Text('How to Play'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
