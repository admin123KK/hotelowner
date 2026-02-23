import 'package:flutter/material.dart';

class SellListPage extends StatefulWidget {
  const SellListPage({super.key});

  @override
  State<SellListPage> createState() => _SellListPageState();
}

class _SellListPageState extends State<SellListPage> {
  final primaryColor = const Color(0xFF312C51);
  final accentColor = const Color(0xFFF5E6D3);
  final greenColor = Colors.green.shade700;
  final redColor = Colors.red.shade700;

  final List<Map<String, dynamic>> sales = [
    {
      'invoiceNo': '2026-000021',
      'date': '2026-02-20',
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
      'totalItems': '1',
      'addedBy': 'Anup Lal Manandhar',
      'sellNote': '',
      'staffNote': '',
      'shippingDetails': '',
    },
    {
      'invoiceNo': '2026-000022',
      'date': '2026-02-21',
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
      'totalItems': '3',
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
              'Sales List',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -6)),
            ],
          ),
          child: Column(
            children: [
              // Quick stats / filter bar (optional - can remove if not needed)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    _buildStatChip('Total Sales', '2', primaryColor),
                    const SizedBox(width: 12),
                    _buildStatChip('Due', 'Rs 31,640', redColor),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: sales.length,
                  itemBuilder: (context, index) {
                    final sale = sales[index];
                    final isDue = sale['paymentStatus'] == 'Due';
                    final isPaid = sale['paymentStatus'] == 'Paid';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          // TODO: open detail / invoice view
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top row - Invoice + Status badges
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sale['invoiceNo'],
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          sale['date'] ?? '—',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[700]),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          sale['customerName'],
                                          style: TextStyle(
                                            fontSize: 14.5,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  _buildStatusBadge(
                                    sale['paymentStatus'],
                                    isDue ? redColor : greenColor,
                                  ),
                                ],
                              ),

                              const Divider(height: 24),

                              // Key money info
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildMoneyRow(
                                          'Total', sale['totalAmount'],
                                          bold: true),
                                      const SizedBox(height: 4),
                                      _buildMoneyRow('Paid', sale['totalPaid'],
                                          color: greenColor),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      _buildMoneyRow('Due', sale['sellDue'],
                                          color:
                                              isDue ? redColor : Colors.black87,
                                          bold: isDue),
                                      const SizedBox(height: 4),
                                      _buildMoneyRow(
                                          'Items', sale['totalItems'],
                                          small: true),
                                    ],
                                  ),
                                ],
                              ),

                              if (sale['shippingStatus'] != 'N/A' ||
                                  sale['paymentMethod'] != 'N/A') ...[
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    if (sale['shippingStatus'] != 'N/A')
                                      _buildSmallChip(sale['shippingStatus'],
                                          Colors.blueGrey),
                                    if (sale['paymentMethod'] != 'N/A')
                                      _buildSmallChip(
                                          sale['paymentMethod'], Colors.teal),
                                  ],
                                ),
                              ],
                            ],
                          ),
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

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: color)),
          const SizedBox(width: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildMoneyRow(String label, String amount,
      {bool bold = false, bool small = false, Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: small ? 13 : 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: small ? 13.5 : 15,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: color),
      ),
    );
  }
}
