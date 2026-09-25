import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/services/dialog_service.dart';
import '../data/services/item_service.dart';
import '../data/services/shared_preferences_service.dart';

final locator = GetIt.instance;

Future<void> setUpLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  locator.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(sharedPreferences),
  );

  locator.registerLazySingleton<DialogService>(() => DialogService());

  locator.registerLazySingleton<ItemService>(
    () => ItemService(preferenceService: locator<SharedPreferencesService>()),
  );
}
