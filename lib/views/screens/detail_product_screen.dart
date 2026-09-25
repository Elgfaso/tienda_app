import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../../config/locator.dart';
import '../../data/models/item.dart';
import '../../data/services/dialog_service.dart';
import '../../data/services/item_service.dart';
import '../global/app_colors.dart';
import '../global/app_text_style.dart';
import '../global/utils/dimens.dart';
import '../routes/routes.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({super.key, required this.item});
  final Item item;
  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle del producto',
          style: AppTextStyle.titleAppBar,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: wSpaceNormal,
            vertical: hSpaceHalf,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.addProduct,
                        arguments: widget.item,
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: AppColors.primaryColor,
                      size: 40,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      locator<DialogService>().showConfirm(
                        title: 'Eliminar producto',
                        message:
                            '¿Esta seguro que desea eliminar ${widget.item.name}?',
                        onConfirmPressed: () {
                          _deleteItem();
                        },
                      );
                    },
                    icon: Icon(
                      Icons.delete,
                      color: AppColors.errorColor,
                      size: 40,
                    ),
                  ),
                ],
              ),
              Text(
                widget.item.name,
                style: AppTextStyle.label(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              VerticalSpace.normal,
              Text(
                'Precio: ${widget.item.priceFormatter()}',
                style: AppTextStyle.label(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              VerticalSpace.tooLarge,
              if (widget.item.barcode.isNotEmpty)
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.width * .3,
                    child: BarcodeWidget(
                      data: widget.item.barcode,
                      barcode: Barcode.code128(),
                      errorBuilder: (context, error) {
                        return Text('Error al mostrar el código');
                      },
                    ),
                  ),
                ),
              if (widget.item.barcode.isNotEmpty) VerticalSpace.veryLarge,
              if (widget.item.image.isNotEmpty)
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.width * .7,
                    child: _buildImage(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final File imageFile = File(widget.item.image);

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

  Future<void> _deleteItem() async {
    setState(() {
      locator<DialogService>().showLoadingDialog(
        text: 'Eliminando producto...',
      );
    });
    await locator<ItemService>().deleteItem(widget.item.id);
    setState(() {
      locator<DialogService>().dismissDialog();
      Navigator.pop(context, [true]);
    });
  }
}
