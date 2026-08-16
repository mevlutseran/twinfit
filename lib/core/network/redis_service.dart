import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class RedisService {
  static final RedisService instance = RedisService._internal();
  RedisService._internal();

  final String _baseUrl = AppConstants.upstashRedisRestUrl;
  final String _token = AppConstants.upstashRedisRestToken;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      };

  /// Set key with optional TTL (in seconds)
  Future<bool> set(String key, dynamic value, {int? ttlSeconds}) async {
    try {
      final jsonVal = jsonEncode(value);
      String url = '$_baseUrl/set/$key';
      if (ttlSeconds != null) {
        url += '?ex=$ttlSeconds';
      }

      final res = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: jsonVal,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['result'] == 'OK';
      }
      return false;
    } catch (e) {
      debugPrint('Redis SET error for key $key: $e');
      return false;
    }
  }

  /// Get key value
  Future<dynamic> get(String key) async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/get/$key'),
        headers: _headers,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final result = data['result'];
        if (result == null) return null;
        try {
          return jsonDecode(result);
        } catch (_) {
          return result;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Redis GET error for key $key: $e');
      return null;
    }
  }

  /// Delete key
  Future<bool> delete(String key) async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/del/$key'),
        headers: _headers,
      );
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('Redis DEL error: $e');
      return false;
    }
  }
}
