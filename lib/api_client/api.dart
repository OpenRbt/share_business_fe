//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library openapi.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'api_client.dart';
part 'api_helper.dart';
part 'api_exception.dart';
part 'auth/authentication.dart';
part 'auth/api_key_auth.dart';
part 'auth/oauth.dart';
part 'auth/http_basic_auth.dart';
part 'auth/http_bearer_auth.dart';

part 'api/organizations_api.dart';
part 'api/server_groups_api.dart';
part 'api/sessions_api.dart';
part 'api/standard_api.dart';
part 'api/users_api.dart';
part 'api/wallets_api.dart';
part 'api/wash_servers_api.dart';

part 'model/bonus_charge.dart';
part 'model/error.dart';
part 'model/health_check200_response.dart';
part 'model/organization.dart';
part 'model/organization_creation.dart';
part 'model/organization_update.dart';
part 'model/pagination.dart';
part 'model/server_group.dart';
part 'model/server_group_creation.dart';
part 'model/server_group_update.dart';
part 'model/session.dart';
part 'model/user.dart';
part 'model/user_role_update.dart';
part 'model/wallet.dart';
part 'model/wash_server.dart';
part 'model/wash_server_creation.dart';
part 'model/wash_server_update.dart';


const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

ApiClient defaultApiClient = ApiClient();
