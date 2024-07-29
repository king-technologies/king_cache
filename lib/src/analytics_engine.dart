part of '../king_cache.dart';

class AnalyticsEngine {
  static final _instance = FirebaseAnalytics.instance;

  static Future<void> init(String id) async {
    if (firebaseCrashlyticsSupport) {
      await _instance.setAnalyticsCollectionEnabled(true);
      await KingCache().storeLog('id: $id');
      await _instance.setUserId(id: id);
    }
  }

  static void apiError(Map<String, Object> parameters) {
    if (firebaseCrashlyticsSupport) {
      KingCache().storeLog('apiError: $parameters');
      _instance.logEvent(name: 'api_error', parameters: parameters);
    }
  }

  static void exception(String message) {
    if (firebaseCrashlyticsSupport) {
      KingCache().storeLog('exception: $message');
      _instance.logEvent(name: 'exception', parameters: {'message': message});
    }
  }

  static void toastMessage(String message) {
    if (firebaseCrashlyticsSupport) {
      KingCache().storeLog('toastMessage: $message');
      _instance.logEvent(name: 'toast', parameters: {'message': message});
    }
  }

  static void checkoutLog({
    required int checkoutStep,
    required String checkoutOption,
    Map<String, Object>? parameters,
  }) {
    if (firebaseCrashlyticsSupport) {
      KingCache().storeLog('checkoutLog: $checkoutStep $checkoutOption');
      _instance.logEvent(name: 'checkout', parameters: {
        'step': checkoutStep,
        'option': checkoutOption,
        ...?parameters
      });
    }
  }
}
