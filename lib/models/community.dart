class CommunityPost {
  final String id;
  final String authorName;
  final String? authorId;
  final String body;
  final DateTime createdAt;
  final int likes;
  final List<String> tags;

  const CommunityPost({
    required this.id,
    required this.authorName,
    this.authorId,
    required this.body,
    required this.createdAt,
    this.likes = 0,
    this.tags = const [],
  });

  CommunityPost copyWith({int? likes}) => CommunityPost(
        id: id,
        authorName: authorName,
        authorId: authorId,
        body: body,
        createdAt: createdAt,
        likes: likes ?? this.likes,
        tags: tags,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'authorName': authorName,
        'authorId': authorId,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
        'likes': likes,
        'tags': tags,
      };

  factory CommunityPost.fromMap(Map<String, dynamic> m) => CommunityPost(
        id: m['id'] as String,
        authorName: m['authorName'] as String? ?? 'Anonymous',
        authorId: m['authorId'] as String?,
        body: m['body'] as String? ?? '',
        createdAt: DateTime.tryParse(m['createdAt'] as String? ?? '') ??
            DateTime.now(),
        likes: (m['likes'] as num?)?.toInt() ?? 0,
        tags: (m['tags'] as List?)?.cast<String>() ?? const [],
      );
}

class Petition {
  final String id;
  final String title;
  final String summary;
  final String target;
  final int signatureGoal;
  final int signatureCount;
  final String? sourceUrl;
  final List<String> tags;

  const Petition({
    required this.id,
    required this.title,
    required this.summary,
    required this.target,
    required this.signatureGoal,
    this.signatureCount = 0,
    this.sourceUrl,
    this.tags = const [],
  });

  double get progress =>
      signatureGoal == 0 ? 0 : (signatureCount / signatureGoal).clamp(0, 1);

  Petition copyWith({int? signatureCount}) => Petition(
        id: id,
        title: title,
        summary: summary,
        target: target,
        signatureGoal: signatureGoal,
        signatureCount: signatureCount ?? this.signatureCount,
        sourceUrl: sourceUrl,
        tags: tags,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'summary': summary,
        'target': target,
        'signatureGoal': signatureGoal,
        'signatureCount': signatureCount,
        'sourceUrl': sourceUrl,
        'tags': tags,
      };

  factory Petition.fromMap(Map<String, dynamic> m) => Petition(
        id: m['id'] as String,
        title: m['title'] as String? ?? '',
        summary: m['summary'] as String? ?? '',
        target: m['target'] as String? ?? '',
        signatureGoal: (m['signatureGoal'] as num?)?.toInt() ?? 0,
        signatureCount: (m['signatureCount'] as num?)?.toInt() ?? 0,
        sourceUrl: m['sourceUrl'] as String?,
        tags: (m['tags'] as List?)?.cast<String>() ?? const [],
      );
}
