import 'package:flutter/material.dart';
import 'package:mafia/name_players.dart';

/// The role line-up chosen for a game.
class RoleCounts {
  final int mafia;
  final int doctor;
  final int detective;
  final int villager;

  const RoleCounts({
    required this.mafia,
    required this.doctor,
    required this.detective,
    required this.villager,
  });

  int get total => mafia + doctor + detective + villager;

  /// Flat list of role names, one entry per player (unshuffled).
  List<String> toRoleList() => <String>[
    ...List.filled(mafia, 'Mafia'),
    ...List.filled(doctor, 'Doctor'),
    ...List.filled(detective, 'Detective'),
    ...List.filled(villager, 'Villager'),
  ];
}

class ChooseRoles extends StatefulWidget {
  final int num;
  const ChooseRoles({super.key, required this.num});

  @override
  State<ChooseRoles> createState() => _ChooseRolesState();
}

class _ChooseRolesState extends State<ChooseRoles> {
  static const int _minPerRole = 1;

  late int _mafia;
  late int _doctor;
  late int _detective;
  late int _villager;

  @override
  void initState() {
    super.initState();
    _mafia = 1;
    _doctor = 1;
    _detective = 1;
    // widget.num is guaranteed to be >= 4 by the previous page.
    _villager = widget.num - 3;
  }

  int get _total => _mafia + _doctor + _detective + _villager;
  int get _remaining => widget.num - _total;
  bool get _isValid => _total == widget.num;

  void _change(String role, int delta) {
    if (delta > 0 && _remaining <= 0) return;

    setState(() {
      switch (role) {
        case 'Mafia':
          if (_mafia + delta >= _minPerRole) _mafia += delta;
          break;
        case 'Doctor':
          if (_doctor + delta >= _minPerRole) _doctor += delta;
          break;
        case 'Detective':
          if (_detective + delta >= _minPerRole) _detective += delta;
          break;
        case 'Villager':
          if (_villager + delta >= _minPerRole) _villager += delta;
          break;
      }
    });
  }

  void _next() {
    if (!_isValid) return;

    final counts = RoleCounts(
      mafia: _mafia,
      doctor: _doctor,
      detective: _detective,
      villager: _villager,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NamePlayers(num: widget.num, counts: counts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("ROLES")),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
              child: Column(
                children: [
                  Text(
                    "Build the line-up",
                    textAlign: TextAlign.center,
                    style: text.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isValid
                        ? "All $_total roles assigned."
                        : "$_total of ${widget.num} assigned — "
                              "$_remaining left to place.",
                    textAlign: TextAlign.center,
                    style: text.bodyMedium?.copyWith(
                      color: _isValid ? scheme.primary : scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 8),
                children: [
                  _CounterRow(
                    label: "Mafias",
                    value: _mafia,
                    accent: const Color(0xFFE05260),
                    canDecrease: _mafia > _minPerRole,
                    canIncrease: _remaining > 0,
                    onChange: (d) => _change('Mafia', d),
                  ),
                  _CounterRow(
                    label: "Doctors",
                    value: _doctor,
                    accent: const Color(0xFF5FB3A1),
                    canDecrease: _doctor > _minPerRole,
                    canIncrease: _remaining > 0,
                    onChange: (d) => _change('Doctor', d),
                  ),
                  _CounterRow(
                    label: "Detectives",
                    value: _detective,
                    accent: const Color(0xFF7D9CD8),
                    canDecrease: _detective > _minPerRole,
                    canIncrease: _remaining > 0,
                    onChange: (d) => _change('Detective', d),
                  ),
                  _CounterRow(
                    label: "Villagers",
                    value: _villager,
                    accent: const Color(0xFFC9A66B),
                    canDecrease: _villager > _minPerRole,
                    canIncrease: _remaining > 0,
                    onChange: (d) => _change('Villager', d),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
              child: ElevatedButton(
                onPressed: _isValid ? _next : null,
                child: Text(
                  _isValid ? 'Next' : 'Assign all ${widget.num} players',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final int value;
  final Color accent;
  final bool canDecrease;
  final bool canIncrease;
  final ValueChanged<int> onChange;

  const _CounterRow({
    required this.label,
    required this.value,
    required this.accent,
    required this.canDecrease,
    required this.canIncrease,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          _StepButton(
            icon: Icons.remove_rounded,
            enabled: canDecrease,
            onTap: () => onChange(-1),
          ),
          SizedBox(
            width: 44,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            enabled: canIncrease,
            onTap: () => onChange(1),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: enabled ? onTap : null,
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: enabled
            ? scheme.primary.withOpacity(0.16)
            : scheme.surfaceContainerHighest.withOpacity(0.3),
        foregroundColor: enabled ? scheme.onSurface : scheme.onSurfaceVariant,
        disabledForegroundColor: scheme.onSurfaceVariant.withOpacity(0.35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(40, 40),
      ),
    );
  }
}
