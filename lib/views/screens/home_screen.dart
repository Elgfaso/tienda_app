import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as ms;

import '../../config/app_info.dart';
import '../../config/locator.dart';
import '../../data/models/item.dart';
import '../../data/services/dialog_service.dart';
import '../../data/services/item_service.dart';
import '../global/app_colors.dart';
import '../global/app_text_style.dart';
import '../global/utils/dimens.dart';
import '../global/widgets/local_input_field.dart';
import '../routes/routes.dart';
import 'package:collection/collection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<Item> _items = [];
  List<Item> _itemsOrigin = [];
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _items = locator<ItemService>().items;
    _items.sort((a, b) => a.name.compareTo(b.name));
    _itemsOrigin = List.from(_items);
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'priceBtn',
            onPressed: () async {
              final result = await Navigator.pushNamed(context, Routes.scanner);

              if (result != null && result is ms.Barcode) {
                final item = _items.firstWhereOrNull(
                  (i) => i.barcode == result.rawValue,
                );
                if (item != null) {
                  locator<DialogService>().showCustomDialog(
                    title: item.name,
                    child: Column(
                      children: [
                        Text(
                          'Precio: ${item.priceFormatter()}',
                          style: AppTextStyle.label(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        VerticalSpace.normal,
                        if (item.image.isNotEmpty)
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              height: MediaQuery.of(context).size.width * .7,
                              child: _buildImage(item),
                            ),
                          ),
                      ],
                    ),
                    showCancelButton: false,
                  );
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(Icons.barcode_reader),
            ),
          ),
          VerticalSpace.normal,
          FloatingActionButton(
            heroTag: 'addBtn',
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                Routes.addProduct,
              );
              if (result != null) {
                await _getItems();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          'Tienda Torres',
          style: AppTextStyle.titleAppBar,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: LocalTextInputField(
                      hint: 'Buscar',
                      controller: _searchController,
                      onChanged: (value) {
                        _searchItem();
                        setState(() {});
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _getItems();
                    },
                    icon: Icon(
                      Icons.refresh,
                      size: 30,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: AppColors.hintTextColor,
            ),
            _isLoading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : _items.isEmpty
                ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Sin productos registrados',
                      style: AppTextStyle.label(fontSize: 20),
                    ),
                  ),
                )
                : Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        Item item = _items[index];
                        return ListTile(
                          title: Text(
                            item.name,
                            style: AppTextStyle.label(fontSize: 24),
                          ),
                          subtitle: Text(
                            item.priceFormatter(),
                            style: AppTextStyle.label(
                              fontSize: 20,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            size: 30,
                          ),
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              Routes.detailProduct,
                              arguments: item,
                            );
                            if (result != null) {
                              await _getItems();
                            }
                          },
                        );
                      },
                      itemCount: _items.length,
                    ),
                  ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 20,left: 8),
                child: Text(
                  'Ver ${AppInfo.version}(${AppInfo.versionCode})',
                  style: AppTextStyle.label(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Item item) {
    final File imageFile = File(item.image);

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

  Future<void> _getItems() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1), () async {
      _itemsOrigin = await locator<ItemService>().getItems();
      _itemsOrigin.sort((a, b) => a.name.compareTo(b.name));
    });
    _searchItem();
    setState(() {
      _isLoading = false;
    });
  }

  void _searchItem() {
    _items = List.from(
      _itemsOrigin.where((item) {
        if (_searchController.text.isNotEmpty) {
          return item.name.toLowerCase().startsWith(
            _searchController.text.toLowerCase().trim(),
          );
        }
        return true;
      }),
    );
  }
}
