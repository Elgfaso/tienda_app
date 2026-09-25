import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../global/app_colors.dart';
import '../global/app_text_style.dart';
import '../global/utils/dimens.dart';
import '../global/widgets/local_button.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  Barcode? barcode;
  Barcode? barcode2;
  Barcode? barcode3;
  bool allBarcodes = false;
  final MobileScannerController _controller = MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.noDuplicates,
    torchEnabled: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Escanear producto',
          style: AppTextStyle.titleAppBar,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VerticalSpace.veryLarge,
                    Text(
                      'Enfoque el código en el recuadro',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.label(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    VerticalSpace.normal,
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(15),
                            child: MobileScanner(
                              controller: _controller,
                              onDetect: (barcodes) async {
                                await _controller.stop();
                                if (context.mounted) {
                                  Navigator.pop(
                                    context,
                                    barcodes.barcodes.first,
                                  );
                                }
                                //if (barcode == null) {
                                //  barcode = barcodes.barcodes.first;
                                //} else if (barcode2 == null) {
                                //  barcode2 = barcodes.barcodes.first;
                                //} else if (barcode3 == null) {
                                //  barcode3 = barcodes.barcodes.first;
                                //  allBarcodes = true;
                                //}

                                //if (allBarcodes) {
                                //  if (barcode?.rawValue == barcode2?.rawValue &&
                                //      barcode2?.rawValue ==
                                //          barcode3?.rawValue) {
                                //    allBarcodes = false;
                                //    await _controller.stop();
                                //    if (context.mounted) {
                                //      Navigator.pop(
                                //        context,
                                //        barcode,
                                //      );
                                //    }
                                //  } else {
                                //    allBarcodes = false;
                                //    barcode = null;
                                //    barcode2 = null;
                                //    barcode3 = null;

                                //  }
                                //}

                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              LocalButton(
                'Cancelar',
                //bordered: true,
                onTap: () {
                  Navigator.pop(context);
                  //context.navPop();
                },
              ),
              VerticalSpace.normal,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }
}
