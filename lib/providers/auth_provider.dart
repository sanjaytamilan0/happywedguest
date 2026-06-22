import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool('isLoggedIn') ?? false;
  }

  void login() {
    state = true;
    ref.read(sharedPreferencesProvider).setBool('isLoggedIn', true);
  }

  void logout() {
    state = false;
    ref.read(sharedPreferencesProvider).setBool('isLoggedIn', false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});
