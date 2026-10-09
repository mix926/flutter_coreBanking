import '../../core/api_client.dart';
import '../models/account_model.dart';

class AccountRemoteDataSource { // Fix: was AccountRemoteDatasource (capital S)
  Future<List<AccountModel>> getAccounts() async {
    try {
      final response = await ApiClient.dio.get('/api/v1/accounts'); // Fix: was /api/v1/account
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => AccountModel.fromJson(json as Map<String, dynamic>)) // Fix: was fromjson
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
