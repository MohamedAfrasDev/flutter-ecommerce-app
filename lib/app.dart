import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/features/shop/screens/home/controllers/home_controllers.dart';
import 'package:online_shop/features/splash_screen/splash_screen.dart';
import 'package:online_shop/utils/http/payments/payhere/payhere_controller.dart';
import 'package:online_shop/utils/theme/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final controller = Get.put(HomeControllers());
  final paymentController = Get.put(PayhereController());

  @override
  void initState() {
    super.initState();
    controller.loadThemeMode();
    _loadAppConfig();
    paymentController.getAppPaymentCredentials();
  }

  Future<void> _loadAppConfig() async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.from('app_config').select('title, value');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: controller.themeMode.value,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
