import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/flashcard_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/flip_card.dart';
import 'card_form_screen.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlashcardProvider>();
    final card = provider.currentCard;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final buttonShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study'),
        actions: [
          if (provider.hasCards)
            IconButton(
              tooltip: 'Back to first card',
              icon: const Icon(Icons.restart_alt_rounded),
              onPressed: provider.restart,
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: card == null
          ? EmptyState(
              icon: Icons.style_outlined,
              title: 'No flashcards yet',
              message: 'Create your first flashcard to start studying.',
              actionLabel: 'Add flashcard',
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CardFormScreen()),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Card ${provider.currentIndex + 1} of ${provider.total}',
                          style: textTheme.titleSmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        const Spacer(),
                        Text(
                          '${(provider.progress * 100).round()}%',
                          style: textTheme.titleSmall?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: provider.progress,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: FlipCard(
                        key: ValueKey(card.id),
                        showBack: provider.showAnswer,
                        onTap: provider.toggleAnswer,
                        front: _CardFace(
                          label: 'QUESTION',
                          icon: Icons.help_outline_rounded,
                          text: card.question,
                          hint: 'Tap card to flip',
                          foreground: scheme.onPrimary,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [scheme.primary, scheme.tertiary],
                            ),
                            boxShadow: _shadow,
                          ),
                        ),
                        back: _CardFace(
                          label: 'ANSWER',
                          icon: Icons.lightbulb_outline_rounded,
                          text: card.answer,
                          hint: 'Tap card to flip back',
                          foreground: scheme.onSurface,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: scheme.surfaceContainerHighest,
                            border: Border.all(color: scheme.outlineVariant),
                            boxShadow: _shadow,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: provider.toggleAnswer,
                      icon: Icon(provider.showAnswer
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      label: Text(
                          provider.showAnswer ? 'Hide Answer' : 'Show Answer'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: buttonShape,
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed:
                                provider.canGoPrevious ? provider.previous : null,
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Previous'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              shape: buttonShape,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: provider.canGoNext ? provider.next : null,
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text('Next'),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              shape: buttonShape,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  static final List<BoxShadow> _shadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}

class _CardFace extends StatelessWidget {
  const _CardFace({
    required this.label,
    required this.icon,
    required this.text,
    required this.hint,
    required this.foreground,
    required this.decoration,
  });

  final String label;
  final IconData icon;
  final String text;
  final String hint;
  final Color foreground;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: decoration,
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: foreground.withValues(alpha: 0.8)),
              const SizedBox(width: 8),
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: foreground.withValues(alpha: 0.8),
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ),
          Text(
            hint,
            style: textTheme.bodySmall
                ?.copyWith(color: foreground.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}