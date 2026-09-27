import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mafia/choose_roles.dart';

enum _CardState { hidden, open, locked }

class PlayerRoles extends StatefulWidget {
  final List<String> names;
  final int num;
  final RoleCounts counts;

  const PlayerRoles({
    super.key,
    required this.names,
    required this.num,
    required this.counts,
  });

  @override
  State<PlayerRoles> createState() => _PlayerRolesState();
}

class _PlayerRolesState extends State<PlayerRoles> {
  late List<String> _assignedRoles;
  late List<_CardState> _states;

  @override
  void initState() {
    super.initState();
    _assignRandomRoles();
  }

  void _assignRandomRoles() {
    final roles = widget.counts.toRoleList();

    // Safety net: if the counts and player count ever drift apart, pad or trim.
    while (roles.length < widget.num) {
      roles.add('Villager');
    }
    if (roles.length > widget.num) {
      roles.removeRange(widget.num, roles.length);
    }

    roles.shuffle(Random());
    _assignedRoles = roles;
    _states = List.filled(widget.num, _CardState.hidden);
  }

  bool get _anyOpen => _states.contains(_CardState.open);
  bool get _allViewed => _states.every((s) => s == _CardState.locked);

  void _reveal(int index) {
    if (_anyOpen || _states[index] != _CardState.hidden) return;
    setState(() => _states[index] = _CardState.open);
  }

  void _lock(int index) {
    setState(() => _states[index] = _CardState.locked);
  }

  void _nextRound() {
    setState(_assignRandomRoles);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text("Roles reshuffled — pass the phone around."),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final viewed = _states.where((s) => s == _CardState.locked).length;

    return Scaffold(
      appBar: AppBar(title: const Text("SECRET ROLES")),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
              child: Column(
                children: [
                  Text(
                    _allViewed ? "Everyone knows their role" : "Tap your name",
                    textAlign: TextAlign.center,
                    style: text.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _anyOpen
                        ? "Read it, then tap Done. One look only."
                        : _allViewed
                        ? "Start the night. Reshuffle when you want a new game."
                        : "$viewed of ${widget.num} players have seen their role.",
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
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return _RoleCard(
                    name: widget.names[index],
                    role: _assignedRoles[index],
                    state: _states[index],
                    blocked: _anyOpen && _states[index] != _CardState.open,
                    onReveal: () => _reveal(index),
                    onDone: () => _lock(index),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
              child: ElevatedButton(
                onPressed: _allViewed ? _nextRound : null,
                child: Text(
                  _allViewed
                      ? 'Next Round'
                      : 'Waiting for ${widget.num - viewed} player(s)',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String name;
  final String role;
  final _CardState state;
  final bool blocked;
  final VoidCallback onReveal;
  final VoidCallback onDone;

  const _RoleCard({
    required this.name,
    required this.role,
    required this.state,
    required this.blocked,
    required this.onReveal,
    required this.onDone,
  });

  static const Map<String, Color> _accents = {
    'Mafia': Color(0xFFE05260),
    'Doctor': Color(0xFF5FB3A1),
    'Detective': Color(0xFF7D9CD8),
    'Villager': Color(0xFFC9A66B),
  };

  static const Map<String, IconData> _icons = {
    'Mafia': Icons.local_fire_department_rounded,
    'Doctor': Icons.medical_services_rounded,
    'Detective': Icons.travel_explore_rounded,
    'Villager': Icons.home_rounded,
  };

  static const Map<String, String> _blurbs = {
    'Mafia': "Eliminate a player each night. Stay unsuspected by day.",
    'Doctor': "Choose one player to save each night.",
    'Detective': "Investigate one player each night to learn their side.",
    'Villager': "No night power. Vote wisely and find the mafia.",
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isOpen = state == _CardState.open;
    final accent = _accents[role] ?? scheme.primary;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: blocked ? 0.35 : 1,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: isOpen ? 1 : 0),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
        builder: (context, t, _) {
          final angle = t * pi;
          final showBack = t > 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            child: showBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _back(context, accent),
                  )
                : _front(context, scheme),
          );
        },
      ),
    );
  }

  Widget _front(BuildContext context, ColorScheme scheme) {
    final locked = state == _CardState.locked;

    return InkWell(
      onTap: locked || blocked ? null : onReveal,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 84,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: locked
              ? scheme.surfaceContainerHighest.withOpacity(0.18)
              : scheme.surfaceContainerHighest.withOpacity(0.38),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: locked
                ? scheme.outlineVariant.withOpacity(0.4)
                : scheme.primary.withOpacity(0.45),
          ),
        ),
        child: Row(
          children: [
            Icon(
              locked ? Icons.lock_rounded : Icons.visibility_off_rounded,
              size: 20,
              color: locked ? scheme.onSurfaceVariant : scheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: locked
                          ? scheme.onSurfaceVariant
                          : scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    locked ? "Viewed" : "Tap to reveal",
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _back(BuildContext context, Color accent) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(0.7), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icons[role] ?? Icons.person_rounded, color: accent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  role.toUpperCase(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _blurbs[role] ?? "",
            style: TextStyle(
              fontSize: 14,
              height: 1.35,
              color: scheme.onSurface.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 46),
                backgroundColor: accent,
                foregroundColor: Colors.black,
              ),
              child: Text('I have memorized my role'),
            ),
          ),
        ],
      ),
    );
  }
}
