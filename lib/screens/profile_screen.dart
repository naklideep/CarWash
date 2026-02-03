import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../utils/app_theme.dart';
import 'login_screen.dart';
import 'admin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();

  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  // ✅ SAFE INITIAL (NO RANGE ERROR EVER)
  String _getInitial(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'U';
    }
    return value.trim().substring(0, 1).toUpperCase();
  }

  Future<void> _checkAdminStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final isAdmin = await _firestoreService.isUserAdmin(user.uid);
      if (mounted) {
        setState(() {
          _isAdmin = isAdmin;
          _isLoading = false;
        });
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            onPressed: () async {
              await _authService.signOut();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                      (route) => false,
                );
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view profile')),
      );
    }

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= PROFILE HEADER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getInitial(user.displayName),
                          style: AppTheme.heading1.copyWith(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.displayName?.isNotEmpty == true
                          ? user.displayName!
                          : 'User',
                      style: AppTheme.heading2.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email ?? '',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= PROFILE OPTIONS =================
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // -------- ADMIN PANEL --------
                    if (_isAdmin) ...[
                      _ProfileOption(
                        icon: Icons.admin_panel_settings,
                        title: 'Admin Panel',
                        subtitle: 'Manage appointments and services',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const AdminScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                    ],

                    // -------- USER INFO --------
                    FutureBuilder<Map<String, dynamic>?>(
                      future: _authService.getUserData(user.uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final userData = snapshot.data!;
                        return Column(
                          children: [
                            _ProfileInfoCard(
                              icon: Icons.person,
                              label: 'Name',
                              value: userData['name'] ?? 'N/A',
                            ),
                            const SizedBox(height: 12),
                            _ProfileInfoCard(
                              icon: Icons.email,
                              label: 'Email',
                              value: userData['email'] ?? 'N/A',
                            ),
                            const SizedBox(height: 12),
                            _ProfileInfoCard(
                              icon: Icons.phone,
                              label: 'Phone',
                              value: userData['phone'] ?? 'N/A',
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // -------- ABOUT --------
                    _ProfileOption(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle:
                      'Learn more about ${AppConstants.appName}',
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: AppConstants.appName,
                          applicationVersion: '1.0.0',
                          applicationIcon: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient:
                              AppTheme.primaryGradient,
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.local_car_wash,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          children: const [
                            Text(
                              'Premium car washing and ceramic coating services.',
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // -------- HELP --------
                    _ProfileOption(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get help with your bookings',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title:
                            const Text('Help & Support'),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text('Contact us:'),
                                SizedBox(height: 8),
                                Text('📧 support@carcarepro.com'),
                                SizedBox(height: 4),
                                Text('📱 +91 9876543210'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // -------- SIGN OUT --------
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _signOut,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          AppTheme.errorColor,
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text('Sign Out'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= HELPER WIDGETS =================

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        title: Text(title, style: AppTheme.bodyLarge),
        subtitle: Text(subtitle, style: AppTheme.bodySmall),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
              Icon(icon, color: AppTheme.primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(value, style: AppTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
