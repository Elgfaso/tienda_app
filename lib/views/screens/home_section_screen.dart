import 'dart:io';

import 'package:flutter/material.dart';

import '../../config/locator.dart';
import '../../data/models/item.dart';
import '../../data/services/item_service.dart';
import '../global/app_colors.dart';
import '../global/app_text_style.dart';
import '../global/utils/dimens.dart';
import '../global/widgets/local_input_field.dart';
import '../routes/routes.dart';

class HomeSectionScreen extends StatefulWidget {
  const HomeSectionScreen({super.key});

  @override
  State<HomeSectionScreen> createState() => _HomeSectionScreenState();
}

class _HomeSectionScreenState extends State<HomeSectionScreen> {
  bool _isLoading = true;
  List<Item> _items = [];
  List<Item> _itemsOrigin = [];

  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _items = locator<ItemService>().items;
    _items.sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
    _itemsOrigin = List.from(_items);
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  final result = await Navigator.pushNamed(
                    context,
                    Routes.addProduct,
                  );
                  if (result != null) {
                    await _getItems();
                  }
                },
                iconSize: 48,
                color: AppColors.primaryColor,
                icon: Icon(Icons.add_circle),
              ),
              //IconButton(
              //  onPressed: () async {
              //    await _getItems();
              //  },
              //  icon: Icon(
              //    Icons.refresh,
              //    size: 30,
              //    color: AppColors.primaryColor,
              //  ),
              //),
            ],
          ),
        ),
        Divider(
          color: AppColors.hintTextColor,
          height: 0,
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
                child: RefreshIndicator.adaptive(
                  onRefresh: () async {
                    await _getItems();
                  },
                  color: AppColors.primaryColor,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      Item item = _items[index];
                      //final par = index % 2 == 0;
                      return ListTile(
                        //contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
                        //tileColor: par ? AppColors.hintTextColor : null,
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
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: AppColors.hintTextColor,
                        height: 0,
                      );
                    },
                    itemCount: _items.length,
                  ),
                ),
              ),
      ],
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
      _itemsOrigin.sort(
        (a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()),
      );
    });
    _searchItem();
    setState(() {
      _isLoading = false;
    });
  }

  void _searchItem() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      _items = List.from(_itemsOrigin);
    } else {
      _items = _itemsOrigin.where(
        (item) {
          return item.name.toLowerCase().contains(query);
        },
      ).toList();
    }
  }

  void _showModalBottom<T>(
    BuildContext context, {
    String? title,
    required List<T> items,
    required List<String> itemNames,
    void Function(T? value)? onSelected,
  }) {
    showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Indicador visual de arrastre (Handle)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.hintTextColor.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                title ?? 'Selecciona una opción',
                style: AppTextStyle.label(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              VerticalSpace.half,
              const Divider(color: AppColors.hintTextColor),

              // Lista de opciones
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: AppColors.hintTextColor,
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final itemName = itemNames[index];

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: wSpaceNormal,
                        horizontal: hSpaceHalf,
                      ),
                      title: Text(
                        itemName,
                        style: AppTextStyle.label(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      leading: index == 0
                          ? Icon(Icons.output)
                          : Icon(Icons.system_update_alt),

                      onTap: () {
                        Navigator.pop(context, item);
                      },
                    );
                  },
                ),
              ),
              Divider(
                color: AppColors.hintTextColor,
                height: 1,
              ),
              VerticalSpace.normal,
            ],
          ),
        );
      },
    ).then((selectedValue) {
      if (onSelected != null) {
        onSelected(selectedValue);
      }
    });
  }
}
