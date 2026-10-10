import 'package:flutter/material.dart';

// ─── Transfer Receipt Screen ──────────────────────────────────────────────────
// Shows transfer success slip with reference number after a completed transfer.

class TransferReceiptScreen extends StatelessWidget {
  final Map<String, dynamic> transactionData;

  const TransferReceiptScreen({super.key, required this.transactionData});

  @override
  Widget build(BuildContext context) {
    final String refNumber = transactionData['referenceNumber'] ?? 'N/A';
    final double amount =
        (transactionData['amount'] as num?)?.toDouble() ?? 0.0;
    final String currency = transactionData['currency'] ?? 'USD';
    final String toAccount = transactionData['toAccountNumber'] ?? 'N/A';
    final String timestamp = transactionData['timestamp'] ?? 'N/A'; // Fix: was 'timetamp'
    final String status = transactionData['status'] ?? 'COMPLETED';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transaction Receipt'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Transfer Successful', // Fix: was 'Tranfer Successful'
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$currency ${amount.toStringAsFixed(2)}', // Fix: missing comma after string
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 32),

            // ── Receipt detail box ───────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildReceiptRow('Status', status),
                  const Divider(), // Fix: was 'Devider'
                  _buildReceiptRow('To Account', toAccount),
                  const Divider(),
                  _buildReceiptRow('Reference No', refNumber),
                  const Divider(),
                  _buildReceiptRow('Date & Time', timestamp),
                ],
              ),
            ),

            const Spacer(),

            // ── Done button ──────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .popUntil((route) => route.isFirst); // Fix: was 'isfirst'
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder( // Fix: borderRadius must be inside shape:
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Done', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
