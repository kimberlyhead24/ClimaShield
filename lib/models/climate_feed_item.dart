import 'package:cloud_firestore/cloud_firestore.dart';

enum ClimateFeedType { news, technology, learning }

class ClimateFeedItem {
  final String id;
  final String title;
  final String summary;
  final String sourceName;
  final String sourceUrl;
  final String? imageUrl;
  final ClimateFeedType type;
  final List<String> tags;
  final DateTime publishedAt;
  final bool isFeatured;

  const ClimateFeedItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.sourceName,
    required this.sourceUrl,
    this.imageUrl,
    required this.type,
    this.tags = const [],
    required this.publishedAt,
    this.isFeatured = false,
  });

  factory ClimateFeedItem.fromMap(
    Map<String, dynamic> map, {
    required String id,
  }) {
    return ClimateFeedItem(
      id: id,
      title: map['title'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      sourceName: map['sourceName'] as String? ?? '',
      sourceUrl: map['sourceUrl'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
      type: _typeFromValue(map['contentType'] as String?),
      tags: List<String>.from(map['tags'] as List? ?? const []),
      publishedAt: _dateFromValue(map['publishedAt']) ?? DateTime.now(),
      isFeatured: map['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'summary': summary,
      'sourceName': sourceName,
      'sourceUrl': sourceUrl,
      'imageUrl': imageUrl,
      'contentType': type.name,
      'tags': tags,
      'publishedAt': publishedAt,
      'isFeatured': isFeatured,
    };
  }

  static ClimateFeedType _typeFromValue(String? value) {
    return switch (value) {
      'technology' => ClimateFeedType.technology,
      'learning' => ClimateFeedType.learning,
      _ => ClimateFeedType.news,
    };
  }

  static DateTime? _dateFromValue(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
