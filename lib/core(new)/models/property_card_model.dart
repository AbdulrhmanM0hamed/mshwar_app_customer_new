/// Model موحد لعرض كروت العقارات في جميع أنحاء التطبيق
library;

import 'package:flutter/foundation.dart';

/// Model for property input (specs like area, rooms, etc.)
class PropertyInputModel {
  final int id;
  final String image;
  final String key;
  final String value;

  const PropertyInputModel({
    required this.id,
    required this.image,
    required this.key,
    required this.value,
  });

  factory PropertyInputModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PropertyInputModel(id: 0, image: '', key: '', value: '');
    }

    return PropertyInputModel(
      id: _SafeParser.toInt(json['id']),
      image: _SafeParser.toStr(json['image']),
      key: _SafeParser.toStr(json['key']),
      value: _SafeParser.toStr(json['value']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'key': key,
    'value': value,
  };
}

class PropertyCardModel {
  final String id;
  final String title;
  final String propertyType;
  final String listingType; // 'for_sale', 'for_rent', 'for_both'
  final int bedrooms;
  final int bathrooms;
  final double area;
  final String imageUrl;
  final String subRegion;
  final String region;
  final String city;
  final String agencyLogo;
  final String agencyName;
  final bool isFeatured;
  final bool isFav;
  final String currency;
  final double? salePrice;
  final double? rentPrice;
  final List<PropertyInputModel>? inputs;
  final String? rentDuration;
  final String? acceptance; // 'waiting', 'accepted', 'rejected', 'deleted'
  final bool hasParsingErrors;
  final int? ownerId; // Owner ID for checking if property belongs to current user

  const PropertyCardModel({
    required this.id,
    required this.title,
    required this.propertyType,
    required this.listingType,
    required this.bedrooms,
    required this.bathrooms,
    required this.subRegion,
    required this.region,
    required this.city,
    required this.area,
    required this.imageUrl,
    required this.agencyLogo,
    required this.agencyName,
    required this.isFeatured,
    this.isFav = false,
    this.currency = 'EGP',
    this.salePrice,
    this.rentPrice,
    this.inputs,
    this.rentDuration,
    this.acceptance,
    this.hasParsingErrors = false,
    this.ownerId,
  });

  // ============== Computed Getters ==============

  /// Full location (no duplicates)
  String get location {
    final parts = <String>[];
    if (subRegion.isNotEmpty) parts.add(subRegion);
    if (region.isNotEmpty && region != subRegion) parts.add(region);
    if (city.isNotEmpty && city != region && city != subRegion) parts.add(city);
    return parts.join('، ');
  }

  /// Short location (region + city only, no duplicates)
  String get shortLocation {
    if (region.isNotEmpty && city.isNotEmpty && region != city) {
      return '$region، $city';
    }
    return region.isNotEmpty ? region : city;
  }

  /// Display price based on listing type
  double get displayPrice {
    if (listingType == 'for_sale') return salePrice ?? 0;
    if (listingType == 'for_rent') return rentPrice ?? 0;
    return salePrice ?? rentPrice ?? 0;
  }

  /// Valid for display (must have id + title)
  bool get isValid => id.trim().isNotEmpty && title.trim().isNotEmpty;

  // ============== Copy & Serialization ==============

  PropertyCardModel copyWith({bool? isFav}) {
    return PropertyCardModel(
      id: id,
      title: title,
      propertyType: propertyType,
      listingType: listingType,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      subRegion: subRegion,
      region: region,
      city: city,
      area: area,
      imageUrl: imageUrl,
      agencyLogo: agencyLogo,
      agencyName: agencyName,
      isFeatured: isFeatured,
      isFav: isFav ?? this.isFav,
      currency: currency,
      salePrice: salePrice,
      rentPrice: rentPrice,
      inputs: inputs,
      rentDuration: rentDuration,
      acceptance: acceptance ?? acceptance,
      hasParsingErrors: hasParsingErrors,
      ownerId: ownerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'region': region,
      'city': city,
      'sub_region': subRegion,
      'sale_price': salePrice,
      'rent_price': rentPrice,
      'rent_duration': rentDuration,
      'property_type': propertyType,
      'for_what': listingType,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'primary_image': imageUrl,
      'owner': {'logo': agencyLogo, 'company_name': agencyName},
      'priority': isFeatured ? 'featured' : 'normal',
      'is_fav': isFav,
      'currency': currency,
      'acceptance': acceptance,
      'inputs': inputs?.map((e) => e.toJson()).toList(),
    };
  }

