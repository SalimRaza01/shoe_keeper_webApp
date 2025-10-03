import 'package:flutter_portfolio/pages/about_page.dart';
import 'package:flutter_portfolio/pages/buy_page.dart';
import 'package:flutter_portfolio/pages/home_page.dart';
import 'package:flutter_portfolio/pages/login_page.dart';
import 'package:flutter_portfolio/pages/sell_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final AppRouter _instance = AppRouter._internal();

  factory AppRouter() => _instance;
  
  AppRouter._internal();
  
  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/buy',
        builder: (context, state) => const BuyPage(),
      ),
      // GoRoute(
      //   path: '/setupDemographics',
      //   pageBuilder: (context, state) {
      //     return CustomTransitionPage(
      //       key: state.pageKey,
      //       child: const SetupDemographics(),
      //       transitionDuration: const Duration(milliseconds: 800),
      //       transitionsBuilder: (
      //         context,
      //         animation,
      //         secondaryAnimation,
      //         child,
      //       ) {
      //         return FadeTransition(opacity: animation, child: child);
      //       },
      //     );
      //   },
      // ),
      GoRoute(
        path: '/sell',
        builder: (context, state) => const SellPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
   
    ],
  );

  GoRouter get router => _router;
}
