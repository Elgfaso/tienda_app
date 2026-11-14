import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/locator.dart';
import '../../data/services/audio_service.dart';
import '../../data/services/dialog_service.dart';
import '../../data/services/http_service.dart';
import '../../data/services/item_service.dart';
import '../global/app_colors.dart';
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

    AudioService.playAudio(AudioNames.splash);
    _init();
  }

  void _goToHome() async {
    await Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    });
  }

  void _init() async {
    try {
      await locator<ItemService>().init();
      final result = await locator<HttpService>().checkLatestVersionApp();
      if (result['update'] == true) {
        locator<DialogService>().showCustomDialog(
          title: '¡Actualización disponible!',
          message:
              'Hay una nueva versión de la aplicación📱\n${result['version']}\n¿Deseas instalar la actualización?',
          confirmText: 'Actualizar',
          cancelText: 'Seguir',
          onCancelPressed: () {
            if (mounted) {
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.pushReplacementNamed(context, Routes.home);
              });
            }
          },
          onConfirmPressed: () async {
            final Uri url = Uri.parse(result['url']);
            if (await canLaunchUrl(url)) {
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication,
              );
              _goToHome();
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Error al actualizar la app',
                    ),
                    backgroundColor: AppColors.primaryColor,
                  ),
                );
                _goToHome();
              }
            }
          },
        );
      } else {
        _goToHome();
      }
    } catch (e) {
      _goToHome();
    }
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
            CircularProgressIndicator(
              color: AppColors.secondColor,
            ),
            Text(
              'Cargando',
              style: AppTextStyle.label(
                fontSize: 26,
                color: AppColors.secondColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
