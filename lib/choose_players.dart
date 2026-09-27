import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mafia/choose_roles.dart';

class ChoosePlayers extends StatefulWidget {
  const ChoosePlayers({super.key});

  @override
  State<ChoosePlayers> createState() => _ChoosePlayersState();
}

class _ChoosePlayersState extends State<ChoosePlayers> {
  final TextEditingController _players = TextEditingController();

  @override
  void dispose() {
    _players.dispose();
    super.dispose();
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _next() {
    final raw = _players.text.trim();

    if (raw.isEmpty) {
      _notify("Please enter the number of players.");
      return;
    }

    final count = int.tryParse(raw);
    if (count == null) {
      _notify("Please enter a valid number.");
      return;
    }
    if (count < 4) {
      _notify("You need at least 4 players to start a game.");
      return;
    }
    if (count > 30) {
      _notify("That's a lot of players — keep it to 30 or fewer.");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChooseRoles(num: count)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("PLAYERS")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                "How many players?",
                textAlign: TextAlign.center,
                style: text.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                "Minimum 4 : one of each role plus a villager.",
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: 160,
                child: TextField(
                  controller: _players,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _next(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              ElevatedButton(onPressed: _next, child: const Text('Next')),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
