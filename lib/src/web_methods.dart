import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart';

import '../king_cache.dart';

class WebCacheManager implements ICacheManagerWeb {
  WebCacheManager();
  late IDBDatabase _db;
  bool _initiated = false;
  bool get initiated => _initiated;
  final String dbName = 'king_cache';
  final int version = 1;
  Future<IDBDatabase?> init() async {
    if (_initiated) {
      return _db;
    }

    final req = window.indexedDB.open(dbName, version);

    void onupgradeneeded(IDBVersionChangeEvent e) {
      final db = (e.target! as IDBOpenDBRequest).result! as IDBDatabase;
      for (final element in IndexedDbKeys.values) {
        if (!db.objectStoreNames.contains(element.name)) {
          db.createObjectStore(element.name);
        }
      }
    }

    req.onupgradeneeded = onupgradeneeded.toJS;

    var ok = false;
    var handled = false;

    void onsuccess(Event _) {
      _db = req.result! as IDBDatabase;
      _initiated = true;
      ok = true;
      handled = true;
    }

    void onerror(Event _) {
      handled = true;
    }

    req.onsuccess = onsuccess.toJS;
    req.onerror = onerror.toJS;

    FutureOr<bool> waitResult() {
      if (handled) {
        return ok;
      }
      return Future.delayed(const Duration(milliseconds: 1), waitResult);
    }

    await Future.microtask(waitResult);
    if (ok) {
      return _db;
    }
    return null;
  }

  Future<JSAny?> _waitRequest(IDBRequest request) async {
    var ok = false;
    var handled = false;
    void onsuccess(Event _) {
      ok = true;
      handled = true;
    }

    void onerror(Event _) {
      handled = true;
    }

    request.onsuccess = onsuccess.toJS;
    request.onerror = onerror.toJS;

    FutureOr<bool> waitResult() {
      if (handled) {
        return ok;
      }
      return Future.delayed(const Duration(milliseconds: 1), waitResult);
    }

    await Future.microtask(waitResult);
    if (ok) {
      return request.result;
    } else {
      _initiated = false;
    }
    return null;
  }

  Future<JSAny?> put(String table, JSAny value, {JSAny? key}) async {
    await init();
    final tx = _db.transaction([table.toJS].toJS, 'readwrite');
    final store = tx.objectStore(table);
    final req = key == null ? store.put(value) : store.put(value, key);
    return _waitRequest(req);
  }

  Future<void> clear(String table) async {
    final tx = _db.transaction([table.toJS].toJS, 'readwrite');
    final store = tx.objectStore(table);
    final req = store.clear();
    await _waitRequest(req);
  }

  Future<void> delete(String table, JSAny key) async {
    final tx = _db.transaction([table.toJS].toJS, 'readwrite');
    final store = tx.objectStore(table);
    final req = store.delete(key);
    await _waitRequest(req);
  }

  Future<JSArray<JSAny?>> getAllKeys(
    String table, {
    JSAny? query,
    int? count,
  }) async {
    await init();
    final tx = _db.transaction([table.toJS].toJS, 'readonly');
    final store = tx.objectStore(table);
    final req = query != null && count != null
        ? store.getAllKeys(query, count)
        : query != null
            ? store.getAllKeys(query)
            : store.getAllKeys();
    final r = await _waitRequest(req);
    return r! as JSArray<JSAny?>;
  }

  @override
  Future<String> get getLogs async {
    final db = await init();
    if (db == null) {
      return '';
    }
    final tx = db.transaction(['logs'.toJS].toJS, 'readonly');
    final store = tx.objectStore('logs');
    final req = store.getAll();
    final r = await _waitRequest(req);
    if (r == null) {
      return '';
    }
    return (r as List? ?? []).cast<String>().join('\n');
  }

  @override
  Future<void> get clearLog async {
    await init();
    final tableName = IndexedDbKeys.logs.name;
    final tx = _db.transaction([tableName.toJS].toJS, 'readwrite');
    final store = tx.objectStore(tableName);
    final req = store.clear();
    await _waitRequest(req);
  }

  @override
  Future<void> get clearAllCache async {
    await init();
    final tableName = IndexedDbKeys.cache.name;
    final tx = _db.transaction([tableName.toJS].toJS, 'readwrite');
    final store = tx.objectStore(tableName);
    final req = store.clear();
    await _waitRequest(req);
  }

  @override
  Future<String?> getCache(String tableName) async {
    await init();
    final tx = _db.transaction([tableName.toJS].toJS, 'readonly');
    final store = tx.objectStore(tableName);
    final req = store.getAll();
    final r = await _waitRequest(req);
    if (r == null) {
      return null;
    }
    return (r as List? ?? []).cast<String>().join('\n');
  }

  @override
  Future<void> setCache(String key, String data) async {
    await init();
    final tableName = IndexedDbKeys.cache.name;
    final tx = _db.transaction([tableName.toJS].toJS, 'readwrite');
    final store = tx.objectStore(tableName);
    final req = store.put(data.toJS, key.toJS);
    await _waitRequest(req);
  }

  @override
  Future<void> removeCache(String key) async {
    await init();
    final tx = _db.transaction(key as JSAny, 'readwrite');
    final store = tx.objectStore(key);
    final req = store.clear();
    await _waitRequest(req);
  }

  @override
  Future<bool> hasCache(String key) async {
    await init();
    final tableName = IndexedDbKeys.cache.name;
    final tx = _db.transaction([tableName.toJS].toJS, 'readonly');
    final store = tx.objectStore(tableName);
    final req = store.getAllKeys();
    final r = await _waitRequest(req);
    final keys = r as List? ?? [];
    return keys.contains(key);
  }

  @override
  Future<List<String>> getCacheKeys() async {
    await init();
    final tableName = IndexedDbKeys.cache.name;
    final tx = _db.transaction([tableName.toJS].toJS, 'readonly');
    final store = tx.objectStore(tableName);
    final req = store.getAllKeys();
    final r = await _waitRequest(req);
    if (r == null) {
      return [];
    }
    return (r as List? ?? []).cast<String>();
  }

  @override
  Future<void> storeLog(String log,
      {LogLevel level = LogLevel.info, String? key}) async {
    await init();
    final tableName = IndexedDbKeys.logs.name;
    final tx = _db.transaction([tableName.toJS].toJS, 'readwrite');
    final x = tx.objectStore(tableName);
    final keyToBeUsed = key ?? DateTime.now().toIso8601String();
    final req = x.put(log.toJS, keyToBeUsed.toJS);
    await _waitRequest(req);
  }

  Future<bool> makeStoragePersist() async {
    final storage = window.navigator.storage;
    var persisted = (await storage.persisted().toDart).toDart;
    if (!persisted) {
      persisted = (await storage.persist().toDart).toDart;
    }
    return persisted;
  }
}
