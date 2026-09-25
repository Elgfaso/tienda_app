import 'dart:convert';

import 'package:intl/intl.dart';

class Item {
  final int id;
  final String name;
  final String barcode;
  final String description;
  final String price;
  final String image;

  Item({
    required this.id,
    required this.name,
    required this.barcode,
    required this.description,
    required this.price,
    required this.image,
  });

  Item copyWith({
    int? id,
    String? name,
    String? barcode,
    String? description,
    String? price,
    String? image,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'description': description,
      'price': price,
      'image': image,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      barcode: map['barcode'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Item(id: $id, name: $name, barcode: $barcode, description: $description, price: $price, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item &&
        other.id == id &&
        other.name == name &&
        other.barcode == barcode &&
        other.description == description &&
        other.price == price &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        barcode.hashCode ^
        description.hashCode ^
        price.hashCode ^
        image.hashCode;
  }

  String priceFormatter() {
    // Opción A: Con símbolo $ y 2 decimales estándar
    final formatter = NumberFormat.currency(
      symbol: '\$', // Símbolo de moneda
      decimalDigits: 2, // Cantidad de decimales
    );


    // Opción B: Formato según localización (ej. México/Latinoamérica)
    final formatterEs = NumberFormat.simpleCurrency(
      locale: 'es_MX', // Ajusta separadores de miles (,) y decimales (.)
      decimalDigits: 2,
    );
    return formatterEs.format(double.tryParse(price));
  }
}
