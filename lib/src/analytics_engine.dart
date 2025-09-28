part of '../king_cache.dart';

class AnalyticsEngine {
  static final _instance = FirebaseAnalytics.instance;

  static Future<void> init(String id) async {
    if (firebaseCrashlyticsSupport) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      await _instance.setAnalyticsCollectionEnabled(true);
      await CacheService.storeLog('id: $id');
      await _instance.setUserId(id: id);
    }
  }

  static void apiError(Map<String, Object> parameters) {
    if (firebaseCrashlyticsSupport) {
      CacheService.storeLog('apiError: $parameters');
      _instance.logEvent(name: 'api_error', parameters: parameters);
    }
  }

  static void exception(String message) {
    if (firebaseCrashlyticsSupport) {
      CacheService.storeLog('exception: $message');
      _instance.logEvent(name: 'exception', parameters: {'message': message});
    }
  }

  static void toastMessage(String message) {
    if (firebaseCrashlyticsSupport) {
      CacheService.storeLog('toastMessage: $message');
      _instance.logEvent(name: 'toast', parameters: {'message': message});
    }
  }

  static void checkoutLog({
    required int checkoutStep,
    required String checkoutOption,
    Map<String, Object>? parameters,
  }) {
    if (firebaseCrashlyticsSupport) {
      CacheService.storeLog('checkoutLog: $checkoutStep $checkoutOption');
      _instance.logEvent(name: 'checkout', parameters: {
        'step': checkoutStep,
        'option': checkoutOption,
        ...?parameters
      });
    }
  }
}
