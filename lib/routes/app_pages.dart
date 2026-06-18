import 'package:get/get.dart';
import '../home_page.dart';
import '../templates/basic_template/digital_invitation_app.dart';
import '../templates/basic_template/reception_screen.dart';
import '../templates/basic_template/wedding_screen.dart';
import '../templates/digital_template/digital_invitation_app.dart';
import '../templates/digital_template/reception_screen.dart';
import '../templates/digital_template/wedding_screen.dart';
import '../templates/advance_template/digital_invitation_app.dart';
import '../templates/advance_template/reception_screen.dart';
import '../templates/advance_template/wedding_screen.dart';
import '../templates/multiview_template/multiview_app.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
    ),
    GetPage(
      name: AppRoutes.INVITATION,
      page: () => const DigitalInvitationApp(),
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
    GetPage(
      name: AppRoutes.DIGITAL_INVITATION,
      page: () => const DigitalThemeApp(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.DIGITAL_RECEPTION,
      page: () => const DigitalReceptionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.DIGITAL_WEDDING,
      page: () => const DigitalWeddingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.ADVANCE_INVITATION,
      page: () => const AdvanceThemeApp(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.ADVANCE_RECEPTION,
      page: () => const AdvanceReceptionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.ADVANCE_WEDDING,
      page: () => const AdvanceWeddingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.MULTIVIEW_INVITATION,
      page: () => const MultiviewThemeApp(),
      transition: Transition.fadeIn,
    ),
  ];
}
