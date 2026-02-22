import 'package:flutter/material.dart';

class PurchaseListPage extends StatefulWidget {
  const PurchaseListPage({super.key});

  @override
  State<PurchaseListPage> createState() => _PurchaseListPageState();
}

class _PurchaseListPageState extends State<PurchaseListPage> {
  final primaryColor = const Color(0xFF312C51);
  final accentColor = const Color(0xFFF5E6D3);

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
        title: const Text(
          'Purchases',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  children: [
                    Icon(Icons.receipt_long, color: primaryColor, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      'Purchase List',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Compact Card List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: purchases.length,
                  itemBuilder: (context, index) {
                    final p = purchases[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0), // tighter padding
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Small icon/image placeholder
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.receipt,
                                    size: 30, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Main content – everything squeezed horizontally
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // First line: Bill No + Grand Total
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        p['billNo'],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        p['grandTotal'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFB1936B)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  // Supplier + Location (single line)
                                  Text(
                                    "${p['supplier']} • ${p['location']}",
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),

                                  // Date + Added By (single line)
                                  Text(
                                    "${p['date']} • Added by ${p['addedBy']}",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700]),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),

                                  // Status badges + Payment Due (compact)
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          p['purchaseStatus'],
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color:
                                              Colors.orange.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          p['paymentStatus'],
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "Due: ${p['paymentDue']}",
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // 3-dot menu
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert,
                                  color: Color(0xFF312C51), size: 24),
                              onSelected: (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Selected: $value')),
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
}
