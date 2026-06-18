import 'package:get/get.dart';
import '../home_page.dart';
import '../templates/basic_template/invitation_screen.dart';
import '../templates/basic_template/reception_screen.dart';
import '../templates/basic_template/wedding_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
    ),
    GetPage(
      name: AppRoutes.INVITATION,
      page: () => const InvitationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.RECEPTION,
      page: () => const ReceptionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.WEDDING,
      page: () => const WeddingScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
