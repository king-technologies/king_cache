// Copyright (c) 2025 kingtechnologies.dev
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show Response, get, post, put, delete, patch;
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart' show LaunchMode, launchUrl;

import 'src/cache/cache_manager.dart' show CacheManager;
import 'src/cache/cache_manager_impl.dart' show CacheManagerImpl;

part 'src/analytics_engine.dart';
part 'src/custom_widget.dart';
part 'src/enums.dart';
part 'src/extensions/date_time_ext.dart';
part 'src/extensions/duration_ext.dart';
part 'src/extensions/int_ext.dart';
part 'src/extensions/string_ext.dart';
part 'src/global_methods.dart';
part 'src/log_methods.dart';
part 'src/model/response_model.dart';
part 'src/services/cache_service.dart';
part 'src/services/cache_via_rest_service.dart';
part 'src/services/network_service.dart';
part 'src/utils.dart';
