import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_bus.dart';

import 'dart:async';

class FavoritesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFavorite(String uid, FavoriteBus favorite) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .doc(favorite.busId)
          .set(favorite.toMap(), SetOptions(merge: true))
          .timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (addFavorite): ${e.code} - ${e.message}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (addFavorite): Connection took too long.');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (addFavorite): $e');
      rethrow;
    }
  }

  Future<void> removeFavorite(String uid, String busId) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .doc(busId)
          .delete()
          .timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (removeFavorite): ${e.code} - ${e.message}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (removeFavorite): Connection took too long.');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (removeFavorite): $e');
      rethrow;
    }
  }

  Stream<List<FavoriteBus>> getUserFavorites(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .orderBy('added_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            // Basic validation
            if (data.isEmpty) return null;
            try {
              return FavoriteBus.fromMap(data);
            } catch (e) {
              debugPrint('Data Parsing Error (getUserFavorites): $e');
              return null;
            }
          }).where((item) => item != null).cast<FavoriteBus>().toList();
        })
        .handleError((error) {
          if (error is FirebaseException) {
            debugPrint('Firestore Stream Error (getUserFavorites): ${error.code}');
          } else {
            debugPrint('Unknown Stream Error (getUserFavorites): $error');
          }
        });
  }
}
