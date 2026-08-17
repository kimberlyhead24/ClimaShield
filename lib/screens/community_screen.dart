import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../models/community.dart';
import '../theme.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<CommunityPost> _posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final posts = await ClimaRepository.instance.communityPosts();
    if (!mounted) return;
    setState(() {
      _posts = posts;
      _loading = false;
    });
  }

  Future<void> _newPost() async {
    final post = await showModalBottomSheet<CommunityPost>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _NewPostSheet(),
    );
    if (post != null) {
      setState(() => _posts = [post, ..._posts]);
    }
  }

  Future<void> _like(CommunityPost p) async {
    await ClimaRepository.instance.likePost(p.id);
    setState(() {
      _posts = _posts
          .map((q) => q.id == p.id ? q.copyWith(likes: q.likes + 1) : q)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClimaColors.bg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newPost,
        backgroundColor: ClimaColors.primary,
        foregroundColor: ClimaColors.ink,
        label: const Text('Share'),
        icon: const Icon(Icons.edit),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Community', style: ClimaText.headline),
            const SizedBox(height: 4),
            const Text(
              "Tips, wins, and questions from people doing the work.",
              style: ClimaText.muted,
            ),
            const SizedBox(height: 16),
            if (_loading) const LinearProgressIndicator(minHeight: 3),
            for (final p in _posts) _PostCard(post: p, onLike: () => _like(p)),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final CommunityPost post;
  final VoidCallback onLike;
  const _PostCard({required this.post, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ClimaColors.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: ClimaColors.surface,
                child: Text(
                  post.authorName.characters.first.toUpperCase(),
                  style: const TextStyle(color: ClimaColors.ink),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: ClimaText.title.copyWith(fontSize: 14),
                    ),
                    Text(_relative(post.createdAt), style: ClimaText.muted),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(post.body, style: ClimaText.body),
          if (post.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: [
                for (final t in post.tags)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: ClimaColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('#$t', style: ClimaText.muted),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton.icon(
                onPressed: onLike,
                icon: const Icon(Icons.favorite_border, size: 18),
                label: Text('${post.likes}'),
                style: TextButton.styleFrom(
                  foregroundColor: ClimaColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _relative(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}

class _NewPostSheet extends StatefulWidget {
  const _NewPostSheet();

  @override
  State<_NewPostSheet> createState() => _NewPostSheetState();
}

class _NewPostSheetState extends State<_NewPostSheet> {
  final _body = TextEditingController();
  final _name = TextEditingController();
  final _tags = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _body.dispose();
    _name.dispose();
    _tags.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_body.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final post = await ClimaRepository.instance.createPost(
      _body.text.trim(),
      authorName: _name.text.trim().isEmpty
          ? 'ClimaShield user'
          : _name.text.trim(),
      tags: _tags.text
          .split(',')
          .map((t) => t.trim().replaceAll('#', ''))
          .where((t) => t.isNotEmpty)
          .toList(),
    );
    if (!mounted) return;
    Navigator.pop(context, post);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ClimaColors.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Share with the community', style: ClimaText.title),
            const SizedBox(height: 12),
            TextField(
              controller: _name,
              decoration: climaInputDecoration('Display name (optional)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _body,
              maxLines: 4,
              decoration: climaInputDecoration("What's your climate update?"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tags,
              decoration: climaInputDecoration('Tags (comma-separated)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saving ? null : _submit,
              style: climaPrimaryButtonStyle(),
              child: Text(_saving ? 'Posting...' : 'Post'),
            ),
          ],
        ),
      ),
    );
  }
}
