import 'package:flutter/material.dart';

import '../../views/global/app_colors.dart';
import '../../views/global/app_text_style.dart';
import '../../views/global/utils/dimens.dart';

class DialogService {
  DialogService._internal();
  static final DialogService _instance = DialogService._internal();

  factory DialogService() => _instance;
  bool _isShowing = false;

  late GlobalKey<NavigatorState> _navigatorKey;

  void init(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  Future<void> showAlert({
    required String title,
    required String message,
    String confirmText = 'Aceptar',
    VoidCallback? onConfirmPressed,
    bool barrierDismissible = true,
  }) async {
    await showCustomDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      onConfirmPressed: onConfirmPressed,
      showCancelButton: false,
      barrierDismissible: barrierDismissible,
    );
  }

  Future<void> showConfirm({
    required String title,
    required String message,
    String confirmText = 'Aceptar',
    VoidCallback? onConfirmPressed,
    bool barrierDismissible = true,
  }) async {
    await showCustomDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      onConfirmPressed: onConfirmPressed,
      showCancelButton: true,
      barrierDismissible: barrierDismissible,
    );
  }

  Future<bool?> showCustomDialog({
    required String title,
    String? message,
    Widget? child,
    String confirmText = 'Confirmar',
    VoidCallback? onConfirmPressed,
    String cancelText = 'Cancelar',
    bool showCancelButton = true,
    VoidCallback? onCancelPressed,
    bool barrierDismissible = true,
  }) async {
    dismissDialog();

    _isShowing = true;
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: _navigatorKey.currentContext!,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: AppColors.hintTextColor,
              width: 1,
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.label(
              fontSize: 18,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth:
                  MediaQuery.of(_navigatorKey.currentContext!).size.width * .80,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message != null)
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.label(
                      fontSize: 16,
                    ),
                  ),
                child ?? Container(),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.symmetric(
            horizontal: wSpaceNormal,
            vertical: hSpaceHalf,
          ),
          actions: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showCancelButton)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (onCancelPressed != null) onCancelPressed();
                        dismissDialog(positive: false);
                        //Navigator.of(_navigatorKey.currentContext!).pop(false);
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          width: 2.0,
                          color: AppColors.primaryColor,
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        //padding: EdgeInsets.symmetric(horizontal: wSpaceNormal, vertical: hSpaceSmall),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      child: Text(
                        cancelText,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.label(
                          color: AppColors.primaryColor,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                if (showCancelButton) HorizontalSpace.min,
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      if (onConfirmPressed != null) onConfirmPressed();
                      //Navigator.of(_navigatorKey.currentContext!).pop(true);
                      dismissDialog(positive: true);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      backgroundColor: AppColors.primaryColor,
                      //padding: EdgeInsets.symmetric(horizontal: wSpaceNormal, vertical: hSpaceSmall),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.label(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showLoadingDialog({
    String? text = 'Cargando...',
  }) async {
    dismissDialog();

    _isShowing = true;
    return showDialog<void>(
      context: _navigatorKey.currentContext!,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            margin: EdgeInsets.only(top: hSpaceNormal),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                VerticalSpace.normal,
                Text(
                  text!,
                  style: AppTextStyle.label(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                VerticalSpace.normal,
              ],
            ),
          ),
        );
      },
    );
  }

  void dismissDialog({bool? positive}) {
    try {
      if (_isShowing) {
        _isShowing = false;
        final navigator = _navigatorKey.currentState;

        if (navigator != null && navigator.canPop()) {
          // Navigator.of(_navigatorKey.currentContext!).pop(true);
          navigator.pop(positive);
        }
      }
    } catch (error) {
      //logger.e('Error al cerrar el diálogo: $error');
    }
  }
}
