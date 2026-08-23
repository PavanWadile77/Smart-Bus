import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class LocationSyncService {
  static const String cacheKey = 'offline_location_cache';

  static Future<void> syncLocation({
    required String busId,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
    required String driverId,
  }) async {
    final payload = {
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'heading': heading,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'driver_id': driverId,
      'bus_id': busId,
    };

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasInternet = !connectivityResult.contains(ConnectivityResult.none);

      if (hasInternet) {
        await _pushToFirestore(busId, latitude, longitude, speed, heading, driverId);
        await _syncCache();
      } else {
        await _cacheLocally(payload);
      }
    } catch (e) {
      debugPrint('Sync Error: $e');
      await _cacheLocally(payload);
    }
  }

  static Future<void> _pushToFirestore(
    String busId, double lat, double lng, double speed, double heading, String driverId,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('live_buses').doc(busId).set({
        'latitude': lat,
        'longitude': lng,
        'speed': speed,
        'heading': heading,
        'timestamp': FieldValue.serverTimestamp(),
        'driver_id': driverId,
      }, SetOptions(merge: true)).timeout(const Duration(seconds: 10));
    } catch (e) {
      await _cacheLocally({
        'latitude': lat,
        'longitude': lng,
        'speed': speed,
        'heading': heading,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'driver_id': driverId,
        'bus_id': busId,
      });
    }
  }

  static Future<void> _cacheLocally(Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cache = prefs.getStringList(cacheKey) ?? [];
    cache.add(jsonEncode(payload));
    await prefs.setStringList(cacheKey, cache);
  }

  static Future<void> _syncCache() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cache = prefs.getStringList(cacheKey) ?? [];
    
    if (cache.isEmpty) return;

    try {
      final lastItemRaw = cache.last;
      final lastItem = jsonDecode(lastItemRaw) as Map<String, dynamic>;
      
      await FirebaseFirestore.instance.collection('live_buses').doc(lastItem['bus_id']).set({
        'latitude': lastItem['latitude'],
        'longitude': lastItem['longitude'],
        'speed': lastItem['speed'],
        'heading': lastItem['heading'],
        'timestamp': FieldValue.serverTimestamp(), 
        'driver_id': lastItem['driver_id'],
      }, SetOptions(merge: true)).timeout(const Duration(seconds: 10));
      
      await prefs.setStringList(cacheKey, []);
    } catch (e) {
      debugPrint('Failed to sync offline cache: $e');
    }
  }
}
