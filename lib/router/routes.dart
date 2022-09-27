import 'package:appleid_dashboard/side_menu/menu_item_type.dart';
import 'package:go_router/go_router.dart';

import '../pages/home_page.dart';

enum Routes {
  home(''),
  signInAndSecurity('security'),
  personalInformation('information'),
  paymentMethods('payment'),
  familySharing('family'),
  devices('devices'),
  privacy('privacy');
  const Routes(this.value);
  final String value;
}

extension MenuItemTypeFromString on MenuItemType {
  static MenuItemType fromString(String value) {
    if (value == Routes.signInAndSecurity.value) {
      return MenuItemType.security;
    } else if (value == Routes.personalInformation.value) {
      return MenuItemType.information;
    } else if (value == Routes.paymentMethods.value) {
      return MenuItemType.payment;
    } else if (value == Routes.familySharing.value) {
      return MenuItemType.family;
    } else if (value == Routes.devices.value) {
      return MenuItemType.devices;
    } else if (value == Routes.privacy.value) {
      return MenuItemType.privacy;
    } else {
      return MenuItemType.security;
    }
  }
}

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => state.namedLocation(Routes.home.name,
            params: {'section': Routes.signInAndSecurity.value}),
      ),
      GoRoute(
        name: Routes.home.name,
        path: '/account/manage/section/:section',
        builder: (context, state) {
          final section = state.params['section']!;
          return HomePage(
              key: state.pageKey,
              tab: MenuItemTypeFromString.fromString(section));
        },
      ),
      // forwarding routes to remove the need to put the 'tab' param in the code
      GoRoute(
        name: Routes.signInAndSecurity.name,
        path: '/security',
        redirect: (context, state) => state.namedLocation(Routes.home.name,
            params: {'section': Routes.signInAndSecurity.value}),
      ),
      GoRoute(
        name: Routes.personalInformation.name,
        path: '/information',
        redirect: (context, state) => state.namedLocation(Routes.home.name,
            params: {'section': Routes.personalInformation.value}),
      ),
    ],
  );
}
