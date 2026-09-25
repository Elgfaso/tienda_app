import 'package:flutter/material.dart';
import 'config/app_info.dart';
import 'config/locator.dart';
import 'data/services/dialog_service.dart';
import 'views/global/app_theme.dart';
import 'views/routes/navigation_routes.dart';
import 'views/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setUpLocator();
  locator<DialogService>().init(navigatorKey);
  await AppInfo.init();
  runApp(const MainApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'Tienda Torres',
        navigatorKey: navigatorKey,
        locale: Locale('es', 'ES'),
        theme: AppTheme.theme,
        onGenerateRoute: (settings) =>
            NavigationRoutes().generateRoute(settings),
        home: SplashScreen(),
      ),
    );
  }
}
