import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app_state.dart';
import 'package:spark_save/firebase_options.dart';
import 'package:spark_save/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: ((context, child) => const MainApp()),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          colorSchemeSeed: Colors.green,
          brightness: Brightness.light, // Light theme ensures white base colors
          scaffoldBackgroundColor: Colors.white, // White background
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white, // White AppBar
            elevation: 0, // Flat AppBar without shadow
            foregroundColor: Colors.black, // Black text and icons
          ),
          textTheme: GoogleFonts.montserratTextTheme().apply(
            bodyColor: Colors.black, // Black text by default
            displayColor: Colors.black,
          ),
          splashColor: Colors.transparent, // Remove splash color
          highlightColor: Colors.transparent, // Remove highlight color
          splashFactory:
              NoSplash.splashFactory, // Remove material splash effects
          // Control Material color effects
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          buttonTheme: ButtonThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            buttonColor: Colors.transparent, // Remove button color effects
          ),
          cardTheme: const CardTheme(
            color: Colors.white, // Remove surface tint color from cards
            elevation: 0, // Remove card shadow
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.white,
          ),
          drawerTheme: DrawerThemeData(
            backgroundColor: Colors.white,
          )),
      debugShowCheckedModeBanner: false,
      home: const AuthService(),
    );
  }
}
