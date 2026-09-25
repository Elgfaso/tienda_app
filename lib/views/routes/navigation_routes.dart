import 'package:flutter/material.dart';
import '../../data/models/item.dart';
import '../screens/add_product_screen.dart';
import '../screens/detail_product_screen.dart';
import '../screens/scanner_screen.dart';
import 'routes.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';

class NavigationRoutes {
  static final Map<String, Widget Function(RouteSettings settings)> routes = {
    Routes.splash: (_) => const SplashScreen(),
    Routes.home: (_) => const HomeScreen(),
    Routes.scanner: (_) => ScannerScreen(),
    Routes.addProduct:(settings )=> AddProductScreen(item: settings.arguments != null ? settings.arguments as Item : null,),
    Routes.detailProduct:(settings)=> DetailProductScreen(item: settings.arguments as Item,),
  };

  Route<dynamic> generateRoute(RouteSettings settings) {
    final pageBuilder = routes[settings.name];

    if (pageBuilder != null) {
      return SlidePageRoute(child: pageBuilder(settings), settings: settings);
    } else {
      return SlidePageRoute(child: const SplashScreen(), settings: settings);
    }
  }
}

class SlidePageRoute extends PageRouteBuilder {
  SlidePageRoute({required Widget child, required RouteSettings settings})
    : super(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.linearToEaseOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}
