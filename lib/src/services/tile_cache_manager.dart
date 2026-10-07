import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class TileCacheManager {
  TileCacheManager._();
  static final TileCacheManager instance = TileCacheManager._();

  static const int maxCacheBytes = 150 * 1024 * 1024; // 150 MB
  final Map<String, Uint8List> _memoryCache = {};
  Directory? _cacheDir;

  Future<Directory?> get cacheDir async {
    if (kIsWeb) return null;
    if (_cacheDir != null) return _cacheDir!;
    try {
      final base = await getTemporaryDirectory();
      final dir = Directory('${base.path}/tile_cache');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      _cacheDir = dir;
      return dir;
    } catch (_) {
      return null;
    }
  }

  String _keyForUri(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.length >= 3) {
      final z = segments[segments.length - 3];
      final x = segments[segments.length - 2];
      final y = segments.last.replaceAll('.png', '');
      return 'tile_${z}_${x}_$y.png';
    }
    return 'tile_${uri.toString().hashCode}.png';
  }

  static const int maxMemoryTiles = 64;
  int _writesSinceLastPrune = 0;

  Future<Uint8List?> getCachedTile(Uri uri) async {
    final key = _keyForUri(uri);
    if (_memoryCache.containsKey(key)) {
      final bytes = _memoryCache.remove(key)!;
      _memoryCache[key] = bytes;
      return bytes;
    }
    if (kIsWeb) return null;
    try {
      final dir = await cacheDir;
      if (dir == null) return null;
      final file = File('${dir.path}/$key');
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        _memoryCache[key] = bytes;
        if (_memoryCache.length > maxMemoryTiles) {
          _memoryCache.remove(_memoryCache.keys.first);
        }
        return bytes;
      }
    } catch (_) {}
    return null;
  }

  Future<void> putCachedTile(Uri uri, Uint8List bytes) async {
    final key = _keyForUri(uri);
    _memoryCache[key] = bytes;
    if (_memoryCache.length > maxMemoryTiles) {
      _memoryCache.remove(_memoryCache.keys.first);
    }
    if (kIsWeb) return;
    try {
      final dir = await cacheDir;
      if (dir == null) return;
      final file = File('${dir.path}/$key');
      await file.writeAsBytes(bytes);
      if (++_writesSinceLastPrune >= 50) {
        _writesSinceLastPrune = 0;
        _pruneCacheIfNeeded(dir);
      }
    } catch (_) {}
  }

  Future<void> clearCache() async {
    _memoryCache.clear();
    if (kIsWeb) return;
    try {
      final dir = await cacheDir;
      if (dir != null && await dir.exists()) {
        await dir.delete(recursive: true);
        _cacheDir = null;
      }
    } catch (_) {}
  }

  void _pruneCacheIfNeeded(Directory dir) async {
    try {
      final entities = await dir.list().toList();
      var totalSize = 0;
      final files = <File>[];
      for (final e in entities) {
        if (e is File) {
          files.add(e);
          totalSize += await e.length();
        }
      }
      if (totalSize > maxCacheBytes) {
        files.sort(
          (a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()),
        );
        for (final f in files) {
          totalSize -= await f.length();
          await f.delete();
          if (totalSize <= 120 * 1024 * 1024) break;
        }
      }
    } catch (_) {}
  }
}
