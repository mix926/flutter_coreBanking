import '../../domain/entities/bank_account_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_remote_datasource.dart'; // Fix: was AccountRemoteDatasource (capital S)

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource; // Fix: was AccountRemoteDatasource

  const AccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BankAccountEntity>> fetchAccounts() async { // Fix: was fetchAccount
    final models = await remoteDataSource.getAccounts();
    return models;
  }
}
