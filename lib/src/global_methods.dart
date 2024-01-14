part of '../king_cache.dart';

bool get applicationDocumentSupport =>
    Platform.isAndroid ||
    Platform.isIOS ||
    Platform.isFuchsia ||
    Platform.isMacOS;
