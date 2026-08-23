import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/driver_model.dart';
import '../models/timetable_model.dart';
import '../services/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<DocumentSnapshot> _buses = [];
  List<DriverModel> _drivers = [];
  List<TimetableModel> _timetables = [];
  List<DocumentSnapshot> _liveBuses = [];

  List<DocumentSnapshot> get buses => _buses;
  List<DriverModel> get drivers => _drivers;
  List<TimetableModel> get timetables => _timetables;
  List<DocumentSnapshot> get liveBuses => _liveBuses;

  StreamSubscription? _busSub;
  StreamSubscription? _driverSub;
  StreamSubscription? _timetableSub;
  StreamSubscription? _liveBusSub;

  AdminProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _initListeners();
      } else {
        _cleanup();
      }
    });
  }

  void _initListeners() {
    _busSub = _adminService.getBuses().listen((snapshot) {
      _buses = snapshot.docs;
      notifyListeners();
    });

    _driverSub = _adminService.getDrivers().listen((driversList) {
      _drivers = driversList;
      notifyListeners();
    });

    _timetableSub = _adminService.getTimetables().listen((ttList) {
      _timetables = ttList;
      notifyListeners();
    });

    _liveBusSub = _adminService.getLiveBuses().listen((snapshot) {
      _liveBuses = snapshot.docs;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    await _adminService.login(email, password);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('admins').doc(user.uid).get().timeout(const Duration(seconds: 10));
        if (!doc.exists) {
          await logout();
          throw Exception('Access Denied: Admin profile not found.');
        }
        final data = doc.data();
        if (data == null || data['role'] != 'admin' || data['enabled'] != true) {
          await logout();
          throw Exception('Access Denied: Insufficient permissions or account disabled.');
        }
      } on TimeoutException {
        await logout();
        throw Exception('Access Denied: Verification timed out.');
      } catch (e) {
        await logout();
        throw Exception('Access Denied: Verification failed.');
      }
    }
  }

  Future<void> logout() async {
    await _adminService.logout();
  }

  // Wrappers
  Future<void> addBus(Map<String, dynamic> data) => _adminService.addBus(data);
  Future<void> updateBus(String id, Map<String, dynamic> data) => _adminService.updateBus(id, data);
  Future<void> deleteBus(String id) => _adminService.deleteBus(id);

  Future<void> addDriver(Map<String, dynamic> data) => _adminService.addDriver(data);
  Future<void> updateDriver(String id, Map<String, dynamic> data) => _adminService.updateDriver(id, data);
  Future<void> deleteDriver(String id) => _adminService.deleteDriver(id);

  Future<void> addTimetable(Map<String, dynamic> data) => _adminService.addTimetable(data);
  Future<void> updateTimetable(String id, Map<String, dynamic> data) => _adminService.updateTimetable(id, data);
  Future<void> deleteTimetable(String id) => _adminService.deleteTimetable(id);
  
  Future<void> sendNotification(Map<String, dynamic> payload) => _adminService.sendNotification(payload);

  void _cleanup() {
    _busSub?.cancel();
    _driverSub?.cancel();
    _timetableSub?.cancel();
    _liveBusSub?.cancel();
    _buses = [];
    _drivers = [];
    _timetables = [];
    _liveBuses = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }
}
