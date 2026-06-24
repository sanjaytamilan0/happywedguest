import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/nav_provider.dart';
import 'widgets/top_nav.dart';
import 'widgets/rsvp_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'views/home_view.dart';
import 'views/profile_view.dart';
import 'views/gallery_view.dart';
import 'views/links_view.dart';
import 'views/dashboard_view.dart';
import 'providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(navTabProvider);
    final isLoggedIn = ref.watch(authProvider);

    final isMobilePlatform = Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.android;

    return Scaffold(
      // bottomNavigationBar: isMobilePlatform ? _buildBottomNavBar(currentTab, isLoggedIn, ref) : null,
      bottomNavigationBar: null,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 800;
        
            return Stack(
              children: [
                // Main Scrollable Content
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 48,
                    bottom: 48, // space for bottom action bar removed
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header Logo / Text moved to RsvpCard
        
                      // Top Pill Navigation
                      // if (!isMobilePlatform) ...[
                      //   const TopNavBar(),
                      //   const SizedBox(height: 48),
                      // ],
        
                      if (currentTab == NavTab.home) ...[
                        const RsvpCard(guestName: 'sanjay'),
                        const SizedBox(height: 32),
                      ],
        
                      Builder(
                        builder: (context) {
                          switch (currentTab) {
                            case NavTab.dashboard:
                              return const DashboardView();
                            case NavTab.profile:
                              return ProfileView(isDesktop: isDesktop);
                            case NavTab.gallery:
                              return GalleryView(isDesktop: isDesktop);
                            case NavTab.links:
                              return LinksView(isDesktop: isDesktop);
                            case NavTab.home:
                              return HomeView(isDesktop: isDesktop);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // Top Right Action Row
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                        if (currentTab == NavTab.gallery && ref.watch(isInvitationSelectedProvider))
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.help_outline, color: Colors.grey),
                            tooltip: 'Help & Contact',
                            offset: const Offset(0, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: Colors.white,
                            elevation: 4,
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'contact',
                                child: Container(
                                  width: 220,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Need Help?',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      const SizedBox(height: 12),
                                      InkWell(
                                        onTap: () async {
                                          final url = Uri.parse('tel:+919876543210');
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.withAlpha(25),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.phone, color: Colors.blue, size: 16),
                                              ),
                                              const SizedBox(width: 12),
                                              const Text('+91 98765 43210', style: TextStyle(fontSize: 13)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      InkWell(
                                        onTap: () async {
                                          final url = Uri.parse('https://wa.me/919876543210');
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url, mode: LaunchMode.externalApplication);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.withAlpha(25),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.chat, color: Colors.green, size: 16),
                                              ),
                                              const SizedBox(width: 12),
                                              const Text('WhatsApp Us', style: TextStyle(fontSize: 13)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.notifications_none, color: Colors.grey),
                          tooltip: 'Notifications',
                          offset: const Offset(0, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          color: Colors.white,
                          elevation: 4,
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'notification',
                              child: Container(
                                width: 250,
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.mail_outline, color: Color(0xFFD83076), size: 20),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'New Invitation!',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'You have been invited to Akshay & Krishna\'s Wedding.',
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (currentTab == NavTab.profile)
                          IconButton(
                            icon: const Icon(Icons.home, color: Colors.grey),
                            tooltip: 'Home',
                            onPressed: () {
                              ref.read(navTabProvider.notifier).setTab(NavTab.home);
                            },
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.person, color: Colors.grey),
                            tooltip: 'Profile',
                            onPressed: () {
                              ref.read(navTabProvider.notifier).setTab(NavTab.profile);
                            },
                          ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (isLoggedIn) {
                              _showLogoutConfirmationDialog(context, ref);
                            } else {
                              _showLoginDialog(context, ref);
                            }
                          },
                          icon: Icon(isLoggedIn ? Icons.logout : Icons.login, size: 18),
                          label: Text(isLoggedIn ? 'Logout' : 'Login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD83076),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(NavTab currentTab, bool isLoggedIn, WidgetRef ref) {
    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.image),
        label: 'Invitations',
      ),
    ];

    int currentIndex = 0;
    if (currentTab == NavTab.home) currentIndex = 0;
    else if (currentTab == NavTab.profile) currentIndex = 1;
    else if (currentTab == NavTab.gallery) currentIndex = 2;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFD83076),
      unselectedItemColor: Colors.grey[600],
      onTap: (index) {
        NavTab selectedTab;
        switch (index) {
          case 0: selectedTab = NavTab.home; break;
          case 1: selectedTab = NavTab.profile; break;
          case 2: selectedTab = NavTab.gallery; break;
          default: selectedTab = NavTab.home;
        }
        ref.read(navTabProvider.notifier).setTab(selectedTab);
      },
      items: items,
    );
  }



  void _showLogoutConfirmationDialog(BuildContext context, WidgetRef ref) {
    final isMobilePlatform = Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.android;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.lora(fontWeight: FontWeight.bold),
          ),
          content: const Text('Are you sure you want to log out?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                ref.read(navTabProvider.notifier).setTab(isMobilePlatform ? NavTab.profile : NavTab.home);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD83076),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showLoginDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _LoginDialog(ref: ref);
      },
    );
  }
}

enum _LoginState { login, forgotPassword, otp }

class _LoginDialog extends StatefulWidget {
  final WidgetRef ref;

  const _LoginDialog({required this.ref});

  @override
  State<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<_LoginDialog> {
  _LoginState _currentState = _LoginState.login;

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD83076)),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      keyboardType: keyboardType,
      obscureText: isObscure,
    );
  }

  void _handleSuccess() {
    final isMobilePlatform = Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.android;
    widget.ref.read(authProvider.notifier).login();
    Navigator.of(context).pop();
    widget.ref.read(navTabProvider.notifier).setTab(isMobilePlatform ? NavTab.home : NavTab.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _currentState == _LoginState.login
            ? 'Login'
            : _currentState == _LoginState.forgotPassword
                ? 'Forgot Password'
                : 'Enter OTP',
        style: GoogleFonts.lora(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_currentState == _LoginState.login) ...[
            _buildTextField(
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Password',
              icon: Icons.lock,
              isObscure: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _currentState = _LoginState.forgotPassword;
                  });
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Color(0xFFD83076)),
                ),
              ),
            ),
          ] else if (_currentState == _LoginState.forgotPassword) ...[
            const Text('Enter your phone number to receive an OTP.'),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
          ] else if (_currentState == _LoginState.otp) ...[
            const Text('Enter the 4-digit OTP sent to your phone.'),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'OTP',
              icon: Icons.message,
              keyboardType: TextInputType.number,
            ),
          ],
        ],
      ),
      actions: [
        if (_currentState != _LoginState.login)
          TextButton(
            onPressed: () {
              setState(() {
                _currentState = _LoginState.login;
              });
            },
            child: const Text('Back', style: TextStyle(color: Colors.grey)),
          )
        else
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
        ElevatedButton(
          onPressed: () {
            if (_currentState == _LoginState.login) {
              _handleSuccess();
            } else if (_currentState == _LoginState.forgotPassword) {
              setState(() {
                _currentState = _LoginState.otp;
              });
            } else if (_currentState == _LoginState.otp) {
              _handleSuccess();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD83076),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            _currentState == _LoginState.login
                ? 'Login'
                : _currentState == _LoginState.forgotPassword
                    ? 'Send OTP'
                    : 'Verify OTP',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
