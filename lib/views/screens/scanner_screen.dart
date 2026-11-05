
import 'package:barcode_widget/barcode_widget.dart' as BC;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../global/app_colors.dart';
import '../global/app_text_style.dart';
import '../global/utils/dimens.dart';
import '../global/widgets/local_button.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key, this.isAddingItem = false});
  final bool isAddingItem;
  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  Barcode? barcode;

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
                          height: MediaQuery.of(context).size.height * .30,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(15),
                            child: MobileScanner(
                              controller: _controller,
                              onDetect: (barcodes) async {
                                if (widget.isAddingItem) {
                                  await _controller.stop();
                                  barcode = barcodes.barcodes.first;
                                } else {
                                  Navigator.pop(
                                    context,
                                    barcodes.barcodes.first,
                                  );
                                }

                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * .30,
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
                    VerticalSpace.veryLarge,
                    if (barcode != null)
                      Column(
                        children: [
                          Text(
                            '¿El código es correcto?',
                            style: AppTextStyle.label(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          VerticalSpace.normal,
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              height: MediaQuery.of(context).size.width * .3,
                              child: BC.BarcodeWidget(
                                data: barcode!.rawValue ?? '',
                                barcode: BC.Barcode.code128(),
                                style: AppTextStyle.label(fontSize: 24),
                                errorBuilder: (context, error) {
                                  return Text('Error al mostrar el código');
                                },
                              ),
                            ),
                          ),
                          VerticalSpace.normal,
                          Row(
                            children: [
                              Expanded(
                                child: LocalButton(
                                  'Reintentar',
                                  bordered: true,
                                  onTap: () async {
                                    barcode = null;
                                    await _controller.start();
                                    setState(() {});
                                  },
                                ),
                              ),
                              HorizontalSpace.half,
                              Expanded(
                                child: LocalButton(
                                  'Si',
                                  onTap: () {
                                    Navigator.pop(
                                      context,
                                      barcode,
                                    );
                                  },
                                ),
                              ),
                            ],
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
