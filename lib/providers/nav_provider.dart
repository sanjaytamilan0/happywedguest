import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavTab { links, home, profile, gallery }

class NavTabNotifier extends Notifier<NavTab> {
  @override
  NavTab build() {
    return NavTab.home;
  }

  void setTab(NavTab tab) {
    state = tab;
  }
}

final navTabProvider = NotifierProvider<NavTabNotifier, NavTab>(() {
  return NavTabNotifier();
});
