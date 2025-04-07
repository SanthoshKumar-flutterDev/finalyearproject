import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfoliobuilder/pagerouting/router.dart';
import 'package:portfoliobuilder/provider/template_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyD0DTukbiW1m1lyP3p8Lk7pY1fkmRVDAjI',
        appId: '1:521110865376:web:9ffcfc19b70f6d3fad5785',
        messagingSenderId: '521110865376',
        projectId: "flutterwebconnection-835d3",
      )
  );

  await Supabase.initialize(
    url: 'https://tjcpftqguloltbtzhlfy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRqY3BmdHFndWxvbHRidHpobGZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM4NDMzNTYsImV4cCI6MjA1OTQxOTM1Nn0.qvYtgmxmmguDIV6dzXbdt5ECuJW2okr96II9HHm6Ekk',
  );

  runApp(ChangeNotifierProvider(
    create: (context) => TemplateProvider(),
      child: MyApp()));
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: route,
          theme: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme()
          ),
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
              child: widget!,
            );
          },
        );
      },
    );
  }
}