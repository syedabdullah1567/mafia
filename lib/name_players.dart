import 'package:flutter/material.dart';
import 'package:mafia/choose_roles.dart';
import 'package:mafia/player_roles.dart';

class NamePlayers extends StatefulWidget {
  final int num;
  final RoleCounts counts;
  const NamePlayers({super.key, required this.num, required this.counts});

  @override
  State<NamePlayers> createState() => _NamePlayersState();
}

class _NamePlayersState extends State<NamePlayers> {
  late List<TextEditingController> _players;

  @override
  void initState() {
    super.initState();
    _players = List.generate(widget.num, (i) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _players) {
      controller.dispose();
    }
    super.dispose();
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _next() {
    final names = <String>[];

    for (var controller in _players) {
      final name = controller.text.trim();
      if (name.isEmpty) {
        _notify("Every player needs a name.");
        return;
      }
      names.add(name);
    }

    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PlayerRoles(names: names, num: widget.num, counts: widget.counts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("NAMES")),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
              child: Column(
                children: [
                  Text(
                    "Who's playing?",
                    textAlign: TextAlign.center,
                    style: text.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter a name for each of the ${widget.num} players.",
                    textAlign: TextAlign.center,
                    style: text.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 8),
                itemCount: widget.num,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return TextField(
                    controller: _players[index],
                    textCapitalization: TextCapitalization.words,
                    textInputAction: index == widget.num - 1
                        ? TextInputAction.done
                        : TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Player ${index + 1}",
                      // prefixIcon: Padding(
                      //   padding: const EdgeInsets.only(left: 16, right: 8),
                      //   child: Text(
                      //     '${index + 1}',
                      //     style: TextStyle(
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.w700,
                      //       color: scheme.onSurfaceVariant,
                      //     ),
                      //   ),
                      // ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
              child: ElevatedButton(
                onPressed: _next,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
