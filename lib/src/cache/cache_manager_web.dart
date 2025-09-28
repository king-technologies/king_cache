import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart';

import '../../king_cache.dart' show IndexedDbKeys, LogLevel;
import 'cache_manager.dart' show CacheManager;

class CacheManagerImpl implements CacheManager {
  CacheManagerImpl();
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
    await init();
    final tx = _db.transaction([table.toJS].toJS, 'readwrite');
    final store = tx.objectStore(table);
    final req = store.clear();
    await _waitRequest(req);
  }

  Future<void> delete(String table, JSAny key) async {
    await init();
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
    final req = (query != null && count != null)
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

    final tableName = IndexedDbKeys.logs.name;
    final tx = db.transaction([tableName.toJS].toJS, 'readonly');
    final store = tx.objectStore(tableName);
    final req = store.getAll();
    final r = await _waitRequest(req);

    final list = r == null ? <String>[] : (r as JSArray).toDart.cast<String>();
    return list.join('\n');
  }

  @override
  Future<void> get clearLog async {
    await clear(IndexedDbKeys.logs.name);
  }

  @override
  Future<void> get clearAllCache async {
    await clear(IndexedDbKeys.cache.name);
  }

  @override
  Future<String?> getCache(String key) async {
    await init();
    final tableName = IndexedDbKeys.cache.name;
    final tx = _db.transaction([tableName.toJS].toJS, 'readonly');
    final store = tx.objectStore(tableName);
    final req = store.get(key.toJS);
    final r = await _waitRequest(req);
    return r?.toString();
  }

  @override
  Future<void> setCache(String key, String data) async {
    await put(IndexedDbKeys.cache.name, data.toJS, key: key.toJS);
  }

  @override
  Future<void> removeCache(String key) async {
    await delete(IndexedDbKeys.cache.name, key.toJS);
  }

  @override
  Future<bool> hasCache(String key) async {
    final keys = await getCacheKeys;
    return keys.contains(key);
  }

  @override
  Future<List<String>> get getCacheKeys async {
    final r = await getAllKeys(IndexedDbKeys.cache.name);
    return r.toDart.cast<String>();
  }

  @override
  Future<void> storeLog(String log,
      {LogLevel level = LogLevel.info, String? key}) async {
    final k = key ?? DateTime.now().toIso8601String();
    await put(IndexedDbKeys.logs.name, log.toJS, key: k.toJS);
  }

  Future<bool> makeStoragePersist() async {
    final storage = window.navigator.storage;
    var persisted = (await storage.persisted().toDart).toDart;
    if (!persisted) {
      persisted = (await storage.persist().toDart).toDart;
    }
    return persisted;
  }

  @override
  Future<void> clearOldLogs({int? maxLogCount = 1000}) async {
    final db = await init();
    if (db == null) {
      return;
    }

    final tableName = IndexedDbKeys.logs.name;
    final tx = db.transaction([tableName.toJS].toJS, 'readwrite');
    final store = tx.objectStore(tableName);

    final request = store.getAll();
    final result = _waitRequest(request) as List<dynamic>?;

    if (result == null || result.isEmpty) {
      return;
    }

    final logs = result.cast<String>();
    final trimmed = logs.take(maxLogCount ?? 1000).toList();

    await _waitRequest(store.clear());

    for (var i = 0; i < trimmed.length; i++) {
      await _waitRequest(store.put(trimmed[i].toJS, i.toJS));
    }

    tx.commit();
  }
}
