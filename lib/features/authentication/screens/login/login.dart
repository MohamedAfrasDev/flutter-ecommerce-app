import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/common/styles/spacing_styles.dart';
import 'package:online_shop/common/widgets/form_divider.dart';
import 'package:online_shop/features/authentication/screens/login/widgets/login_header.dart';
import 'package:online_shop/features/authentication/screens/login/widgets/social_buttons.dart';
import 'package:online_shop/features/authentication/screens/signup/signup.dart';
import 'package:online_shop/features/shop_2/screens/controller/customer_controller.dart';
import 'package:online_shop/navigation_menu.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  bool _loading = false;
  bool _obscureText = true;

  Future<void> _signIn(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);


    try {
      final result = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (result.user != null) {
        
        Get.snackbar('Logged In', '✅ Signed in as ${result.user!.email}');
        final storage = GetStorage();
        storage.write('UID', supabase.auth.currentUser!.id.toString());
        Get.offAll(() => NavigationMenu());
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('❌ ${e.message}')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: dark ? TColors.dark : Colors.white),
          child: SingleChildScrollView(
            padding: TSpacingStyles.paddingWithAppBarHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoginHeader(dark: dark),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: TSizes.spaceBetwwenSections),

                      /// Email
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: dark
                                  ? Colors.grey.withOpacity(0.5)
                                  : TColors.dark.withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: dark
                                  ? Colors.white
                                  : TColors.dark,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Enter email'
                                : null,
                      ),

                      const SizedBox(height: TSizes.spaceBetweenInputFields),

                      /// Password with toggle
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() => _obscureText = !_obscureText);
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: dark
                                  ? Colors.grey.withOpacity(0.5)
                                  : TColors.dark.withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: dark
                                  ? Colors.white
                                  : TColors.dark,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? 'Enter password'
                                : null,
                      ),

                      const SizedBox(height: TSizes.spaceBetweenInputFields),

                      /// Sign In button
                      GestureDetector(
                        onTap: () {
                          if (!_loading) _signIn(context);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: TColors.primary,
                            border: Border.all(
                              color: dark
                                  ? TColors.grey.withOpacity(0.5)
                                  : TColors.dark.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              _loading ? 'Signing In...' : 'Sign In',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: TSizes.spaceBetwwenItems),

                /// Create account
                GestureDetector(
                  onTap: () => Get.to(() => const SignupScreen()),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: TColors.primary.withOpacity(0.5),
                      border: Border.all(
                        color: dark
                            ? TColors.grey.withOpacity(0.5)
                            : TColors.dark.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: TSizes.spaceBetwwenItems),
                FormDivider(dark: dark, dividerText: "or sign in with"),
                const SizedBox(height: TSizes.spaceBetwwenSections),

                /// Social Buttons
                const SocialButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
