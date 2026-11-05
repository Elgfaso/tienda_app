
import 'package:flutter/material.dart';

import '../global/app_colors.dart';
import '../global/app_text_style.dart';

import 'home_section_screen.dart';
import 'scanner_section_screen.dart';
import 'settings_section_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeSectionScreen(),
    ScannerSectionScreen(),
    SettingsSectionScreen(),
  ];

  static const List<String> _widgetTitle = <String>[
    'Tienda Torres',
    'Escanear producto',
    'Configuraciones',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      appBar: AppBar(
        title: Text(
          _widgetTitle.elementAt(_selectedIndex),
          style: AppTextStyle.titleAppBar,
        ),
      ),

      //floatingActionButton: _selectedIndex == 0
      //    ? Column(
      //        mainAxisAlignment: MainAxisAlignment.end,
      //        crossAxisAlignment: CrossAxisAlignment.end,
      //        children: [
      //          //FloatingActionButton(
      //          //  heroTag: 'priceBtn',
      //          //  onPressed: () async {
      //          //    final result = await Navigator.pushNamed(
      //          //      context,
      //          //      Routes.scanner,
      //          //      arguments: false,
      //          //    );

      //          //    if (result != null && result is ms.Barcode) {
      //          //      final item = _items.firstWhereOrNull(
      //          //        (i) => i.barcode == result.rawValue,
      //          //      );
      //          //      if (item != null) {
      //          //        locator<DialogService>().showCustomDialog(
      //          //          title: item.name,
      //          //          child: Column(
      //          //            children: [
      //          //              Text(
      //          //                'Precio: ${item.priceFormatter()}',
      //          //                style: AppTextStyle.label(
      //          //                  fontSize: 24,
      //          //                  fontWeight: FontWeight.bold,
      //          //                ),
      //          //              ),
      //          //              VerticalSpace.normal,
      //          //              if (item.image.isNotEmpty)
      //          //                Center(
      //          //                  child: SizedBox(
      //          //                    width:
      //          //                        MediaQuery.of(context).size.width * .8,
      //          //                    height:
      //          //                        MediaQuery.of(context).size.width * .7,
      //          //                    child: _buildImage(item),
      //          //                  ),
      //          //                ),
      //          //            ],
      //          //          ),
      //          //          showCancelButton: false,
      //          //        );
      //          //      }
      //          //    }
      //          //  },
      //          //  child: Container(
      //          //    decoration: BoxDecoration(
      //          //      shape: BoxShape.circle,
      //          //      color: AppColors.primaryColor,
      //          //    ),
      //          //    child: Icon(Icons.barcode_reader),
      //          //  ),
      //          //),
      //          VerticalSpace.normal,
      //          FloatingActionButton(
      //            heroTag: 'addBtn',
      //            onPressed: () async {
      //              final result = await Navigator.pushNamed(
      //                context,
      //                Routes.addProduct,
      //              );
      //              if (result != null) {
      //                //await _getItems();
      //              }
      //            },
      //            child: Container(
      //              decoration: BoxDecoration(
      //                shape: BoxShape.circle,
      //                color: AppColors.primaryColor,
      //              ),
      //              child: Icon(Icons.add),
      //            ),
      //          ),
      //        ],
      //      )
      //    : null,
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: AppColors.primaryColorDark,
      unselectedItemColor: AppColors.surface,
      selectedItemColor: AppColors.secondColor,
      //selectedFontSize: 20,
      //showSelectedLabels: false,
      selectedLabelStyle: AppTextStyle.label(fontWeight: FontWeight.bold),
      selectedIconTheme: IconThemeData(size: 28),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.barcode_reader),
          label: 'Escanear',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ajustes',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
