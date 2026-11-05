import 'package:flutter/material.dart';
import '../../config/locator.dart';
import '../../data/services/item_service.dart';
import '../global/app_colors.dart';
import '../global/app_text_style.dart';
import '../global/widgets/local_text_animation.dart';
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
            Image.asset(
              'assets/icon_app/icon_tienda_app.jpg',
              width: MediaQuery.of(context).size.width * .70,
            ),
            //CircularProgressIndicator(),
            LocalTextAnimation(
              style: AppTextStyle.label(
                fontSize: 30,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
