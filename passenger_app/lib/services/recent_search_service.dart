import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recent_search.dart';

import 'package:flutter/material.dart';
import 'dart:async';

class RecentSearchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addSearch(String uid, RecentSearch search) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('recent_searches')
          .doc(search.busId)
          .set(search.toMap(), SetOptions(merge: true))
          .timeout(const Duration(seconds: 10));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (addSearch): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (addSearch)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (addSearch): $e');
      rethrow;
    }
  }

  Future<void> clearSearches(String uid) async {
    try {
      var snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('recent_searches')
          .get()
          .timeout(const Duration(seconds: 10));
      for (var doc in snapshot.docs) {
        await doc.reference.delete().timeout(const Duration(seconds: 5));
      }
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error (clearSearches): ${e.code}');
      rethrow;
    } on TimeoutException {
      debugPrint('Timeout Error (clearSearches)');
      rethrow;
    } catch (e) {
      debugPrint('Unknown Error (clearSearches): $e');
      rethrow;
    }
  }

  Stream<List<RecentSearch>> getRecentSearches(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('recent_searches')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            try {
              return RecentSearch.fromMap(doc.data());
            } catch (e) {
              debugPrint('Data Parsing Error (getRecentSearches): $e');
              return null;
            }
          }).where((item) => item != null).cast<RecentSearch>().toList();
        })
        .handleError((error) {
          if (error is FirebaseException) {
            debugPrint('Firestore Stream Error (getRecentSearches): ${error.code}');
          } else {
            debugPrint('Unknown Stream Error (getRecentSearches): $error');
          }
        });
  }
}
