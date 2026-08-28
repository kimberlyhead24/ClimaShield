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
    createdAt:
        DateTime.tryParse(m['createdAt'] as String? ?? '') ?? DateTime.now(),
    likes: (m['likes'] as num?)?.toInt() ?? 0,
    tags: (m['tags'] as List?)?.cast<String>() ?? const [],
  );
}



