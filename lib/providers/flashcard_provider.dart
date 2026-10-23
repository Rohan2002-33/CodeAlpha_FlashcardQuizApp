import 'package:flutter/foundation.dart';

import '../models/flashcard.dart';
import '../services/storage_service.dart';

class FlashcardProvider extends ChangeNotifier {
  FlashcardProvider(this._storage) {
    final saved = _storage.loadCards();
    if (saved == null) {
      _cards = _sampleCards();
      _persist();
    } else {
      _cards = saved;
    }
  }

  final StorageService _storage;

  List<Flashcard> _cards = [];
  int _index = 0;
  bool _showAnswer = false;

  Flashcard? _lastDeleted;
  int _lastDeletedIndex = 0;

  // ---------- getters ----------
  List<Flashcard> get cards => List.unmodifiable(_cards);
  int get total => _cards.length;
  bool get hasCards => _cards.isNotEmpty;
  int get currentIndex => _index;
  bool get showAnswer => _showAnswer;
  Flashcard? get currentCard => _cards.isEmpty ? null : _cards[_index];
  bool get canGoNext => _index < _cards.length - 1;
  bool get canGoPrevious => _index > 0;
  double get progress => _cards.isEmpty ? 0 : (_index + 1) / _cards.length;

  List<Flashcard> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return cards;
    return _cards
        .where(
          (c) =>
              c.question.toLowerCase().contains(q) ||
              c.answer.toLowerCase().contains(q),
        )
        .toList();
  }

  // ---------- study actions ----------
  void toggleAnswer() {
    if (!hasCards) return;
    _showAnswer = !_showAnswer;
    notifyListeners();
  }

  void next() {
    if (!canGoNext) return;
    _index++;
    _showAnswer = false;
    notifyListeners();
  }

  void previous() {
    if (!canGoPrevious) return;
    _index--;
    _showAnswer = false;
    notifyListeners();
  }

  void restart() {
    _index = 0;
    _showAnswer = false;
    notifyListeners();
  }

  // ---------- CRUD ----------
  void add(String question, String answer) {
    _cards.add(
      Flashcard(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        question: question,
        answer: answer,
        createdAt: DateTime.now(),
      ),
    );
    _persist();
    notifyListeners();
  }

  void update(String id, String question, String answer) {
    final i = _cards.indexWhere((c) => c.id == id);
    if (i == -1) return;
    _cards[i] = _cards[i].copyWith(question: question, answer: answer);
    _persist();
    notifyListeners();
  }

  void delete(String id) {
    final i = _cards.indexWhere((c) => c.id == id);
    if (i == -1) return;
    _lastDeleted = _cards.removeAt(i);
    _lastDeletedIndex = i;
    _fixIndex();
    _persist();
    notifyListeners();
  }

  void undoDelete() {
    final card = _lastDeleted;
    if (card == null) return;
    final at = _lastDeletedIndex.clamp(0, _cards.length);
    _cards.insert(at, card);
    _lastDeleted = null;
    _persist();
    notifyListeners();
  }

  void deleteAll() {
    _cards = [];
    _index = 0;
    _showAnswer = false;
    _lastDeleted = null;
    _persist();
    notifyListeners();
  }

  void resetToSamples() {
    _cards = _sampleCards();
    _index = 0;
    _showAnswer = false;
    _lastDeleted = null;
    _persist();
    notifyListeners();
  }

  // ---------- helpers ----------
  void _fixIndex() {
    _showAnswer = false;
    if (_cards.isEmpty) {
      _index = 0;
    } else if (_index > _cards.length - 1) {
      _index = _cards.length - 1;
    }
  }

  void _persist() {
    _storage.saveCards(_cards);
  }

  static List<Flashcard> _sampleCards() {
    const data = [
      (
        'What is a Widget in Flutter?',
        'The basic building block of a Flutter UI. Everything on screen is a widget.',
      ),
      (
        'StatelessWidget vs StatefulWidget?',
        'Stateless never changes after build. Stateful holds state and can rebuild when setState is called.',
      ),
      (
        'What does setState() do?',
        'Tells Flutter the state changed, so it rebuilds the widget to show new values.',
      ),
      (
        'What is hot reload?',
        'Injects updated code into the running app in about a second, keeping current state.',
      ),
      ('Which file lists packages and assets?', 'pubspec.yaml'),
      (
        'What is the purpose of BuildContext?',
        'A handle to a widget\'s location in the tree. Used to find themes, navigators and providers.',
      ),
      (
        'What is a Future in Dart?',
        'An object representing a value that will be available later, from an async operation.',
      ),
      (
        'What does the Navigator do?',
        'Manages a stack of screens (routes). push adds a screen, pop removes the top one.',
      ),
    ];
    final now = DateTime.now();
    return [
      for (var i = 0; i < data.length; i++)
        Flashcard(
          id: 'sample_$i',
          question: data[i].$1,
          answer: data[i].$2,
          createdAt: now,
        ),
    ];
  }
}
