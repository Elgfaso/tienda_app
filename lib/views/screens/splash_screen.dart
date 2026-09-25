import 'package:flutter/material.dart';
import '../../config/locator.dart';
import '../../data/services/item_service.dart';
import '../global/app_text_style.dart';
import '../routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
      () {
        if (mounted) {
          locator<ItemService>().init();

          Navigator.pushReplacementNamed(context, Routes.home);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text('Cargando', style: AppTextStyle.label(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}
