class TAPIKeys {
  static const String merchantID = String.fromEnvironment('PAYHERE_MERCHANT_ID', defaultValue: '');
  static const String secretKey = String.fromEnvironment('PAYHERE_SECRET_KEY', defaultValue: '');
}
