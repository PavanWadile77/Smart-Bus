import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recent_search.dart';
import '../services/recent_search_service.dart';

class RecentSearchProvider extends ChangeNotifier {
  final RecentSearchService _recentSearchService = RecentSearchService();
  List<RecentSearch> _searches = [];
  List<RecentSearch> get searches => _searches;

  RecentSearchProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _recentSearchService.getRecentSearches(user.uid).listen((searches) {
          _searches = searches;
          notifyListeners();
        });
      } else {
        _searches = [];
        notifyListeners();
      }
    });
  }

  Future<void> addSearch(String busId, String routeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final search = RecentSearch(
      busId: busId,
      routeId: routeId,
      timestamp: DateTime.now(),
    );
    await _recentSearchService.addSearch(user.uid, search);
  }

  Future<void> clearSearches() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _recentSearchService.clearSearches(user.uid);
  }
}
