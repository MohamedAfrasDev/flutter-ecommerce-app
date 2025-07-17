import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/features/authentication/screens/login/login.dart';
import 'package:online_shop/features/authentication/screens/onboarding/onBoarding.dart';
import 'package:online_shop/features/maintenence_mode/maintenence_mode.dart';
import 'package:online_shop/features/shop/screens/home/controllers/home_controllers.dart';
import 'package:online_shop/features/splash_screen/splash_screen.dart';
import 'package:online_shop/navigation_menu.dart';
import 'package:online_shop/utils/constants/json_service.dart';
import 'package:online_shop/utils/theme/theme.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async
  await JsonService().loadJson( );

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  final controller = Get.put(HomeControllers());

  bool _isMaintenence = false;

 
  @override
  Widget build(BuildContext context) {
      final storage = GetStorage();
            final suapabase = Supabase.instance.client;

    return GetMaterialApp(
      
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: SplashScreen(),
    );
  }
}
