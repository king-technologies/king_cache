// Copyright (c) 2024 kingtechnologies.dev
// All rights reserved.
// Use of this source code is governed by aMIT license that can be
// found in the LICENSE file.

// KingCache Library
library king_cache;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'src/cache_manager.dart';
import 'src/cache_via_rest.dart';
import 'src/log_methods.dart';

export 'src/cache_manager.dart';

part 'src/analytics_engine.dart';
part 'src/custom_widget.dart';
part 'src/enums.dart';
part 'src/extensions/date_time_ext.dart';
part 'src/extensions/duration_ext.dart';
part 'src/extensions/int_ext.dart';
part 'src/extensions/string_ext.dart';
part 'src/global_methods.dart';
part 'src/king_cache.dart';
part 'src/network_request.dart';
part 'src/response_model.dart';
