import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();


  final TextEditingController nameController = TextEditingController();
  var name = ''.obs;
  final hasNameChanged = false.obs;


  final TextEditingController emailController = TextEditingController();
   var email = ''.obs;
  final hasEmailChanged = false.obs;


  final TextEditingController countryCodeController = TextEditingController();
   var countryCode = ''.obs;
  final hasCountryCodeChanged = false.obs;


  final TextEditingController phoneNumberController = TextEditingController();
   var phoneNumber = ''.obs;
  final hasPhoneNumberChanged = false.obs;


  final TextEditingController passwordController = TextEditingController();
   var password = ''.obs;
  final hasPasswordChanged = false.obs;


  final TextEditingController confirmPasswordController = TextEditingController();
   var confirmPassword = ''.obs;
  final hasConfirmPasswordChanged = false.obs;

  @override
  void onInit() {
    super.onInit();

    nameController.addListener(() {
      hasNameChanged.value = isName();
    });

      emailController.addListener(() {
      hasEmailChanged.value = isEmail();
    });

      countryCodeController.addListener(() {
      hasCountryCodeChanged.value = isCounryCode();
    });

      phoneNumberController.addListener(() {
      hasPhoneNumberChanged.value = isPhoneNumber();
    });

      passwordController.addListener(() {
      hasPasswordChanged.value = isPassword();
    });

      confirmPasswordController.addListener(() {
      hasConfirmPasswordChanged.value = isConfirmPassword();
    });
  }

  bool isName(){
    return nameController.text! == name.value;
  }

   bool isEmail(){
    return emailController.text! == email.value;
  }

   bool isCounryCode(){
    return countryCodeController.text! == countryCode.value;
  }

   bool isPhoneNumber(){
    return phoneNumberController.text! == phoneNumber.value;
  }

   bool isPassword(){
    return passwordController.text! == password.value;
  }

   bool isConfirmPassword(){
    return confirmPasswordController.text! == confirmPassword.value;
  }

}