//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Session {
  /// Returns a new [Session] instance.
  Session({
    this.washServerName,
    this.post,
    this.userBalance,
    this.postBalance,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? washServerName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? post;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? userBalance;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? postBalance;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Session &&
     other.washServerName == washServerName &&
     other.post == post &&
     other.userBalance == userBalance &&
     other.postBalance == postBalance;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (washServerName == null ? 0 : washServerName!.hashCode) +
    (post == null ? 0 : post!.hashCode) +
    (userBalance == null ? 0 : userBalance!.hashCode) +
    (postBalance == null ? 0 : postBalance!.hashCode);

  @override
  String toString() => 'Session[washServerName=$washServerName, post=$post, userBalance=$userBalance, postBalance=$postBalance]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.washServerName != null) {
      json[r'WashServerName'] = this.washServerName;
    } else {
      json[r'WashServerName'] = null;
    }
    if (this.post != null) {
      json[r'post'] = this.post;
    } else {
      json[r'post'] = null;
    }
    if (this.userBalance != null) {
      json[r'UserBalance'] = this.userBalance;
    } else {
      json[r'UserBalance'] = null;
    }
    if (this.postBalance != null) {
      json[r'PostBalance'] = this.postBalance;
    } else {
      json[r'PostBalance'] = null;
    }
    return json;
  }

  /// Returns a new [Session] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Session? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Session[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Session[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Session(
        washServerName: mapValueOfType<String>(json, r'WashServerName'),
        post: mapValueOfType<String>(json, r'post'),
        userBalance: mapValueOfType<String>(json, r'UserBalance'),
        postBalance: mapValueOfType<String>(json, r'PostBalance'),
      );
    }
    return null;
  }

  static List<Session>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Session>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Session.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Session> mapFromJson(dynamic json) {
    final map = <String, Session>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Session.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Session-objects as value to a dart map
  static Map<String, List<Session>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Session>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Session.listFromJson(entry.value, growable: growable,);
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

