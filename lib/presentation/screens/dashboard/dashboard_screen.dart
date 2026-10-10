import 'package:flutter/material.dart';

import '../../../data/datasources/account_remote_datasource.dart';
import '../../../data/repositories/account_repository_impl.dart';
import '../../../domain/entities/bank_account_entity.dart';
import '../../../domain/repositories/account_repository.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final AccountRepository _accountRepository;
  Future<List<BankAccountEntity>>? _accountsFuture;
  @override
  void initState() {
    super.initState();
    _accountRepository = AccountRepositoryImpl(
      remoteDataSource: AccountRemoteDataSource(),
    );
    _accountsFuture = _accountRepository.fetchAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Banking Dashboard'),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
    body: FutureBuilder<List<BankAccountEntity>>(
        future: _accountsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load accounts: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final accounts = snapshot.data ?? [];
          if (accounts.isEmpty) {
            return const Center(child: Text('No active bank accounts found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: accounts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final account = accounts[index];
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.accountHolderName,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        account.accountNumber,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Available Balance'),
                          Text(
                            '${account.currency} ${account.balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}