  // ============== Factory Constructors ==============

  factory PropertyCardModel.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return _empty(hasErrors: true);

    try {
      final owner = _SafeParser.toMap(json['owner']);
      final forWhat = _SafeParser.toStr(json['for_what']);
      final id = _SafeParser.toStr(json['id']);

      return PropertyCardModel(
        id: id,
        title: _SafeParser.toStr(json['title']),
        region: _SafeParser.toStr(json['region']),
        city: _SafeParser.toStr(json['city']),
        subRegion: _SafeParser.toStr(json['sub_region']),
        propertyType: _SafeParser.toStr(json['property_type']),
        listingType: _normalizeListingType(forWhat),
        bedrooms: _SafeParser.toInt(json['bedrooms']),
        bathrooms: _SafeParser.toInt(json['bathrooms']),
        area: _SafeParser.toDouble(json['area']),
        imageUrl: _SafeParser.toStr(json['primary_image']),
        agencyLogo: _SafeParser.toStr(owner['logo']),
        agencyName: _SafeParser.toStr(owner['company_name']),
        isFeatured: json['priority'] == 'featured',
        isFav: json['is_fav'] == true,
        currency: _SafeParser.toStr(json['currency'], fallback: 'EGP'),
        salePrice: _SafeParser.toDoubleOrNull(json['sale_price']),
        rentPrice: _SafeParser.toDoubleOrNull(json['rent_price']),
        inputs: _parseInputs(json['inputs']),
        rentDuration: _SafeParser.toStr(json['rent_duration']),
        acceptance: _SafeParser.toStr(json['acceptance']),
        hasParsingErrors: id.isEmpty,
        ownerId: _SafeParser.toIntOrNull(owner['id']),
      );
    } catch (e, st) {
      _log('Error parsing JSON', e, st);
      return _empty(hasErrors: true);
    }
  }

  /// Returns null if invalid
  static PropertyCardModel? tryFromJson(Map<String, dynamic>? json) {
    try {
      final model = PropertyCardModel.fromJson(json);
      return model.isValid ? model : null;
    } catch (_) {
      return null;
    }
  }

  /// Parse list - skips invalid
  static List<PropertyCardModel> fromJsonList(List<dynamic>? list) {
    if (list == null || list.isEmpty) return [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(tryFromJson)
        .whereType<PropertyCardModel>()
        .toList();
  }

  /// From CompanyProperty
  factory PropertyCardModel.fromCompanyProperty(dynamic cp) {
    if (cp == null) return _empty(hasErrors: true);

    try {
      final forWhat = _SafeParser.toStr(cp.forWhat, fallback: 'for_sale');

      return PropertyCardModel(
        id: _SafeParser.toStr(cp.id),
        title: _SafeParser.toStr(cp.title),
        region: _SafeParser.toStr(cp.region),
        city: _SafeParser.toStr(cp.city),
        subRegion: _SafeParser.toStr(cp.subRegion),
        propertyType: _SafeParser.toStr(cp.propertyType),
        listingType: forWhat,
        bedrooms: 0,
        bathrooms: 0,
        area: 0,
        imageUrl: _SafeParser.toStr(cp.primaryImage),
        agencyLogo: _SafeParser.toStr(cp.owner?.logo),
        agencyName: _SafeParser.toStr(cp.owner?.companyName),
        isFeatured: cp.priority == 'featured',
        isFav: cp.isFav == true,
        currency: _SafeParser.toStr(cp.currency, fallback: 'EGP'),
        salePrice: _SafeParser.toDoubleOrNull(cp.salePrice),
        rentPrice: _SafeParser.toDoubleOrNull(cp.rentPrice),
        rentDuration: _SafeParser.toStr(cp.rentDuration),
        acceptance:
            null, // CompanyProperty doesn't have acceptance status typically
        // CompanyProperty doesn't have inputs field
      );
    } catch (e, st) {
      _log('Error parsing CompanyProperty', e, st);
      return _empty(hasErrors: true);
    }
  }

  static PropertyCardModel? tryFromCompanyProperty(dynamic cp) {
    try {
      final model = PropertyCardModel.fromCompanyProperty(cp);
      return model.isValid ? model : null;
    } catch (_) {
      return null;
    }
  }

  static List<PropertyCardModel> fromCompanyPropertyList(List<dynamic>? list) {
    if (list == null || list.isEmpty) return [];
    return list
        .map(tryFromCompanyProperty)
        .whereType<PropertyCardModel>()
        .toList();
  }

  /// From old PropertyModel
  factory PropertyCardModel.fromPropertyModel(dynamic pm) {
    if (pm == null) return _empty(hasErrors: true);

    try {
      return PropertyCardModel(
        id: _SafeParser.toStr(pm.id),
        title: _SafeParser.toStr(pm.name),
        region: '',
        city: '',
        subRegion: '',
        propertyType: _SafeParser.toStr(pm.propertyType),
        listingType: _normalizeListingType(_SafeParser.toStr(pm.listingType)),
        bedrooms: _SafeParser.toInt(pm.bedrooms),
        bathrooms: _SafeParser.toInt(pm.bathrooms),
        area: _SafeParser.toDouble(pm.area),
        imageUrl: _SafeParser.toStr(pm.imageUrl),
        agencyLogo: _SafeParser.toStr(pm.agencyLogo),
        agencyName: _SafeParser.toStr(pm.agencyName),
        isFeatured: pm.isFeatured == true,
        currency: 'EGP',
      );
    } catch (e, st) {
      _log('Error parsing PropertyModel', e, st);
      return _empty(hasErrors: true);
    }
  }

  // ============== Private Helpers ==============

  static PropertyCardModel _empty({bool hasErrors = false}) {
    return PropertyCardModel(
      id: '',
      title: '',
      region: '',
      city: '',
      subRegion: '',
      propertyType: '',
      listingType: 'for_sale',
      bedrooms: 0,
      bathrooms: 0,
      area: 0,
      imageUrl: '',
      agencyLogo: '',
      agencyName: '',
      isFeatured: false,
      acceptance: null,
      hasParsingErrors: hasErrors,
    );
  }

  static List<PropertyInputModel>? _parseInputs(dynamic inputs) {
    if (inputs == null || inputs is! List) return null;
    final result = inputs
        .whereType<Map<String, dynamic>>()
        .map((e) => PropertyInputModel.fromJson(e))
        .where((m) => m.key.isNotEmpty)
        .toList();
    return result.isEmpty ? null : result;
  }

  static String _normalizeListingType(String type) {
    final t = type.toLowerCase().trim();
    if (t == 'sale' || t == 'بيع' || t == 'for_sale') return 'for_sale';
    if (t == 'rent' || t == 'إيجار' || t == 'for_rent') return 'for_rent';
    if (t == 'both' || t == 'for_both') return 'for_both';
    return 'for_sale';
  }

  static void _log(String msg, dynamic e, [StackTrace? st]) {
    if (kDebugMode) {
      //debug//print('⚠️ PropertyCardModel: $msg → $e');
    }
  }

  @override
  String toString() =>
      'PropertyCardModel(id: $id, title: $title, valid: $isValid)';
}

// ============== Safe Parser ==============

class _SafeParser {
  static String toStr(dynamic v, {String fallback = ''}) {
    if (v == null) return fallback;
    final s = v.toString();
    return (s == 'null' || s.isEmpty) ? fallback : s;
  }

  static int toInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  static int? toIntOrNull(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static double toDouble(dynamic v, {double fallback = 0.0}) {
    if (v == null) return fallback;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? fallback;
    return fallback;
  }

  static double? toDoubleOrNull(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static Map<String, dynamic> toMap(dynamic v) {
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return v.map((k, v) => MapEntry(k.toString(), v));
    return {};
  }
}
