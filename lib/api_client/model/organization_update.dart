//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OrganizationUpdate {
  /// Returns a new [OrganizationUpdate] instance.
  OrganizationUpdate({
    this.name,
    this.description,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OrganizationUpdate &&
     other.name == name &&
     other.description == description;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name == null ? 0 : name!.hashCode) +
    (description == null ? 0 : description!.hashCode);

  @override
  String toString() => 'OrganizationUpdate[name=$name, description=$description]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    return json;
  }

  /// Returns a new [OrganizationUpdate] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OrganizationUpdate? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OrganizationUpdate[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OrganizationUpdate[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OrganizationUpdate(
        name: mapValueOfType<String>(json, r'name'),
        description: mapValueOfType<String>(json, r'description'),
      );
    }
    return null;
  }

  static List<OrganizationUpdate>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OrganizationUpdate>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OrganizationUpdate.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OrganizationUpdate> mapFromJson(dynamic json) {
    final map = <String, OrganizationUpdate>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OrganizationUpdate.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OrganizationUpdate-objects as value to a dart map
  static Map<String, List<OrganizationUpdate>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OrganizationUpdate>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OrganizationUpdate.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

