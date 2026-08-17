import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_auth_service.dart';
import '../theme.dart';
import 'actions_screen.dart';
import 'community_screen.dart';
import 'dashboard_screen.dart';
import 'diet_onboarding_gate.dart';
import 'welcome_screen.dart';

/// Top-level navigation host. Bottom-nav with five primary destinations.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;

  // Note: MoreScreen removed; we only keep the 4 main tabs.
  final List<Widget> _pages = const [
    DashboardScreen(),
    ActionsScreen(),
    DietOnboardingGate(),
    CommunityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ClimaColors.bg,
      body: SafeArea(child: _pages[_index]),
      // Right-side drawer that behaves like your "More" panel.
      endDrawer: const _MoreDrawer(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          // When "More" (index 4) is tapped, open the end drawer instead of navigating.
          if (i == 4) {
            _scaffoldKey.currentState?.openEndDrawer();
            return;
          }
          setState(() => _index = i);
        },
        backgroundColor: Colors.white,
        indicatorColor: ClimaColors.primary.withValues(alpha: 0.45),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.eco_outlined),
            selectedIcon: Icon(Icons.eco),
            label: 'Actions',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant),
            label: 'Diet',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            selectedIcon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

/// The side drawer that replaces MoreScreen.
class _MoreDrawer extends StatelessWidget {
  const _MoreDrawer();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.75;
    final authService = FirebaseAuthService();

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: width, // 75% of screen width; left 25% is tap-to-dismiss area.
        child: Drawer(
          child: SafeArea(
            child: StreamBuilder<User?>(
              stream: authService.authStateChanges,
              builder: (context, snapshot) {
                final User? user = snapshot.data;
                final bool isLoggedIn = user != null;

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if (isLoggedIn)
                      _LoggedInDrawerHeader(user: user)
                    else
                      const _SignInBanner(),
                    const Divider(height: 1),

                    // You can add more "More" options below as ListTiles if needed.
                    if (isLoggedIn)
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Sign out',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () async {
                          await FirebaseAuthService().signOut();
                          if (!context.mounted) return;

                          // Close the drawer first
                          Navigator.of(context).pop();

                          // Clear stack and go to WelcomeScreen
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const WelcomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Logged-in header ported from MoreScreen, adapted for drawer.
class _LoggedInDrawerHeader extends StatelessWidget {
  final User user;
  const _LoggedInDrawerHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (context, snap) {
        String displayName = user.email ?? 'User';

        if (snap.hasData && snap.data!.exists) {
          final data = snap.data!.data() as Map<String, dynamic>;
          final firestoreName = (data['name'] as String?) ?? '';
          if (firestoreName.isNotEmpty) {
            displayName = firestoreName;
          } else if ((user.displayName ?? '').isNotEmpty) {
            displayName = user.displayName!;
          }
        } else if ((user.displayName ?? '').isNotEmpty) {
          displayName = user.displayName!;
        }

        final String initial = displayName.isNotEmpty
            ? displayName[0].toUpperCase()
            : '?';

        final Widget avatar = CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF4CAF50),
          child: user.photoURL != null
              ? ClipOval(
                  child: Image.network(
                    user.photoURL!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                )
              : Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              avatar,
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (user.email != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        user.email!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuthService().signOut();
                  if (!context.mounted) return;

                  // Close drawer
                  Navigator.of(context).pop();

                  // Clear stack and go to WelcomeScreen
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  'Sign out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Same sign-in banner UI, reused in the drawer.
class _SignInBanner extends StatelessWidget {
  const _SignInBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close drawer first so you don't have a drawer behind the WelcomeScreen.
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF4CAF50), width: 1),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 44,
              color: Color(0xFF4CAF50),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign in to ClimaShield',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Track your impact and save your preferences.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
