import 'package:go_router/go_router.dart';

import '../home_page.dart';

enum Routes {
  home,
  signInAndSecurity,
  personalInformation,
  paymentMethods,
  familySharing,
  devices,
  privacy;

  String get value => name;
}

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        redirect: (state) => state
            .namedLocation(Routes.home.value, params: {'section': 'security'}),
      ),
      GoRoute(
        name: Routes.home.value,
        path: '/account/manage/section/:section',
        builder: (context, state) {
          final section = state.params['section']!;
          return HomePage(key: state.pageKey, tab: section);
        },
      ),
      // forwarding routes to remove the need to put the 'tab' param in the code
      GoRoute(
        name: Routes.signInAndSecurity.value,
        path: '/security',
        redirect: (state) => state
            .namedLocation(Routes.home.value, params: {'section': 'security'}),
      ),
      GoRoute(
        name: Routes.personalInformation.value,
        path: '/information',
        redirect: (state) => state.namedLocation(Routes.home.value,
            params: {'section': 'information'}),
      ),
    ],
    initialLocation: '/',
  );
}
