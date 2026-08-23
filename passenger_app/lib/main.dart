import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/tracking_provider.dart';
import 'providers/bus_provider.dart';
import 'providers/map_provider.dart';
import 'providers/timetable_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/recent_search_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/driver_provider.dart';
import 'providers/admin_provider.dart';
import 'services/notification_service.dart';
import 'utils/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Initialize Notification Service
  NotificationService().init();

  runApp(const SmartBusApp());
}

class SmartBusApp extends StatelessWidget {
  const SmartBusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrackingProvider()),
        ChangeNotifierProvider(create: (_) => BusListProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider("default_bus")),
        ChangeNotifierProvider(create: (_) => TimetableProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => RecentSearchProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => DriverProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        title: 'Smart Bus',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // Assuming AppTheme is defined
        home: const DashboardScreen(),
      ),
    );
  }
}
