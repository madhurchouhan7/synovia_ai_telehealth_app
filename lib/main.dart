import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/provider/chat_provider.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/provider/settings_provider.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/provider/health_assessment_controller.dart';
import 'package:synovia_ai_telehealth_app/features/welcome/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synovia_ai_telehealth_app/firebase_options.dart';
import 'features/home/home_page.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  await ChatProvider.initHive();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Activate Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider:
        AndroidProvider.debug, // Change to .playIntegrity for production!
    appleProvider: AppleProvider.debug,
  );

  // Remove splash screen after all initializations are done
  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (context) => HealthAssessmentController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style here for consistency
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: darkBackgroundColor),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Synovia Telehealth App',
      theme: ThemeData.dark(),

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          developer.log(
            'Auth State - ConnectionState: ${snapshot.connectionState}',
          );
          developer.log('Auth State - HasData: ${snapshot.hasData}');
          developer.log('Auth State - Data: ${snapshot.data}');
          developer.log('Auth State - Error: ${snapshot.error}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: darkBackgroundColor,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 50,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Checking authentication...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            developer.log('Auth Error: ${snapshot.error}');
            return Scaffold(
              backgroundColor: darkBackgroundColor,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 60),
                    SizedBox(height: 20),
                    Text(
                      'Authentication Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed:
                          () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => WelcomePage()),
                          ),
                      child: Text('Continue to Welcome'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            final user = snapshot.data;
            developer.log('Final routing - User: ${user?.uid ?? 'null'}');

            if (user == null) {
              return const WelcomePage();
            } else {
              return const HomePage();
            }
          }
        },
      ),
    );
  }
}
