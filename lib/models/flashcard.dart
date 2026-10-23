import 'dart:convert';

class Flashcard {
  const Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
  });

  final String id;
  final String question;
  final String answer;
  final DateTime createdAt;

  Flashcard copyWith({String? question, String? answer}) {
    return Flashcard(
      id: id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'question': question,
    'answer': answer,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'] as String,
      question: map['question'] as String,
      answer: map['answer'] as String,
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  static String encodeList(List<Flashcard> cards) =>
      jsonEncode(cards.map((c) => c.toMap()).toList());

  static List<Flashcard> decodeList(String source) {
    final data = jsonDecode(source) as List<dynamic>;
    return data
        .map((e) => Flashcard.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
