import 'package:flutter/material.dart';

class SellListPage extends StatefulWidget {
  const SellListPage({super.key});

  @override
  State<SellListPage> createState() => _SellListPageState();
}

class _SellListPageState extends State<SellListPage> {
  final primaryColor = const Color(0xFF312C51);
  final accentColor = const Color(0xFFF5E6D3);

  final List<Map<String, dynamic>> sales = [
    {
      'invoiceNo': '2026-000021',
      'customerName': 'Vianet Communication Ltd., Mrs. Punam KC',
      'isSample': 'No',
      'contactNumber': '0',
      'location': 'Beyond Tech Nepal Pvt. Ltd.',
      'paymentStatus': 'Due',
      'paymentMethod': 'N/A',
      'totalAmount': 'Rs 31,640.00',
      'totalPaid': 'Rs 0.00',
      'sellDue': 'Rs 31,640.00',
      'sellReturnDue': 'Rs 0.00',
      'shippingStatus': 'N/A',
      'totalItems': '1.00',
      'addedBy': 'Anup Lal Manandhar',
      'sellNote': '',
      'staffNote': '',
      'shippingDetails': '',
    },
    {
      'invoiceNo': '2026-000022',
      'customerName': 'Mr. Rajesh Sharma',
      'isSample': 'No',
      'contactNumber': '9841234567',
      'location': 'Beyond Tech Nepal Pvt. Ltd.',
      'paymentStatus': 'Paid',
      'paymentMethod': 'Cash',
      'totalAmount': 'Rs 45,890.00',
      'totalPaid': 'Rs 45,890.00',
      'sellDue': 'Rs 0.00',
      'sellReturnDue': 'Rs 0.00',
      'shippingStatus': 'Delivered',
      'totalItems': '3.00',
      'addedBy': 'Sita Thapa',
      'sellNote': 'Urgent delivery',
      'staffNote': 'Customer requested fast shipping',
      'shippingDetails': 'Delivered via Courier',
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
        title: const Row(
          children: [
            Text(
              'Sales',
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
                    Icon(Icons.receipt_long_outlined,
                        color: primaryColor, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      'All Sales',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: sales.length,
                  itemBuilder: (context, index) {
                    final sale = sales[index];
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
                                // Invoice icon placeholder
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
                                        sale['invoiceNo'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        sale['customerName'],
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 12),

                                      // Details in two columns
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildInfoRow('Is Sample',
                                                    sale['isSample']),
                                                _buildInfoRow('Contact Number',
                                                    sale['contactNumber']),
                                                _buildInfoRow('Location',
                                                    sale['location']),
                                                _buildInfoRow('Payment Status',
                                                    sale['paymentStatus']),
                                                _buildInfoRow('Payment Method',
                                                    sale['paymentMethod']),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildInfoRow('Total Amount',
                                                    sale['totalAmount']),
                                                _buildInfoRow('Total Paid',
                                                    sale['totalPaid']),
                                                _buildInfoRow('Sell Due',
                                                    sale['sellDue']),
                                                _buildInfoRow('Sell Return Due',
                                                    sale['sellReturnDue']),
                                                _buildInfoRow('Shipping Status',
                                                    sale['shippingStatus']),
                                                _buildInfoRow('Total Items',
                                                    sale['totalItems']),
                                                _buildInfoRow('Added By',
                                                    sale['addedBy']),
                                                _buildInfoRow('Sell Note',
                                                    sale['sellNote']),
                                                _buildInfoRow('Staff Note',
                                                    sale['staffNote']),
                                                _buildInfoRow(
                                                    'Shipping Details',
                                                    sale['shippingDetails']),
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
                                        value: 'View Invoice',
                                        child: Text('View Invoice')),
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
