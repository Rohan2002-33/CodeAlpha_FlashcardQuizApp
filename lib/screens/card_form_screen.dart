import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/flashcard.dart';
import '../providers/flashcard_provider.dart';

/// Used for both adding a new card and editing an existing one.
class CardFormScreen extends StatefulWidget {
  const CardFormScreen({super.key, this.card});

  final Flashcard? card;

  @override
  State<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends State<CardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _question = TextEditingController(
    text: widget.card?.question,
  );
  late final TextEditingController _answer = TextEditingController(
    text: widget.card?.answer,
  );

  bool get _isEditing => widget.card != null;

  @override
  void dispose() {
    _question.dispose();
    _answer.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final provider = context.read<FlashcardProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final question = _question.text.trim();
    final answer = _answer.text.trim();

    if (_isEditing) {
      provider.update(widget.card!.id, question, answer);
    } else {
      provider.add(question, answer);
    }

    Navigator.of(context).pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Card updated' : 'Card added')),
      );
  }

  InputDecoration _decoration(String label, String hint) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(14);
    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint: true,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.error, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit card' : 'New card'),
        actions: [
          TextButton(onPressed: _save, child: const Text('Save')),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              TextFormField(
                controller: _question,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 200,
                minLines: 2,
                maxLines: 4,
                decoration: _decoration(
                  'Question',
                  'e.g. What is a Widget in Flutter?',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter a question'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _answer,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 500,
                minLines: 4,
                maxLines: 8,
                decoration: _decoration('Answer', 'Write the answer here'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter an answer'
                    : null,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_rounded),
                label: Text(_isEditing ? 'Save changes' : 'Add flashcard'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
