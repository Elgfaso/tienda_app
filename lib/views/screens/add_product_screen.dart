import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';

import '../../config/locator.dart';
import '../../data/models/item.dart';
import '../../data/services/dialog_service.dart';
import '../../data/services/item_service.dart';
import '../global/app_colors.dart';
import '../global/app_text_style.dart';
import '../global/utils/dimens.dart';
import '../global/widgets/local_button.dart';
import '../global/widgets/local_input_field.dart';
import '../routes/routes.dart';
import 'package:path/path.dart' as path;

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, this.item});
  final Item? item;
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  //final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _image;
  String? _previusImg;

  bool _isEdit = false;

  List<Item> _originList = [];
  @override
  void initState() {
    super.initState();
    _originList = List.from(locator<ItemService>().items);
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _priceController.text = widget.item!.price;
      _barcodeController.text = widget.item!.barcode;
      if (widget.item!.image.isNotEmpty) {
        _previusImg = widget.item!.image;
        _image = File(widget.item!.image);
      }

      setState(() {
        _isEdit = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.of(context).popUntilWithResult<bool>(
                ModalRoute.withName(Routes.home),
                true,
              );
            }
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEdit ? 'Editar producto' : 'Agregar producto',
            style: AppTextStyle.titleAppBar,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: hSpaceNormal,
              vertical: wSpaceNormal,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        LocalTextInputField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.sentences,
                          label: 'Nombre',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Introduzca el nombre';
                            }
                            return null;
                          },
                        ),
                        VerticalSpace.normal,
                        LocalTextInputField(
                          controller: _priceController,
                          label: 'Precio',
                          inputType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Introduzca el precio';
                            }

                            final number = double.tryParse(value);
                            if (number == null) {
                              return 'El precio debe ser un número';
                            }
                            if (number == 0) {
                              return 'El precio no puede ser cero';
                            }
                            return null;
                          },
                        ),
                        VerticalSpace.large,

                        Text(
                          '*Campos opcionales',
                          style: AppTextStyle.label(fontSize: 20),
                        ),
                        VerticalSpace.half,
                        Text(
                          'Código',
                          style: AppTextStyle.label(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: LocalTextInputField(
                                controller: _barcodeController,
                                hint: 'Código',
                                //label: 'Código',
                              ),
                            ),
                            HorizontalSpace.half,
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  Routes.scanner,
                                );

                                if (result != null && result is Barcode) {
                                  setState(() {
                                    _barcodeController.text =
                                        result.rawValue ?? '';
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.primaryColor,
                                ),

                                child: Icon(
                                  Icons.barcode_reader,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        VerticalSpace.normal,
                        //LocalTextInputField(
                        //  controller: _descriptionController,
                        //  label: 'Descripción',
                        //),

                        //VerticalSpace.normal,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Imágen',
                            style: AppTextStyle.label(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_isEdit && _previusImg == _image?.path) {
                              locator<DialogService>().showConfirm(
                                title: 'Aviso',
                                message: 'Se eliminara la imágen previa',
                                onConfirmPressed: () async {
                                  final result = await locator<ItemService>()
                                      .deleteProductImage(
                                        widget.item!.image,
                                      );
                                  if (result) {
                                    final newItem = widget.item!.copyWith(
                                      image: '',
                                    );
                                    await locator<ItemService>().updateItem(
                                      newItem,
                                    );
                                    setState(() {
                                      _image = null;
                                    });
                                    _modalBottomMenu();
                                  } else {
                                    Future.delayed(
                                      Duration(milliseconds: 200),
                                      () {
                                        locator<DialogService>().showAlert(
                                          title: 'Error',
                                          message:
                                              'Error al eliminar la imágen',
                                        );
                                      },
                                    );
                                  }
                                },
                              );
                            } else {
                              _modalBottomMenu();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: AppColors.textColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Seleccionar imágen',
                                  style: AppTextStyle.label(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        VerticalSpace.normal,
                        if (_image != null)
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 250,
                                    height: 220,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 4,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(
                                            10,
                                          ),
                                      child: Image.file(
                                        _image!,
                                        fit: BoxFit.fill,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Text(
                                                'Error al cargar la imágen',
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    if (_isEdit &&
                                        _previusImg == _image?.path) {
                                      locator<DialogService>().showConfirm(
                                        title: 'Eliminar imágen',
                                        message:
                                            'Se eliminara la imágen, esta acción no puede revertirse',
                                        onConfirmPressed: () async {
                                          final result =
                                              await locator<ItemService>()
                                                  .deleteProductImage(
                                                    widget.item!.image,
                                                  );
                                          if (result) {
                                            final newItem = widget.item!
                                                .copyWith(
                                                  image: '',
                                                );
                                            await locator<ItemService>()
                                                .updateItem(newItem);
                                            setState(() {
                                              _image = null;
                                            });
                                          } else {
                                            Future.delayed(
                                              Duration(milliseconds: 200),
                                              () {
                                                locator<DialogService>().showAlert(
                                                  title: 'Error',
                                                  message:
                                                      'Error al eliminar la imágen',
                                                );
                                              },
                                            );
                                          }
                                        },
                                      );
                                    } else {
                                      setState(() {
                                        _image = null;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.errorColor,
                                      shape: BoxShape.circle,
                                      //borderRadius: BorderRadius.circular(15)
                                    ),

                                    child: Icon(
                                      Icons.remove,
                                      color: AppColors.backgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                LocalButton(
                  _isEdit ? 'Editar' : 'Agregar',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final name = _nameController.text.toLowerCase().trim();
                      final barcode = _barcodeController.text.trim();
                      bool nameHasExist = _originList.any(
                        (item) => item.name.toLowerCase().trim() == name,
                      );
                      bool barcodeHasExist = false;

                      if (barcode != '') {
                        barcodeHasExist = _originList.any(
                          (item) => item.barcode == barcode,
                        );
                      }

                      if (nameHasExist) {
                        locator<DialogService>().showAlert(
                          title: 'Nombre duplicado',
                          message: 'Ya existe un producto con ese nombre',
                        );
                      } else if (barcodeHasExist) {
                        locator<DialogService>().showAlert(
                          title: 'Código de barras duplicado',
                          message:
                              'Ya existe un producto con ese código de barras',
                        );
                      } else {
                        if (_isEdit) {
                          _editItem();
                        } else {
                          _saveItem();
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _modalBottomMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _createTile(
              name: 'Tomar Foto',
              action: () {
                _pickImage(ImageSource.camera);
              },
            ),
            _createTile(
              name: 'Seleccionar imagen',
              action: () {
                _pickImage(ImageSource.gallery);
              },
            ),
            Container(
              color: AppColors.hintTextColor,
              width: double.maxFinite,
              height: 4,
            ),
            _createTile(),
          ],
        );
      },
    );
  }

  Widget _createTile({String? name = 'Cancelar', Function? action}) {
    return ListTile(
      tileColor: Colors.white,
      // leading: Icon(icon),
      title: Text(
        name!,
        style: AppTextStyle.label(
          fontSize: 20,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      onTap: () {
        Navigator.of(context).pop();
        if (action != null) {
          action();
        }
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? selected = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 70,
    );
    if (selected != null) {
      final image = File(selected.path);

      setState(() {
        _image = image;
      });
    }
  }

  Future<void> _saveItem() async {
    setState(() {
      locator<DialogService>().showLoadingDialog(
        text: 'Agregando producto',
      );
    });

    final id = DateTime.now().millisecondsSinceEpoch;
    File? savedImage;
    if (_image != null) {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String imagesDirectoryPath = path.join(
        appDocDir.path,
        'tienda_img',
      );
      final Directory imagesDir = Directory(imagesDirectoryPath);

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final String fileName = '$id${path.extension(_image!.path)}';
      final String localPath = path.join(imagesDir.path, fileName);

      savedImage = await File(_image!.path).copy(localPath);
    }

    Item item = Item(
      id: id,
      name: _nameController.text.trim(),
      barcode: _barcodeController.text.trim(),
      description: '',
      price: _priceController.text.trim(),
      image: savedImage != null ? savedImage.path : '',
    );

    await Future.delayed(Duration(seconds: 1), () {
      locator<ItemService>().saveItem(item);
    });

    setState(() {
      locator<DialogService>().dismissDialog();
      Navigator.of(context).popUntilWithResult<bool>(
        ModalRoute.withName(Routes.home),
        true,
      );
    });
  }

  Future<void> _editItem() async {
    try {
      setState(() {
        locator<DialogService>().showLoadingDialog(
          text: 'Editando producto',
        );
      });

      File? savedImage;
      if (_image != null && _previusImg != _image?.path) {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String imagesDirectoryPath = path.join(
          appDocDir.path,
          'tienda_img',
        );
        final Directory imagesDir = Directory(imagesDirectoryPath);

        if (!await imagesDir.exists()) {
          await imagesDir.create(recursive: true);
        }

        final String fileName =
            '${widget.item!.id}${path.extension(_image!.path)}';
        final String localPath = path.join(imagesDir.path, fileName);

        savedImage = await File(_image!.path).copy(localPath);
      }

      final newItem = widget.item!.copyWith(
        name: _nameController.text.trim(),
        barcode: _barcodeController.text.trim(),
        description: '',
        price: _priceController.text.trim(),
        image: savedImage != null ? savedImage.path : '',
      );

      await Future.delayed(Duration(seconds: 1), () {
        locator<ItemService>().updateItem(newItem);
      });

      setState(() {
        locator<DialogService>().dismissDialog();
        Navigator.pop(context, [true]);
      });
    } catch (e) {
      locator<DialogService>().dismissDialog();
      Future.delayed(Duration(milliseconds: 100), () {
        locator<DialogService>().showAlert(
          title: 'Error',
          message: 'Hubo un error al editar el producto',
        );
      });
    }
  }
}
