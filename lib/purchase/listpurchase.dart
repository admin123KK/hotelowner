import 'package:flutter/material.dart';

class PurchaseListPage extends StatefulWidget {
  const PurchaseListPage({super.key});

  @override
  State<PurchaseListPage> createState() => _PurchaseListPageState();
}

class _PurchaseListPageState extends State<PurchaseListPage> {
  final primaryColor = const Color(0xFF312C51);
  final accentColor = const Color(0xFFF5E6D3);

  // Data from your Purchase List screenshot
  final List<Map<String, dynamic>> purchases = [
    {
      'date': '18-02-2026 11:57',
      'billNo': '007',
      'location': 'Beyond Tech Nepal Pvt. Ltd.',
      'supplier': 'Vianet Communication Ltd.',
      'purchaseStatus': 'Received',
      'paymentStatus': 'Due',
      'grandTotal': 'Rs 260,352.00',
      'purchase': 'Rs 260,352.00',
      'paymentDue': 'Rs 260,352.00',
      'addedBy': 'Anup Lal Manandhar',
    },
    {
      'date': '14-01-2026 13:15',
      'billNo': '2082/83-POOO0036',
      'location': 'Beyond Tech Nepal Pvt. Ltd.',
      'supplier': 'Technovate International Pvt Ltd.',
      'purchaseStatus': 'Received',
      'paymentStatus': 'Due',
      'grandTotal': 'Rs 161,025.00',
      'purchase': 'Rs 161,025.00',
      'paymentDue': 'Rs 161,025.00',
      'addedBy': 'Anup Lal Manandhar',
    },
    {
      'date': '20-08-2025 11:04',
      'billNo': '008',
      'location': 'Beyond Tech Nepal Pvt. Ltd.',
      'supplier': 'Escanc Nepal',
      'purchaseStatus': 'Received',
      'paymentStatus': 'Due',
      'grandTotal': 'Rs 85,597.50',
      'purchase': 'Rs 85,597.50',
      'paymentDue': 'Rs 85,597.50',
      'addedBy': 'Mr. Sameer Gautam',
    },
    {
      'date': '18-07-2025 10:47',
      'billNo': '00017',
      'location': 'Beyond Tech Nepal Pvt. Ltd.',
      'supplier': 'Infisec System Pvt. Ltd.',
      'purchaseStatus': 'Received',
      'paymentStatus': 'Due',
      'grandTotal': 'Rs 109,610.00',
      'purchase': 'Rs 109,610.00',
      'paymentDue': 'Rs 109,610.00',
      'addedBy': 'Mr. Sameer Gautam',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
              'Purchases',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 56)],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  children: [
                    Icon(Icons.receipt_long, color: primaryColor, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      'Purchase List',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // List of Purchase Cards
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: purchases.length,
                  itemBuilder: (context, index) {
                    final purchase = purchases[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Placeholder image (like product list)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.receipt,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Main content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        purchase['billNo'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        purchase['location'],
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 12),

                                      // Purchase details in two columns
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildInfoRow(
                                                    'Date', purchase['date']),
                                                _buildInfoRow('Supplier',
                                                    purchase['supplier']),
                                                _buildInfoRow('Purchase Status',
                                                    purchase['purchaseStatus']),
                                                _buildInfoRow('Payment Status',
                                                    purchase['paymentStatus']),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildInfoRow('Grand Total',
                                                    purchase['grandTotal']),
                                                _buildInfoRow('Purchase',
                                                    purchase['purchase']),
                                                _buildInfoRow('Payment Due',
                                                    purchase['paymentDue']),
                                                _buildInfoRow('Added By',
                                                    purchase['addedBy']),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // 3-dot menu
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert,
                                      color: Color(0xFFB1936B)),
                                  onSelected: (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Selected: $value')),
                                    );
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                        value: 'View', child: Text('View')),
                                    const PopupMenuItem(
                                        value: 'Edit', child: Text('Edit')),
                                    const PopupMenuItem(
                                        value: 'Delete', child: Text('Delete')),
                                    const PopupMenuItem(
                                        value: 'Print', child: Text('Print')),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
