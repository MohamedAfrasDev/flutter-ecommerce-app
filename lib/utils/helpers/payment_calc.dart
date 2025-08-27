class PaymentCalculator {

  

  /// Method 1: If you want to receive `desiredAmount` after the fee
  static double calculateAmountToCharge(double desiredAmount, double fee) {
    double feeRate = fee / 100;
    return desiredAmount / (1 - feeRate);
  }

  /// Method 2: If customer pays productPrice, calculate net amount after fee
  static double calculateNetAmountAfterFee(double productPrice, double fee) {
    double feeRate = fee / 100;
    return productPrice * (1 - feeRate);
  }

  /// Bonus: Calculate just the fee amount
  static double calculateFee(double amount, double fee) {
    return amount * (fee / 100);
  }
}
