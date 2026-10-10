// ខ្មែរ: នាំចូល Material, ApiClient និងបង្កាន់ដៃទទួលប្រាក់
import 'package:flutter/material.dart';
import '../../../core/api_client.dart';
import 'transfer_receipt_screen.dart';

class TransferScreen extends StatefulWidget {
  // ខ្មែរ: ទទួលយកលេខគណនីរបស់អ្នកផ្ញើពី Dashboard
  final String senderAccountNumber;

  const TransferScreen({
    super.key,
    required this.senderAccountNumber,
  });

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _destinationAccountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _executeTransfer() async {
    final toAccount = _destinationAccountController.text.trim();
    final amountText = _amountController.text.trim();
    final pin = _pinController.text.trim();
    final note = _noteController.text.trim();

    if (toAccount.isEmpty || amountText.isEmpty || pin.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all required fields.';
      });
      return;
    }

    final double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      setState(() {
        _errorMessage = 'Invalid transfer amount.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // ខ្មែរ: ហៅ API /api/v1/transactions/transfer តាមឯកសារ Titan Core Banking
      final response = await ApiClient.dio.post(
        '/api/v1/transactions/transfer',
        data: {
          'fromAccountNumber': widget.senderAccountNumber,
          'toAccountNumber': toAccount,
          'amount': amount,
          'pin': pin,
          if (note.isNotEmpty) 'note': note,
          'idempotencyKey': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );

      if (mounted) {
        // ខ្មែរ: ផ្លាស់ប្តូរទៅកាន់ទំព័រ Receipt នៅពេលផ្ទេរជោគជ័យ
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransferReceiptScreen(
              transactionData: response.data as Map<String, dynamic>,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Transfer failed. Check recipient account or PIN.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _destinationAccountController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Funds'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ខ្មែរ: បង្ហាញព័ត៌មានគណនីរបស់អ្នកផ្ញើ
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.blueAccent),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('From Account', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(
                        widget.senderAccountNumber,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],

            TextField(
              controller: _destinationAccountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Recipient Account Number *',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount (USD) *',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'Security PIN *',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note (Optional)',
                prefixIcon: const Icon(Icons.note),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _executeTransfer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Confirm Transfer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}