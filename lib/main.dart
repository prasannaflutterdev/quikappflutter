import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'screens/splash_screen.dart';
import 'services/config_service.dart';

// Define constants for build-time configuration
const String webUrl = String.fromEnvironment(
  'WEB_URL',
  defaultValue: 'https://pixaware.co/',
);
const String appName = String.fromEnvironment(
  'APP_NAME',
  defaultValue: 'Pixaware App',
);
const String orgName = String.fromEnvironment(
  'ORG_NAME',
  defaultValue: 'Pixaware Technologies',
);
const bool isSplash = bool.fromEnvironment('IS_SPLASH', defaultValue: true);
const String splashImage = String.fromEnvironment('SPLASH', defaultValue: '');
const String splashBgColor = String.fromEnvironment(
  'SPLASH_BG_COLOR',
  defaultValue: '#cfc3ba',
);
const String splashTagline = String.fromEnvironment(
  'SPLASH_TAGLINE',
  defaultValue: 'Welcome to Pixaware',
);
const String splashTaglineColor = String.fromEnvironment(
  'SPLASH_TAGLINE_COLOR',
  defaultValue: '#E91E63',
);
const String splashAnimation = String.fromEnvironment(
  'SPLASH_ANIMATION',
  defaultValue: 'rotate',
);
const int splashDuration = int.fromEnvironment(
  'SPLASH_DURATION',
  defaultValue: 3,
);
const bool isPullToRefresh = bool.fromEnvironment(
  'IS_PULLDOWN',
  defaultValue: true,
);
const bool isBottomMenu = bool.fromEnvironment(
  'IS_BOTTOMMENU',
  defaultValue: true,
);
const bool isDeeplink = bool.fromEnvironment('IS_DEEPLINK', defaultValue: true);
const bool isLoadingIndicator = bool.fromEnvironment(
  'IS_LOAD_IND',
  defaultValue: true,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize config service
  await ConfigService.instance.initialize('YOUR_CONFIG_API_ENDPOINT');

  // Initialize Firebase if push notifications are enabled
  if (ConfigService.instance.config.isPushEnabled) {
    await Firebase.initializeApp();
    await _initializeNotifications();
  }

  runApp(const MyApp());
}

Future<void> _initializeNotifications() async {
  final messaging = FirebaseMessaging.instance;

  // Request permission
  if (ConfigService.instance.config.isNotificationEnabled) {
    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Initialize local notifications
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      const initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initializationSettingsIOS = DarwinInitializationSettings();
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isSplash ? _buildSplashScreen() : const MyHomePage(),
    );
  }

  Widget _buildSplashScreen() {
    return SplashScreen(
      splashImage: splashImage,
      tagline: splashTagline,
      taglineColor: _parseHexColor(splashTaglineColor),
      backgroundColor: _parseHexColor(splashBgColor),
      animation: splashAnimation,
      duration: splashDuration,
      onFinished: () => _navigateToHome(),
    );
  }

  void _navigateToHome() {
    runApp(const MaterialApp(home: MyHomePage()));
  }

  Color _parseHexColor(String hexColor) {
    hexColor = hexColor.replaceFirst('#', '');
    if (hexColor.length == 6) hexColor = 'FF$hexColor';
    return Color(int.parse('0x$hexColor'));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _initializeDeepLinks();
    _requestPermissions();
  }

  Future<void> _initializeDeepLinks() async {
    if (isDeeplink) {
      try {
        final initialLink = await getInitialLink();
        if (initialLink != null) {
          _handleDeepLink(initialLink);
        }

        // Listen to incoming deep links
        linkStream.listen((String? link) {
          if (link != null) {
            _handleDeepLink(link);
          }
        });
      } catch (e) {
        debugPrint('Deep linking error: $e');
      }
    }
  }

  void _handleDeepLink(String link) {
    // Handle deep link navigation here
    debugPrint('Received deep link: $link');
  }

  Future<void> _requestPermissions() async {
    final config = ConfigService.instance.config;

    if (config.isCameraEnabled) {
      await Permission.camera.request();
    }
    if (config.isLocationEnabled) {
      await Permission.location.request();
    }
    if (config.isMicrophoneEnabled) {
      await Permission.microphone.request();
    }
    if (config.isContactEnabled) {
      await Permission.contacts.request();
    }
    if (config.isCalendarEnabled) {
      await Permission.calendar.request();
    }
    if (config.isStorageEnabled) {
      await Permission.storage.request();
    }
  }

  Future<void> _onRefresh() async {
    if (!isPullToRefresh) return;

    setState(() => _isLoading = true);
    try {
      // Implement refresh logic here
      await Future.delayed(const Duration(seconds: 2)); // Simulated delay
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ConfigService.instance.config;
    final bottomMenuItems = config.bottomMenuItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: CachedNetworkImage(
          imageUrl: config.logoUrl,
          height: 40,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: Stack(
          children: [
            // Main content
            Center(child: Text('Selected index: $_selectedIndex')),

            // Loading indicator
            if (_isLoading && isLoadingIndicator)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      bottomNavigationBar: isBottomMenu
          ? BottomNavigationBar(
              items: bottomMenuItems
                  .map(
                    (item) => BottomNavigationBarItem(
                      icon: Icon(
                        Icons.circle,
                      ), // Replace with actual icon mapping
                      label: item['label'] as String,
                    ),
                  )
                  .toList(),
              currentIndex: _selectedIndex,
              backgroundColor: _parseHexColor(config.bottomMenuBgColor),
              selectedItemColor: _parseHexColor(
                config.bottomMenuActiveTabColor,
              ),
              unselectedItemColor: _parseHexColor(config.bottomMenuIconColor),
              onTap: (index) {
                setState(() => _selectedIndex = index);
                final url = bottomMenuItems[index]['url'] as String;
                _launchUrl(url);
              },
            )
          : null,
    );
  }

  Color _parseHexColor(String hexColor) {
    hexColor = hexColor.replaceFirst('#', '');
    if (hexColor.length == 6) hexColor = 'FF$hexColor';
    return Color(int.parse('0x$hexColor'));
  }
}
