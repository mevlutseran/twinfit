import 'package:flutter/foundation.dart';
import '../network/supabase_service.dart';
import 'local_storage_service.dart';
import '../constants/app_constants.dart';

class OfflineSyncService {
  static final OfflineSyncService instance = OfflineSyncService._internal();
  OfflineSyncService._internal();

  /// Add pending workout log to offline sync queue
  Future<void> enqueueWorkoutLog(Map<String, dynamic> logData) async {
    try {
      final List<dynamic> queue = LocalStorageService.getJson(AppConstants.keyOfflineQueue) ?? [];
      queue.add({
        ...logData,
        'queued_at': DateTime.now().toIso8601String(),
      });
      await LocalStorageService.saveJson(AppConstants.keyOfflineQueue, queue);
      debugPrint('Enqueued offline log. Queue size: ${queue.length}');
    } catch (e) {
      debugPrint('Error enqueuing offline log: $e');
    }
  }

  /// Get pending queue size
  int get pendingItemsCount {
    final List<dynamic>? queue = LocalStorageService.getJson(AppConstants.keyOfflineQueue);
    return queue?.length ?? 0;
  }

  /// Synchronize all pending items to Supabase when network is back
  Future<int> syncAllPending() async {
    final List<dynamic>? queue = LocalStorageService.getJson(AppConstants.keyOfflineQueue);
    if (queue == null || queue.isEmpty) return 0;

    int syncedCount = 0;
    final List<dynamic> remaining = [];

    for (final item in queue) {
      try {
        final Map<String, dynamic> map = Map<String, dynamic>.from(item);
        final table = map['sync_table'] ?? 'workout_set_logs';
        map.remove('sync_table');
        map.remove('queued_at');

        await SupabaseService.client.from(table).insert(map);
        syncedCount++;
      } catch (e) {
        debugPrint('Failed to sync item: $e');
        remaining.add(item);
      }
    }

    await LocalStorageService.saveJson(AppConstants.keyOfflineQueue, remaining);
    debugPrint('Synced $syncedCount items. Remaining: ${remaining.length}');
    return syncedCount;
  }
}
