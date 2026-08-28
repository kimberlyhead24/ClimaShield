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

  CommunityPost copyWith({
    String? id,
    int? likes,
  }) { 
    return CommunityPost(
      id: id ?? this.id,
      authorName: authorName,
      authorId: authorId,
      body: body,
      createdAt: createdAt,
      likes: likes ?? this.likes,
      tags: tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorName': authorName,
      'authorId': authorId,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'tags': tags,
    };
  }

  factory CommunityPost.fromMap(
    Map<String, dynamic> map, {
      required String id,
  }) {
    return CommunityPost(
      id: id,
      authorName: map['authorName'] as String? ?? 'Anonymous',
      authorId: map['authorId'] as String?,
      body: map['body'] as String? ?? '',
      createdAt:
        DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      likes: (map['likes'] as num?)?.toInt() ?? 0,
      tags: (map['tags'] as List?)?.cast<String>() ?? const [],
    );
  }
}
