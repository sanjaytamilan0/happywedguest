import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/nav_provider.dart';

class TopNavBar extends ConsumerWidget {
  const TopNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(navTabProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NavItem(
              title: 'LINKS',
              icon: Icons.link,
              tab: NavTab.links,
              currentTab: currentTab,
            ),
            _NavItem(
              title: 'HOME',
              icon: Icons.home,
              tab: NavTab.home,
              currentTab: currentTab,
            ),
            _NavItem(
              title: 'PROFILE',
              icon: Icons.person,
              tab: NavTab.profile,
              currentTab: currentTab,
            ),
            _NavItem(
              title: 'GALLERY',
              icon: Icons.image,
              tab: NavTab.gallery,
              currentTab: currentTab,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends ConsumerWidget {
  final String title;
  final IconData icon;
  final NavTab tab;
  final NavTab currentTab;

  const _NavItem({
    required this.title,
    required this.icon,
    required this.tab,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = tab == currentTab;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        ref.read(navTabProvider.notifier).setTab(tab);
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          alignment: 0.5,
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
