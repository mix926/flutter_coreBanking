import '../../domain/entities/bank_account_entity.dart';

class AccountModel extends BankAccountEntity {
  const AccountModel({
    required super.accountId,
    required super.accountNumber,
    required super.accountHolderName, // Fix: was accountHilderName
    required super.balance,
    required super.currency,
    required super.status,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) { // Fix: was fromjson (lowercase j)
    return AccountModel(
      accountId: json['id'].toString(),
      accountNumber: json['accountNumber'],
      accountHolderName: json['accountType'], // backend returns accountType as the display name
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'], // Fix: was 'corrncy'
      status: json['status'] ?? 'ACTIVE',
    );
  }
}
