import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart' as BarcodeWidget;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../config/locator.dart';
import '../../data/models/item.dart';
import '../../data/services/item_service.dart';
import '../global/app_colors.dart';
import '../global/app_text_style.dart';
import '../global/utils/dimens.dart';
import '../global/widgets/local_button.dart';
import '../routes/routes.dart';

class ScannerSectionScreen extends StatefulWidget {
  const ScannerSectionScreen({super.key});

  @override
  State<ScannerSectionScreen> createState() => _ScannerSectionScreenState();
}

class _ScannerSectionScreenState extends State<ScannerSectionScreen> {
  Barcode? barcode;
  Item? item;
  bool _itemNotFound = false;
  final MobileScannerController _controller = MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.noDuplicates,
    torchEnabled: false,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
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
                            //if (widget.isAddingItem) {
                            //  await _controller.stop();
                            //  barcode = barcodes.barcodes.first;
                            //} else {
                            //  Navigator.pop(
                            //    context,
                            //    barcodes.barcodes.first,
                            //  );
                            //}

                            barcode = barcodes.barcodes.first;
                            _getItemByBarcode(barcode);

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

                _showItem(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _showItem() {
    if (_itemNotFound) {
      return Column(
        children: [
          VerticalSpace.tooLarge,
          Text(
            'Producto no encontrado',
            style: AppTextStyle.label(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          //VerticalSpace.normal,
          //LocalButton(
          //  'Reintentar',
          //  onTap: () async {
          //    await _controller.start();
          //    barcode = null;
          //    _itemNotFound = false;
          //    setState(() {});
          //  },
          //),
        ],
      );
    }
    if (item != null) {
      return Column(
        children: [
          VerticalSpace.veryLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  item!.name,
                  style: AppTextStyle.label(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                item!.priceFormatter(),
                style: AppTextStyle.label(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          VerticalSpace.normal,
          if (item!.barcode.isNotEmpty)
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                height: MediaQuery.of(context).size.width * .3,
                child: BarcodeWidget.BarcodeWidget(
                  data: item!.barcode,
                  barcode: BarcodeWidget.Barcode.code128(),
                  errorBuilder: (context, error) {
                    return Text('Error al mostrar el código');
                  },
                ),
              ),
            ),
          //if (item! .image.isNotEmpty)
          //  Center(
          //    child: SizedBox(
          //      width: MediaQuery.of(context).size.width * .8,
          //      height: MediaQuery.of(context).size.width * .7,
          //      child: _buildImage(),
          //    ),
          //  ),
          VerticalSpace.normal,
          LocalButton(
            'Ver detalle',
            onTap: () async {
              final result = await Navigator.pushNamed(
                context,
                Routes.detailProduct,
                arguments: item,
              );
            },
          ),
        ],
      );
    }

    return Container();
  }

  void _getItemByBarcode(Barcode? barcode) {
    final items = locator<ItemService>().items;

    item = items.firstWhereOrNull((e) => e.barcode == barcode?.rawValue);

    if (item == null) {
      _itemNotFound = true;
    } else {
      _itemNotFound = false;
    }
  }

  Widget _buildImage() {
    final File imageFile = File(item!.image);

    if (!imageFile.existsSync()) {
      return Icon(
        Icons.broken_image,
        size: 50,
      );
    }

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10),
        child: Image.file(
          imageFile,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            return const Text('Error al cargar la imágen');
          },
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
