class BankAccountEntity {
  final String accountId;
  final String accountNumber;
  final String accountHolderName; // Fix: was accountHilderName
  final double balance;
  final String currency;
  final String status; // Fix: was missing

  const BankAccountEntity({
    required this.accountId,
    required this.accountNumber,
    required this.accountHolderName,
    required this.balance,
    required this.currency,
    required this.status,
  });
}
