import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavTab { dashboard, links, home, profile, gallery }

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

class SelectedTemplateNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void setTemplate(String? templateId) {
    state = templateId;
  }
}

final selectedTemplateProvider = NotifierProvider<SelectedTemplateNotifier, String?>(() {
  return SelectedTemplateNotifier();
});

class IsInvitationSelectedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setSelection(bool value) {
    state = value;
  }
}

final isInvitationSelectedProvider = NotifierProvider<IsInvitationSelectedNotifier, bool>(() {
  return IsInvitationSelectedNotifier();
});
