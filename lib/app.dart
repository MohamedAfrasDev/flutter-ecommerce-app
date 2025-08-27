import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/features/authentication/screens/login/login.dart';
import 'package:online_shop/features/authentication/screens/onboarding/onBoarding.dart';
import 'package:online_shop/features/maintenence_mode/maintenence_mode.dart';
import 'package:online_shop/features/shop/screens/home/controllers/home_controllers.dart';
import 'package:online_shop/features/splash_screen/splash_screen.dart';
import 'package:online_shop/navigation_menu.dart';
import 'package:online_shop/utils/constants/json_service.dart';
import 'package:online_shop/utils/http/payments/payhere/payhere_controller.dart';
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

  final paymentController = Get.put(PayhereController());


  @override
  void initState(){
    super.initState();
    controller.loadThemeMode();
    printAllAppConfig();
    paymentController.getAppPaymentCredentials();
  }
 
  @override
  Widget build(BuildContext context) {
      final storage = GetStorage();


            

            print("🔴🔴🔴 ${controller.themeMode.value}");
    return GetMaterialApp(
      
      themeMode: controller.themeMode.value,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: SplashScreen(),
    );
  }
  Future<void> printAllAppConfig() async {
  final supabase = Supabase.instance.client;
  final allConfigs = await supabase.from('app_config').select('title, value');
  print('All app_config rows: $allConfigs');
}

}
