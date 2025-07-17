// 🔧 IMPORTS
import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/form_divider.dart';
import 'package:online_shop/features/authentication/screens/login/login.dart';
import 'package:online_shop/features/authentication/screens/login/widgets/social_buttons.dart';
import 'package:online_shop/features/authentication/screens/signup/controller/sign_up_controller.dart';
import 'package:online_shop/features/authentication/screens/signup/widgets/terms_and_condition.dart';
import 'package:online_shop/features/shop_2/screens/controller/customer_controller.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:country_picker/country_picker.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:online_shop/utils/helpers/models/customer_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final controller = Get.put(SignUpController());
  final formKey = GlobalKey<FormState>();

  Country selectedCountry = Country(
    phoneCode: '94',
    countryCode: 'LK',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Sri Lanka',
    example: '760242008',
    displayName: 'Sri Lanka',
    displayNameNoCountryCode: 'Sri Lanka',
    e164Key: '',
  );

  bool isLoading = false;
  bool _obscureText = true;
  bool _obscureTextConfirm = true;

  Future<void> handleSignUp() async {
    if (!formKey.currentState!.validate()) return;
    if (controller.passwordController.text !=
        controller.confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords don't match")));
      return;
    }

    try {
      setState(() => isLoading = true);
      final response = await Supabase.instance.client.auth.signUp(
        email: controller.emailController.text.trim(),
        password: controller.passwordController.text.trim(),
      );

      if (response.user != null) {
       

        final customerController = Get.put(CustomerController());
        final supabase = Supabase.instance.client;
        final newCustomer = CustomerModel(customerID: supabase.auth.currentUser!.id.toString(), customerName: controller.nameController.text.toString(), customerPhoneNumber: controller.countryCodeController.text.toString()+controller.phoneNumberController.text.toString(), customerEmail: controller.emailController.text.toString().trim(), totalOrder: '', totalSpent: '', currentOrders: '', created_at: DateTime.now(), customerImage: 'No Image');

        customerController.checkAndCreateCustomer(newCustomer);
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    controller.countryCodeController.text = selectedCountry.phoneCode;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset(TImages.login, height: 250, repeat: false),
              ),
              Text(
                'Sign up',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBetwwenSections),

              Container(
                decoration: BoxDecoration(
                  color: dark ? Colors.white.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        dark
                            ? Colors.grey.withOpacity(0.5)
                            : TColors.dark.withOpacity(0.2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        /// Name
                        TextFormField(
                          controller: controller.nameController,
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Enter your name' : null,
                          decoration: InputDecoration(
                            labelText: 'Your Name',
                            prefixIcon: const Icon(Iconsax.user),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color:
                                    dark
                                        ? Colors.grey.withOpacity(0.5)
                                        : TColors.dark.withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color:
                                    dark
                                        ? Colors.white.withOpacity(1)
                                        : TColors.dark.withOpacity(1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBetweenInputFields),

                        /// Email
                        TextFormField(
                          controller: controller.emailController,
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Enter your email' : null,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: const Icon(Iconsax.direct),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color:
                                    dark
                                        ? Colors.grey.withOpacity(0.5)
                                        : TColors.dark.withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color:
                                    dark
                                        ? Colors.white.withOpacity(1)
                                        : TColors.dark.withOpacity(1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBetweenInputFields),

                        /// Phone + Country
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: true,
                                  onSelect: (Country country) {
                                    setState(() {
                                      selectedCountry = country;
                                      controller.countryCodeController.text =
                                          selectedCountry.phoneCode;
                                    });
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '+${selectedCountry.phoneCode}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: controller.phoneNumberController,
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? 'Enter phone number'
                                            : null,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  prefixIcon: Icon(Iconsax.call),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          dark
                                              ? Colors.grey.withOpacity(0.5)
                                              : TColors.dark.withOpacity(0.2),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    borderSide: BorderSide(
                                      color:
                                          dark
                                              ? Colors.white.withOpacity(1)
                                              : TColors.dark.withOpacity(1),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.spaceBetweenInputFields),

                        /// Password
                        TextFormField(
                          controller: controller.passwordController,
                          obscureText: _obscureText,
                          validator:
                              (value) =>
                                  value!.length < 6
                                      ? 'Password must be 6+ characters'
                                      : null,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Iconsax.password_check),
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
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color:
                                    dark
                                        ? Colors.grey.withOpacity(0.5)
                                        : TColors.dark.withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color:
                                    dark
                                        ? Colors.white.withOpacity(1)
                                        : TColors.dark.withOpacity(1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBetweenInputFields),

                        /// Confirm Password
                        TextFormField(
                          controller: controller.confirmPasswordController,
                          obscureText: _obscureTextConfirm,
                          
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Re-enter your password'
                                      : null,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(Iconsax.password_check),
                            suffixIcon: IconButton(
                            icon: Icon(
                              _obscureTextConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() => _obscureTextConfirm = !_obscureTextConfirm);
                            },
                          ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color:
                                    dark
                                        ? Colors.grey.withOpacity(0.5)
                                        : TColors.dark.withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color:
                                    dark
                                        ? Colors.white.withOpacity(1)
                                        : TColors.dark.withOpacity(1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBetwwenSections),
              TermsAndCondition(dark: dark),
              const SizedBox(height: TSizes.spaceBetwwenSections),

              /// 🔘 Submit Button
              GestureDetector(
                onTap: isLoading ? null : handleSignUp,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isLoading ? TColors.grey : TColors.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                            : Text(
                              'Create Account',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Colors.white),
                            ),
                  ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBetwwenItems),

              /// 🔁 Login Navigation
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: TColors.primary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Log In',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: TSizes.spaceBetwwenSections),
              FormDivider(dark: dark, dividerText: 'or sign up with'),
              const SizedBox(height: TSizes.spaceBetwwenItems),
              const SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
