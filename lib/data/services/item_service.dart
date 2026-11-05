import 'dart:convert';
import 'dart:io';

import '../models/item.dart';
import 'shared_preferences_service.dart';

class ItemService {
  ItemService({required SharedPreferencesService preferenceService})
    : _preferencesService = preferenceService;
  final SharedPreferencesService _preferencesService;

  List<Item> _items = [];
  Item? _currentItem;

  List<Item> get items => _items;

  //KEYS
  static const itemsKey = 'itemsList';

  Future<void> init() async {
    _items = await getItems();
  }

  Future<List<Item>> getItems() async {
    final itemsJson = _preferencesService.getPrefs(itemsKey);
    if (itemsJson != null) {
      final itemsDecoded = jsonDecode(itemsJson);

      if (itemsDecoded is List) {
        List<Item> itemsList = itemsDecoded
            .map((e) => Item.fromJson(e))
            .toList();
        return itemsList;
      }
    }
    return [];
  }

  void saveItem(Item item) {
    _items.add(item);

    _preferencesService.savePrefs(
      itemsKey,
      jsonEncode(
        _items.map((e) => e.toJson()).toList(),
      ),
    );
  }

  Future<List<Item>?> saveItemsFromImport(List<Item> itemsImported) async {
    final Map<String, Item> localMap = {
      for (var i in _items)
        '${i.name.trim().replaceAll(' ', '_').toLowerCase()}${i.barcode.trim()}': i,
    };

    final List<Item> conflicts = [];
    final List<Item> newItems = [];

    for (var imported in itemsImported) {
      if (localMap.containsKey(
        '${imported.name.trim().replaceAll(' ', '_').toLowerCase()}${imported.barcode.trim()}',
      )) {
        conflicts.add(imported);
      } else {
        newItems.add(imported);
      }
    }
    _items.addAll(newItems);
    _preferencesService.savePrefs(
      itemsKey,
      jsonEncode(
        _items.map((e) => e.toJson()).toList(),
      ),
    );

    return conflicts.isNotEmpty ? conflicts : null;
  }

  Future<void> saveItemsFromImportAfterConflicts(
    List<Item> conflictItems,
  ) async {
    final Map<String, Item> localMap = {
      for (var i in _items)
        '${i.name.trim().replaceAll(' ', '_').toLowerCase()}${i.barcode.trim()}': i,
    };

    for (var conflict in conflictItems) {
      localMap['${conflict.name.trim().replaceAll(' ', '_').toLowerCase()}${conflict.barcode.trim()}'] = conflict;
    }

    final listForSave = localMap.values.toList();

    _items = listForSave;

    _preferencesService.savePrefs(
      itemsKey,
      jsonEncode(
        _items.map((e) => e.toJson()).toList(),
      ),
    );
  }

  Future<void> deleteItem(int id) async {
    final index = _items.indexWhere((e) => e.id == id);

    final isDeleted = await deleteProductImage(_items[index].image);
    if (index != -1 && isDeleted) {
      _items.removeAt(index);

      _preferencesService.savePrefs(
        itemsKey,
        jsonEncode(
          _items.map((e) => e.toJson()).toList(),
        ),
      );
    }
  }

  Future<bool> deleteProductImage(
    String? imagePath, {
    bool saveItemList = false,
  }) async {
    // Si el producto no tenía imagen asociada, terminamos exitosamente
    if (imagePath == null || imagePath.isEmpty) {
      return true;
    }

    try {
      final File imageFile = File(imagePath);

      // Verificamos si el archivo realmente existe en el disco
      if (await imageFile.exists()) {
        await imageFile.delete();

        if (saveItemList) {
          _preferencesService.savePrefs(
            itemsKey,
            jsonEncode(
              _items.map((e) => e.toJson()).toList(),
            ),
          );
        }
      } else {}
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateItem(Item item) async {
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _items[index] = item;
      _preferencesService.savePrefs(
        itemsKey,
        jsonEncode(
          _items.map((e) => e.toJson()).toList(),
        ),
      );
    }
  }
}
