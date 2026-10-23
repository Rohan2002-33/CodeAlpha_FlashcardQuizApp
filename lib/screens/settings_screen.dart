import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/flashcard_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/confirm_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _reset(BuildContext context) async {
    final provider = context.read<FlashcardProvider>();
    final ok = await showConfirmDialog(
      context,
      title: 'Reset to sample cards?',
      message: 'All your cards will be replaced with the sample set.',
      confirmLabel: 'Reset',
    );
    if (!ok || !context.mounted) return;
    provider.resetToSamples();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Sample cards restored')));
  }

  Future<void> _deleteAll(BuildContext context) async {
    final provider = context.read<FlashcardProvider>();
    final ok = await showConfirmDialog(
      context,
      title: 'Delete all cards?',
      message: 'This cannot be undone.',
      confirmLabel: 'Delete all',
    );
    if (!ok || !context.mounted) return;
    provider.deleteAll();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('All cards deleted')));
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final cards = context.watch<FlashcardProvider>();
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const _SectionTitle('Appearance'),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto_outlined),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode_outlined),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode_outlined),
                ),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (s) => settings.setThemeMode(s.first),
            ),
          ),
          const SizedBox(height: 28),
          const _SectionTitle('Data'),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.restore_rounded),
            title: const Text('Reset to sample cards'),
            subtitle: Text('${cards.total} cards currently saved'),
            onTap: () => _reset(context),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_sweep_outlined, color: scheme.error),
            title: Text('Delete all cards',
                style: TextStyle(color: scheme.error)),
            enabled: cards.hasCards,
            onTap: () => _deleteAll(context),
          ),
          const SizedBox(height: 28),
          const _SectionTitle('About'),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('Flashcard Quiz'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Flashcard Quiz',
              applicationVersion: '1.0.0',
              applicationLegalese:
                  'Built for the CodeAlpha App Development Internship (Task 1).',
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}