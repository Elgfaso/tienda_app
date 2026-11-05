import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/app_info.dart';
import '../../config/locator.dart';
import '../../data/models/item.dart';
import '../../data/services/dialog_service.dart';
import '../../data/services/item_service.dart';
import '../global/app_colors.dart';
import '../global/app_text_style.dart';

class SettingsSectionScreen extends StatefulWidget {
  const SettingsSectionScreen({super.key});

  @override
  State<SettingsSectionScreen> createState() => _SettingsSectionScreenState();
}

class _SettingsSectionScreenState extends State<SettingsSectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _listItem(
          title: 'Exportar datos',
          trailing: Icon(Icons.output),
          onTap: () async {
            final items = locator<ItemService>().items;
            await _exportData(items);
          },
        ),

        Divider(color: AppColors.hintTextColor, height: 0),
        _listItem(
          title: 'Importar datos',
          trailing: Icon(Icons.system_update_alt),
          onTap: () async {
            await _importData();
          },
        ),
        Divider(color: AppColors.hintTextColor, height: 0),
        _listItem(
          title: 'Versión',
          subtitle: '${AppInfo.version}(${AppInfo.versionCode})',
        ),
        Divider(color: AppColors.hintTextColor, height: 0),
      ],
    );
  }

  Widget _listItem({
    required String title,
    String? subtitle,
    Widget? trailing,
    void Function()? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: AppTextStyle.label(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTextStyle.label(
                fontSize: 16,
                color: AppColors.primaryColor,
              ),
            )
          : null,
      minTileHeight: 72.0,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Future<void> _exportData(List<Item> items) async {
    locator<DialogService>().showLoadingDialog(text: 'Exportando datos...');
    final date = DateTime.now().toIso8601String();
    final Map<String, dynamic> exportData = {
      'version': AppInfo.versionCode ?? '1',
      'exportedAt': date,
      'items': items.map((e) => e.copyWith(image: '').toJson()).toList(),
    };

    final String jsonString = JsonEncoder.withIndent(' ').convert(exportData);

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/items_$date.json');
    await file.writeAsString(jsonString);

    locator<DialogService>().dismissDialog();
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Respaldo de productos',
      ),
    );
  }

  Future<void> _importData() async {
    final result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    locator<DialogService>().showLoadingDialog(text: 'Importando datos...');
    try {
      if (result != null && result.path != null) {
        ///////////////////////////////////////
        final file = File(result.path!);

        final jsonString = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(jsonString);

        final String version = data['version'] ?? 1;

        final List<Item> importedItems = (data['items'] as List)
            .map((item) => Item.fromJson(item))
            .toList();

        final saveResult = await locator<ItemService>().saveItemsFromImport(
          importedItems,
        );
        ////////////////////////////////////////////////
        if (saveResult != null) {
          locator<DialogService>().dismissDialog();
          locator<DialogService>().showCustomDialog(
            title: 'Conflicto en productos',
            message:
                'Algunos productos importados tienen el mismo nombre y código de barras de los productos locales\n¿Desea reemplazar los productos o conservar los actuales?',
            confirmText: 'Reemplazar',
            onConfirmPressed: () async {
              locator<DialogService>().showLoadingDialog();
              await locator<ItemService>().saveItemsFromImportAfterConflicts(
                saveResult,
              );
              await locator<ItemService>().getItems();
              locator<DialogService>().dismissDialog();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Los productos fueron reemplazados',
                    ),
                    backgroundColor: AppColors.primaryColor,
                  ),
                );
              }
            },
            cancelText: 'Conservar',
          );
        } else {
          await locator<ItemService>().getItems();
          locator<DialogService>().dismissDialog();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Productos importados',
                ),
                backgroundColor: AppColors.primaryColor,
              ),
            );
          }
        }
      } else {
        locator<DialogService>().dismissDialog();
      }
    } catch (e) {
      locator<DialogService>().showAlert(
        title: 'Oops',
        message: 'Hubo un error al importar la información\n$e',
      );
    }
  }
}
